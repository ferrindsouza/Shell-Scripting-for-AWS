#! /usr/bin/bash
###########################################################
# Author Ferrin D
# Date 01/02/2025

# checking if user entered bucket name or not and list it's contents if it has
# Why Is This Useful for AWS Cloud Engineers?
# Ensures error handling in automation scripts.
# Prevents accidental execution of AWS CLI commands without proper input.
# Saves time by enforcing user input validation before making AWS API calls.

# Version v1
#################################################################################

bucket_Name="$1"

# check if bucket name is empty
if [-z "$bucket_Name"]
then
    echo "Error: No S3 bucket name provided!"
    echo "Usage: ./s3BucketCheck.sh <bucket-name>"
    exit 1
fi

echo "Listing contents of bucket: $bucket_Name"
aws s3 ls s3://$bucket_Name/

