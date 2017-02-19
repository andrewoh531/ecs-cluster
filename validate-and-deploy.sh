#!/usr/bin/env bash

set -e
cd "$(dirname "$0")"

echo "Validating templates..."
aws cloudformation validate-template --template-body file://ecs-base.yml
aws cloudformation validate-template --template-body file://ecs-service.yml

s3Bucket=andrewoh-cloudformation-templates
echo "Template validation successful. Uploading to S3 bucket ${s3Bucket}"

aws s3 cp ecs-base.yml s3://andrewoh-cloudformation-templates/ecs-base.yml
aws s3 cp ecs-service.yml s3://andrewoh-cloudformation-templates/ecs-service.yml