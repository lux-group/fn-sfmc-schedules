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

FUNCTION_NAME=`node .deploy/generate-fn-name ${CONFIG_FILE}`

echo "Config File: ${CONFIG_FILE}"

if [ ! -f ${CONFIG_FILE} ]; then echo "DEPLOYMENT_FAILURE: No config file found for Environment=${ENVIRONMENT}"; exit 1; fi

node .deploy/check-e2es.js ${CONFIG_FILE} ${ENVIRONMENT} ${CIRCLE_TOKEN} || exit 1;

node .deploy/generate-fn-config.js ${CONFIG_FILE} > ${WORKING_DIR}/config.json || { echo 'could not generate config' ; exit 1; };

UPDATE=true

aws2 lambda get-function --function-name ${FUNCTION_NAME} > /dev/null 2>&1 || UPDATE=false

if [ "$UPDATE" = true ] ; then
  echo "Deploying to ${ENVIRONMENT}"

  sed '/$*base64EncodedFile/d; /$*Tags/d; /$*Publish/d' ${WORKING_DIR}/config.json > ${WORKING_DIR}/update.json
  aws2 lambda update-function-configuration --cli-input-json file://${WORKING_DIR}/update.json

  zip -r -X ${WORKING_DIR}/lambda.zip ${ROOT_DIR}/src/*
  base64EncodedFile=`base64 -w 0 ${WORKING_DIR}/lambda.zip`
  cat ${WORKING_DIR}/config.json | sed s:base64EncodedFile:${base64EncodedFile}:g > ${WORKING_DIR}/deployment.json
  aws2 lambda update-function --cli-input-json file://${WORKING_DIR}/deployment.json
else
  echo "Deploying to ${ENVIRONMENT} for the first time"

  zip -r -X ${WORKING_DIR}/lambda.zip ${ROOT_DIR}/src/*
  base64EncodedFile=`base64 -w 0 ${WORKING_DIR}/lambda.zip`
  cat ${WORKING_DIR}/config.json | sed s:base64EncodedFile:${base64EncodedFile}:g > ${WORKING_DIR}/deployment.json
  aws2 lambda create-function --cli-input-json file://${WORKING_DIR}/deployment.json
fi

echo "Deployed"

exit 0;
