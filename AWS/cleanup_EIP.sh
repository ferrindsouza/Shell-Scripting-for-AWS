#!/usr/bin/bash

############################################################################
# Author Ferrin D
# Date 06/02/2025
# Find and terminate unused Elastic IPs in AWS
#####################################################################

# Fetch all Elastic IPs
EIP_ALLOCATION_IDS=$(aws ec2 describe-addresses --query "Addresses[?AssociationId==null].AllocationId" --output text)

# Check if there are any unused EIPs
if [ -z "$EIP_ALLOCATION_IDS" ]; then
    echo "No unused Elastic IPs found."
    exit 0
fi

echo "Found unused Elastic IPs: $EIP_ALLOCATION_IDS"

# Loop through and release each unused EIP
for ALLOCATION_ID in $EIP_ALLOCATION_IDS; do
    echo "Releasing Elastic IP: $ALLOCATION_ID"
    aws ec2 release-address --allocation-id $ALLOCATION_ID
    echo "Released $ALLOCATION_ID successfully!"
done

exit 0
