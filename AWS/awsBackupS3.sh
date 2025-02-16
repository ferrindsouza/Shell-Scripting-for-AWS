#!/usr/bin/bash

# Ask user for compression level and backup directory
read -p "Choose H, M, or L compression: " file_compression
read -p "Which directory do you want to backup to: " dir_name
read -p "Enter your AWS S3 bucket name: " bucket_name

# Check if an S3 bucket name was provided
if [ -z "$bucket_name" ]; then
    echo "Error: No S3 bucket name provided!"
    exit 1
fi

# Create backup directory if it doesn’t exist with 700 permission so only owner can rwx
backup_dir="$HOME/$dir_name"
test -d "$backup_dir" || mkdir -m 700 "$backup_dir"

# Define tar commands for different compression levels
tar_l="-cvf $backup_dir/b.tar --exclude=$backup_dir $HOME"
tar_m="-czvf $backup_dir/b.tar.gz --exclude=$backup_dir $HOME"
tar_h="-cjvf $backup_dir/b.tar.bzip2 --exclude=$backup_dir $HOME"

# Assign the correct tar command based on user input
if [ "$file_compression" = "L" ] ; then
    tar_opt=$tar_l
    backup_file="$backup_dir/b.tar"
elif [ "$file_compression" = "M" ]; then
    tar_opt=$tar_m
    backup_file="$backup_dir/b.tar.gz"
else
    tar_opt=$tar_h
    backup_file="$backup_dir/b.tar.bzip2"
fi

# Create the backup file
tar $tar_opt

# Upload backup to AWS S3
echo "Uploading backup to S3..."
aws s3 cp "$backup_file" "s3://$bucket_name/"

# Confirm upload
if [ $? -eq 0 ]; then
    echo "Backup successfully uploaded to S3: s3://$bucket_name/$(basename $backup_file)"
else
    echo "Upload failed!"
fi

exit 0
