#!/bin/bash

LOG_FILE=$PWD/genexus.log
date=`date`
dt=`date +%Y%m%d`
export dt
echo "--begin">> $LOG_FILE
echo $date >> $LOG_FILE
#sudo apt update && sudo apt upgrade

#exec 2>&1 ${LOG_FILE[1]}

#NOTE: bash v4 required - if running macOS with bash v3, conda environment with bash v4 is required

#FUNCTIONS
#FUNCTION: facility name
function facility_name_fx {
	echo "What is the name of your institution?"
	PS3='Please enter your choice: '
	options=("University at Buffalo" "SUNY Upstate" "University of Rochester" "New York Medical Center" "Wadsworth Center NYSDOH")
	select i in "${options[@]}"
	do
		case $i in
			"University at Buffalo")
				echo "Your files will upload to gs://su_nywws_test_bucket/buffalo"
				echo "gs://su_nywws_test_bucket/buffalo" > facility.txt
				;;
			"SUNY Upstate")
				echo "Your files will upload to gs://su_nywws_test_bucket/suny_upstate"
				echo "gs://su_nywws_test_bucket/suny_upstate" > facility.txt
				;;
			"University of Rochester")
				echo "Your files will upload to gs://su_nywws_test_bucket/rochester"
				echo "gs://su_nywws_test_bucket/rochester" > facility.txt
				;;
			"New York Medical Center")
				echo "Your files will upload to gs://su_nywws_test_bucket/nymc"
				echo "gs://su_nywws_test_bucket/nymc" > facility.txt
				;;
			"Wadsworth Center NYSDOH")
				echo "Your files will upload to gs://su_nywws_test_bucket/wadsworth"
				echo "gs://su_nywws_test_bucket/wadsworth" > facility.txt
				;;
			*) echo "invalid option $REPLY";;
		esac
		break
	done
}
#FUNCTION:ask for ssh key path, create ssh key; look for ssh_path.txt, ask for ssh key path
function ssh_key_fx {
	read -p "Do you have an SSH key (y/n)?" -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		if test -f "ssh_path.txt" ;
		then
			while IFS= read -r line || [[ -n "$line" ]]; do
				ssh_path="$line"
			done < "ssh_path.txt"
			read -p "Do you wish to connect with $ssh_path (y/n)?" -r
			if [[ $REPLY =~ ^[Nn]$ ]]
			then
				read -p 'Enter path to SSH key: ' ssh_path
				echo $ssh_path > ssh_path.txt
				echo "Using $ssh_path"
			fi
		else
			read -p 'Enter path to SSH key: ' ssh_path
			echo $ssh_path > ssh_path.txt
			echo "Using $ssh_path"
		fi
	else
		mkdir -p $PWD/.ssh
		ssh-keygen -t rsa -b 3072 -N '' -f $PWD/.ssh/id_rsa
		ssh_path=$PWD/.ssh/id_rsa
		echo $ssh_path > ssh_path.txt
		echo "You will need to upload your SSH key to the instrument before you can download files and continue. Your SSH key can be found at $ssh_path."
		exit
	fi
}
#FUNCTION:look for instrIP.txt, ask to connect, enter IP
function instr_IP_fx {
	if test -f "instrIP.txt" ;
	then
		while IFS= read -r line || [[ -n "$line" ]]; do
			instrIP="$line"
		done < "instrIP.txt"
		read -p "Do you wish to connect to $instrIP (y/n)? " -r
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
			echo "Using $instrIP"
		else
			read -p 'Enter instrument IP you wish to connect to: ' instrIP
			echo $instrIP > instrIP.txt
			echo "Using $instrIP"
		fi
	else
		read -p 'Enter instrument IP you wish to connect to: ' instrIP
		echo $instrIP > instrIP.txt
		echo "Using $instrIP"
	fi
}
#FUNCTION:create default profile
function create_default_profile_fx {
	read -p 'Do you wish to create a default profile to use later (y/n)? ' -r
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
			while IFS= read -r line || [[ -n "$line" ]]; do
				ssh_path="$line"
			done < "ssh_path.txt"
			echo "ssh_path=$ssh_path" > ${name}_default.txt
			while IFS= read -r line || [[ -n "$line" ]]; do
				instrIP="$line"
			done < "instrIP.txt"
			while IFS= read -r line || [[ -n "$line" ]]; do
				facility="$line"
			done < "facility.txt"
			echo "ssh_path=$ssh_path" > ${name}_default.txt
			echo "instrIP=$instrIP" >> ${name}_default.txt
			echo "facility=$facility" >> ${name}_default.txt
			echo "${name}_default.txt created"
		fi
}
#FUNCTION:number of days, login
function num_days {
	read -p 'How many days ago was the last run (enter numbers only)? ' days
	ssh -i $ssh_path $instrIP -l ionadmin <<-EOF > tmp.txt 2>> $LOG_FILE
		find /data/IR/data/analysis_output/ -type f -ctime -"$days" -name "*.ptrim.bam" -not -path "*block*" -print
	EOF
	grep -F '/data/IR' tmp.txt > log.txt
	cat log.txt >> $LOG_FILE
	rm tmp.txt
	if [ -s log.txt ];
	then
		COUNT=$(wc -l < log.txt)
		DAYSAGO=$(date --date="$days days ago" +%m-%d-%Y)
		echo "$COUNT files found."
		echo "$COUNT files downloaded from $DAYSAGO." >> $LOG_FILE
	else
		echo "There are no results from $days days ago. Please increase the number of days."
		COUNT=$(wc -l < log.txt)
		DAYSAGO=$(date --date="$days days ago" +%m-%d-%Y)
		echo "$COUNT files downloaded from $DAYSAGO." >> $LOG_FILE
		num_days
	fi
	mkdir -p /tmp/nywws
}
#FUNCTION:upload files
function gcp_upload {
	#storage/parallel_composite_upload_enabled False > /dev/null 2>&1
	while IFS= read -r line || [[ -n "$line" ]]; do
		s=$(echo $line | sed "s/.*ChipLane.*\/\(.*\)_LibPrep.*/\1/");
		scp -q -i $ssh_path ionadmin@$instrIP:"$line" /tmp/nywws/$s.ptrim.bam;
		done < log.txt
		echo "Files have been renamed. Proceeding to upload."
		COUNT=$(wc -l < log.txt)
		DAYSAGO=$(date --date="$days days ago" +%m-%d-%Y)
		rm log.txt
		cd /tmp/
		gcloud storage cp nywws/* $facility >> $LOG_FILE 2>&1
		rm /tmp/nywws/*
		echo "Your files have been uploaded."
		echo "$COUNT files uploaded to GCP from $DAYSAGO." >> $LOG_FILE
}





#SCRIPTS
#check for default profile
read -p "What is your name?  " name
export $name
if test -f "${name}_default.txt" ;
then
	ssh_path=$(awk -F= '/ssh/{print $2}' ${name}_default.txt)
	instrIP=$(awk -F= '/instr/{print $2}' ${name}_default.txt)
	facility=$(awk -F= '/facility/{print $2}' ${name}_default.txt)
	echo "$ssh_path"
	echo "$instrIP"
	echo "$facility"
	read -p 'Do you wish to use the above credentials (y/n)? ' -r
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
			echo "Using default profile. Logging into $instrIP with $ssh_path" | tee -a $LOG_FILE
		else
			facility_name_fx
			ssh_key_fx
			instr_IP_fx
			create_default_profile_fx
			echo "Logging into $instrIP with $ssh_path" | tee -a $LOG_FILE
		fi
else
	facility_name_fx
	ssh_key_fx
	instr_IP_fx
	create_default_profile_fx
	echo "Logging into $instrIP with $ssh_path" | tee -a $LOG_FILE
fi


#log2 saved with date
varlog1=$(find . -type f -name "log_[0-9]*.txt");
varlog=${varlog1:2}
#DOES NOT WORK WITH MULTIPLE FILES
if [[ -e $varlog ]]; then
	echo "$varlog was never uploaded." | tee -a $LOG_FILE
	read -p 'Would you like to upload now?' -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		while IFS= read -r line || [[ -n "$line" ]]; do
		s=$(echo $line | sed "s/.*ChipLane.*\/\(.*\)_LibPrep.*/\1/");
		scp -q -i $ssh_path ionadmin@$instrIP:"$line" /tmp/nywws/$s.ptrim.bam;
		done < $varlog1
		COUNT=$(wc -l < $varlog1)
		DAYSAGO=$(date --date="$days days ago" +%m-%d-%Y)
		rm $varlog
		cd /tmp/
		gcloud storage cp -r nywws/ gs://su_nywws_test_bucket/test
		rm /tmp/nywws/*
		echo "$COUNT files have been uploaded." | tee -a $LOG_FILE
	else
		echo "These should be uploaded soon, please do not forget about them. Goodbye!"
	fi
fi
#previous log.txt exists
if test -f "log.txt" ;
then
	echo "You have a log file that was not previously uploaded." | tee -a $LOG_FILE
	read -p "Do you wish to overwrite this file (y/n)? " -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo "Overwriting file..." | tee -a $LOG_FILE
		num_days
		read -p "Do you wish to upload these now (y/n)? " -r
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
			echo "Proceeding... Please wait."
			gcp_upload
		fi
	else
		read -p "Do you wish to upload these now (y/n)? " -r
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
			echo "Proceeding... Please wait."
			gcp_upload
			read -p "Would you like to check for newer files (y/n) " -r
			if [[ $REPLY =~ ^[Yy]$ ]]
			then
				num_days
				read -p "Do you wish to upload these now (y/n)? " -r
				if [[ $REPLY =~ ^[Yy]$ ]]
				then
					echo "Proceeding... Please wait."
					gcp_upload
				fi
			fi
		else
			log2=$(echo log2_${dt}.txt)
			mv log.txt $log2
			echo "The old log file is saved as $PWD/$log2. You can upload this at another time." | tee -a $LOG_FILE
		fi
	fi
else
	num_days
	read -p "Do you wish to upload these now (y/n)? " -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo "Proceeding... Please wait."
		gcp_upload
	else
		read -p "Are you sure you do NOT want to upload your files (Y/n)? " -r
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
			echo "A list of your files is saved in log.txt. You will have the option to upload next time." | tee -a $LOG_FILE
		else
			echo "Proceeding to upload files." | tee -a $LOG_FILE
			gcp_upload
		fi
	fi
fi
echo "Goodbye! :)"
echo $date >> $LOG_FILE
echo "end--">> $LOG_FILE
echo >> $LOG_FILE
echo >> $LOG_FILE
exit
