#! /usr/bin/bash
#######################################
# Author Ferrin D
# Date: 03/02/2025
#
# Objective: This script allows a user to start, stop, or check the status of an AWS EC2 instance using a simple case statement.

# Version v1

read -p "Enter your EC2 instance ID: " instance_id
read -p "Choose an action (start/stop/status): " action

case $action in
    start)
        echo "Starting instance $instance_id..."
        aws ec2 start-instances --instance-ids "$instance_id"
        ;;
    stop)
        echo "Stopping instance $instance_id..."
        aws ec2 stop-instances --instance-ids "$instance_id"
        ;;
    status)
        echo "checking status of instance $instance_id"
        aws ec2 describe-instance-status --instance-ids "$instance_id"
        ;;
    *)
        echo "Invalid Option! Please enter 'start', 'stop', or 'status'."
        ;;
esac










