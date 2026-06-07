#!/bin/bash

SG_ID="sg-057bbd40346b0a45f"
AMI_ID="ami-0220d79f3f480ecf5"

for instance in "$@"
do
    instance_id=$(aws ec2 run-instances \
        --image-id "$AMI_ID" \
        --instance-type t3.micro \
        --security-group-ids "$SG_ID" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$@}]" \
        --query 'Instances[0].InstanceId' \
        ##--query 'Instances[0].PrivateIpAddress' \
        --output text)

    rc=$?gi

    if [ $rc -ne 0 ]; then
        echo "Failed to launch instance: $instance"
        exit 1
    else
        echo "InstanceId=$instance_id launched successfully"
    fi
done
  echo "Name=$@ launched successfully"
  ##echo "private ip address =$instance_id lanched successfully"

if [ $instance == "frontend" ]; then
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[].Instances[].PublicIpAddress' \
            --output text
        )
        ##RECORD_NAME="$DOMAIN_NAME" # daws88s.online
    else
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[].Instances[].PrivateIpAddress' \
            --output text
        )
        RECORD_NAME="$instance.$DOMAIN_NAME" # mongodb.daws88s.online
    fi

    echo "IP address of $instance is $IP"