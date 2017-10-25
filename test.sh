#!/usr/bin/env bash

FUNCTION_NAME="musicmapper_generate_midi"
AWS_ENV="_dev"

S3_LAMBDA_BUCKET="musicmapper-lambda"

echo "Invoking the $FUNCTION_NAME lambda function.."

aws lambda invoke \
--invocation-type RequestResponse \
--function-name $FUNCTION_NAME$AWS_ENV \
--region eu-west-1 \
--log-type Tail \
--profile moaiii \
--payload '{"notes":["E","B","G#"],"name":"Emaj"}' \
/dev/null | jq -r '.LogResult' | base64 --decode 