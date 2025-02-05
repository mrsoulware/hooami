#!/bin/bash

PARAM=$1
OUTPUT=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/${PARAM})

echo "[ PARAM ]= $1"
echo "[ OUTPUT ]= $OUTPUT"

exit 0

