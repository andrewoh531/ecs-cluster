#!/usr/bin/env bash

#TODO - need to pass in task number into parameters
#     - need to handle if no updates required on the stack
#     -

cd "$(dirname "$0")"

# Parameters
stackName=ecs-cluster
templateUrl=https://s3-ap-southeast-2.amazonaws.com/andrewoh-cloudformation-templates/ecs-base.yml
command=create

# Check if stack exists but do not print the output to stdout
aws cloudformation describe-stack-resources --stack-name $stackName > /dev/null 2>&1

if [ $? -eq 0 ]
then
  command=update
fi

echo "Executing $command-stack"
aws cloudformation $command-stack --stack-name $stackName --template-url $templateUrl --parameters file://parameters-dev.json --capabilities CAPABILITY_IAM

echo "Executing stack $command..."
aws cloudformation wait stack-$command-complete --stack-name $stackName

if [ $? -eq 0 ]
then
  echo "Stack $command completed"
else
  echo "Error executing $command for stack"
  exit 1
fi

