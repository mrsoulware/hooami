#!/bin/bash

INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

echo "INSTANCE-ID = $INSTANCE_ID"

exit 0

