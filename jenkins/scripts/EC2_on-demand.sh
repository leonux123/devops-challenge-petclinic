#!/bin/bash

# Script parameters

imageid="ami-a0cfeed8" # Amazon Linux AMI 2018.03.0 (HVM)
instance_type="t2.micro"
key_name="MyKeyPair"
sec_group_TCP="sg-09238c50b5c5aa1c6"
sec_group_8080="sg-0d04e3cac0e005a8d"
wait_seconds="60" # seconds between polls for the public IP to populate (keeps it from hammering their API)
key_location="/home/leonux/aws/MyKeyPair.pem" # SSH settings
user="ec2-user" # SSH settings
jar_file="target/*.jar" # SSH settings
deploy_scripts="jenkins/scripts/deploy/*.sh" # SSH settings


# private
connect ()
{
        ssh -oStrictHostKeyChecking=no -i $key_location $user@$AWS_IP mkdir poc
}

# private
publish ()
{
        ansible all -i hosts -u ec2-user --private-key=$key_location -b -m copy -a "src=hosts dest=~/hosts"
        ansible-playbook jenkins/scripts/ansible/copyfile.yml -i hosts --private-key=$key_location
}

# private
configEnv ()
{

        ansible all -i hosts -u ec2-user --private-key=$key_location -b -a "yum -y update"
        ansible-playbook jenkins/scripts/ansible/configEC2.yml -i hosts --private-key=$key_location
        
}

# private
getip ()
{	
	AWS_IP=$(~/.local/bin/aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
}

# public
start ()
{
	echo "Starting instance..."	
	
	id=$(~/.local/bin/aws ec2 run-instances --image-id $imageid --count 1 --instance-type $instance_type --key-name $key_name --security-group-ids $sec_group_TCP $sec_group_8080 --query 'Instances[0].InstanceId' | grep -E -o "i\-[0-9A-Za-z]+")
	
	INSTANCE_ID=$id
	
	# wait for a public ip
	while true; do

		echo "Waiting $wait_seconds seconds for IP..."
		sleep $wait_seconds
		getip
		if [ ! -z "$AWS_IP" ]; then
			break
		else
			echo "Not found yet. Waiting for $wait_seconds more seconds."
			sleep $wait_seconds
		fi

	done

	echo "Found IP $AWS_IP - Instance $INSTANCE_ID"
	
	echo "Trying to connect... $user@$AWS_IP"
	
	connect
        
        echo "$AWS_IP" > hosts
	
	echo "Publish Over SSH..."
	
	publish
	
	echo "Config Task: Started"
	
	configEnv
	
	echo "Done!"
	
	echo "$AWS_IP" > ip_from_file
	
	echo "$INSTANCE_ID" > id_from_file

}

# public
terminate ()
{
	echo "Shutting down..."
	export KILL_ID=$(cat id_from_file) && ~/.local/bin/aws ec2 terminate-instances --instance-ids $KILL_ID
	
	
}

# public
instruct ()
{
	echo "Please provide an argument: start, terminate"
}

#-------------------------------------------------------

# "main"
case "$1" in
	start)
		start
		;;
	terminate)
		terminate
		;;
	help|*)
		instruct
		;;
esac
