#! /bin/bash

# VERSION=$2
FUNCTION_NAME="frontpage_contact_email"
LOCAL_ZIP="index_js.zip"
S3_LAMBDA_BUCKET="frontpage-contact-lambda"

echo "Removing existing package"
rm -f $LOCAL_ZIP

echo "Moving NPM Packages"
mv node_modules/ node_modules_dev/

echo "Updating NPM Packages without dev dependency"
npm install --production

echo "Creating the package"
zip -q -r -X $LOCAL_ZIP index.js node_modules modules/generateMidi.js modules/saveMidiToS3.js

echo "Getting version from S3 (number of objects +1)"
VERSION="$(aws s3 --profile moaiii ls s3://$S3_LAMBDA_BUCKET/$FUNCTION_NAME/ --summarize --recursive | tail -n 2 | sed -n 1p | awk -F" " '{print $3}')"

echo "Uploading version: $VERSION"
aws s3 cp index_js.zip s3://$S3_LAMBDA_BUCKET/$FUNCTION_NAME/v$VERSION.zip --profile moaiii

echo "Updating Removing NPM Packages"
rm -rf node_modules/

echo "Restoring all the npm packages"
mv node_modules_dev/ node_modules/

S3_KEY_SOURCE="$FUNCTION_NAME/v$VERSION.zip"

echo "Updating $FUNCTION_NAME to version: $VERSION ($S3_KEY_SOURCE)"
aws lambda update-function-code \
--profile moaiii \
--function-name $FUNCTION_NAME \
--s3-bucket $S3_LAMBDA_BUCKET \
--s3-key $S3_KEY_SOURCE \