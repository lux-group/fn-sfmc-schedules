#!/bin/bash -e

. ~/.nvm/nvm.sh
nvm install
nvm use

yarn install
yarn build

CURRENT_DIR="`dirname \"$0\"`"
CURRENT_DIR="`( cd \"$CURRENT_DIR\" && pwd )`"
ROOT_DIR=$CURRENT_DIR/..
WORKING_DIR=$ROOT_DIR/.deploy/tmp

rm -rf $WORKING_DIR
mkdir $WORKING_DIR

ENVIRONMENT=$1

echo "Environment: ${ENVIRONMENT}"

if [ ! ${ENVIRONMENT} ]; then echo "Must supply an environment as the first argument"; exit 1; fi

CONFIG_FILE="${ROOT_DIR}/deploy/${ENVIRONMENT}-fn.json"

FUNCTION_NAME=`node .deploy/get-function-name.js ${CONFIG_FILE}`

echo "Config File: ${CONFIG_FILE}"

if [ ! -f ${CONFIG_FILE} ]; then echo "DEPLOYMENT_FAILURE: No config file found for Environment=${ENVIRONMENT}"; exit 1; fi

node .deploy/check-e2es.js ${CONFIG_FILE} ${ENVIRONMENT} ${CIRCLE_TOKEN} || exit 1;

echo "generating config files ....."
node .deploy/create-function.js ${CONFIG_FILE} > ${WORKING_DIR}/create-function.json \
  || { echo 'could not generate create function json' ; exit 1; };
node .deploy/update-function-code.js ${CONFIG_FILE} > ${WORKING_DIR}/update-function-code.json \
  || { echo 'could not generate update function code json' ; exit 1; };
node .deploy/update-function-configuration.js ${CONFIG_FILE} > ${WORKING_DIR}/update-function-configuration.json \
  || { echo 'could not generate update function configuration json' ; exit 1; };

echo "generating zip file ....."
cd ${ROOT_DIR}/src
zip -r -X ${WORKING_DIR}/lambda.zip * > /dev/null
base64EncodedFile=`base64 -w 0 ${WORKING_DIR}/lambda.zip`

echo "determine action ....."
ACTION="update"
aws2 lambda get-function --function-name ${FUNCTION_NAME} > /dev/null 2>&1 || ACTION="create"
echo "action is ${ACTION}."

cat ${WORKING_DIR}/create-function.json | sed s:base64EncodedFile:${base64EncodedFile}:g > ${WORKING_DIR}/create-deployment.json
cat ${WORKING_DIR}/update-function-code.json | sed s:base64EncodedFile:${base64EncodedFile}:g > ${WORKING_DIR}/update-deployment.json

echo "deploying to ${ENVIRONMENT}"

if [ "$ACTION" = "update" ] ; then
  aws2 lambda update-function-configuration --cli-input-json file://${WORKING_DIR}/update-function-configuration.json > /dev/null
  aws2 lambda update-function-code --cli-input-json file://${WORKING_DIR}/update-deployment.json > /dev/null
fi

if [ "$ACTION" = "create" ] ; then
  aws2 lambda create-function --cli-input-json file://${WORKING_DIR}/create-deployment.json
fi

echo "done."

exit 0;
