#!/usr/bin/bash

# Set the threshold in hours (e.g., 6 hours)

THRESHOLD=6

# Get the current time in epoch seconds
current_time=$(date +%s)

# Retrieve running instances with InstanceId and LaunchTime.
# The AWS CLI query outputs two columns: InstanceId and LaunchTime.
instances=$(aws ec2 describe-instances \
            --filters Name=instance-state-name,Values=running \
            --query 'Reservations[*].Instances[*].[InstanceId,LaunchTime]' \
            --output text)

# Loop through each line of the output
# instance_id, launch_time are new variables thatstores the instance_id and launch_time seperatly.

echo "$instances" | while read instance_id launch_time; do
    # Convert the LaunchTime (ISO 8601 format) to epoch seconds.
    # The -d option of date accepts the AWS timestamp.
    instance_epoch=$(date -d "$launch_time" +%s)

    # Calculate how many hours the instance has been running.
    age_hours=$(( (current_time - instance_epoch) / 3600 ))
    
    echo "Instance $instance_id has been running for $age_hours hours."

    # If the instance's age exceeds the threshold, stop the instance.
    if [ "$age_hours" -gt "$THRESHOLD" ]; then
        echo "Stopping instance $instance_id (running for more than $THRESHOLD hours)..."
        aws ec2 stop-instances --instance-ids "$instance_id"
    else
        echo "Instance $instance_id is within the threshold."
    fi
done

exit 0

