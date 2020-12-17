#!/bin/bash
set -euo pipefail

STACK="s3-replication-source-stack"

echo "START: Stack Deployment"
# HACK: AWS_PAGER="" -- Container does not have 'less'
AWS_PAGER="" aws cloudformation deploy \
    --template-file "./source.yml" \
    --stack-name "$STACK" \
    --capabilities CAPABILITY_NAMED_IAM \
    --no-fail-on-empty-changeset
echo "DONE: Stack Deployment"

if [[ $(aws cloudformation describe-stacks --stack-name "$STACK" --query "Stacks[0].StackStatus") == *"CREATE"* ]]; then
    echo "START: wait stack-create-complete"
    aws cloudformation wait stack-create-complete --stack "$STACK"
    echo "DONE: wait stack-create-complete"
else
    echo "START: wait stack-update-complete"
    aws cloudformation wait stack-update-complete --stack "$STACK"
    echo "DONE: wait stack-update-complete"
fi