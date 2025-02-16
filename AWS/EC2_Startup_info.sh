#! /usr/bin/bash
##############################
# Author Ferrin D
# Date 05/02/2025
#
# Retrieves details of specific ec2 instance
#
# Version v1
####################################

if [ -z "$1" ]
then
echo "Usage: $0 <instance-id>"
exit 1
fi 

instance_id=$1
echo "Ec2 instance information: "
aws ec2 describe-instances --instance-ids "$instance_id" --query "Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType]" --output table