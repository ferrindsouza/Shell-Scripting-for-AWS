#! /usr/bin/bash

############################################################################
# Author Ferrin D
# Date 06/02/2025
# Alert if Disk space is bellow threshold for ec2
#####################################################################

# set thresh in %
threshold=20

# Get instance ID use another URL that you find on your aws account
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# Get available disk space on root volume (/)
AVAILABLE_SPACE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

echo "Instance ID: $INSTANCE_ID"
echo "Available disk space: $AVAILABLE_SPACE%"

# Check if disk space is below threshold
if [ "$AVAILABLE_SPACE" -lt "$THRESHOLD" ]; then
    echo "Warning: Available disk space is below $THRESHOLD%! Taking action..."

    # Get the root EBS volume ID
    VOLUME_ID=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID \
        --query "Reservations[*].Instances[*].BlockDeviceMappings[0].Ebs.VolumeId" \
        --output text)

    echo "Root volume ID: $VOLUME_ID"

    # Increase EBS volume size (e.g., to 20GB, adjust as needed)
    NEW_SIZE=20
    aws ec2 modify-volume --volume-id $VOLUME_ID --size $NEW_SIZE
    echo "Requested volume expansion to ${NEW_SIZE}GB."

    # Optional: Send AWS SNS Alert
    SNS_TOPIC="arn:aws:sns:region:account-id:topic-name"
    aws sns publish --topic-arn "$SNS_TOPIC" --message "EC2 $INSTANCE_ID: Low Disk Space Alert! Expanding EBS Volume."

else
    echo "Disk space is sufficient."
fi

exit 0