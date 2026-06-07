SG_ID="sg-057bbd40346b0a45f"
AMI_ID="ami-0220d79f3f480ecf5"
$rc  = $?

for instance $@
do 
  instance_id=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type t3.micro \
    --security-group-ids $SG_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Harsha,Value=vardhan}]' \
    --query 'Instances[0].PrivateIpAddress' \
    --output text)

done
if [ $rc -ne 0 ]; then
  echo "Failed to launch instances"
  exit 1
else
  echo "InstanceId=$instance_id launched successfully"
fi