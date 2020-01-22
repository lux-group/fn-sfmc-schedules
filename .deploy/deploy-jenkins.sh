#!/bin/bash -e

. ~/.nvm/nvm.sh
nvm install
nvm use

yarn install
yarn build

CURRENT_DIR="`dirname \"$0\"`"
CURRENT_DIR="`( cd \"$CURRENT_DIR\" && pwd )`"
ROOT_DIR=$CURRENT_DIR/..

ENVIRONMENT=$1

echo "Environment: ${ENVIRONMENT}"

if [ ! ${ENVIRONMENT} ]; then echo "Must supply an environment as the first argument"; exit 1; fi

CONFIG_FILE="${ROOT_DIR}/deploy/${ENVIRONMENT}-up.json"

echo "Config File: ${CONFIG_FILE}"

if [ ! -f ${CONFIG_FILE} ]; then echo "DEPLOYMENT_FAILURE: No config file found for Environment=${ENVIRONMENT}"; exit 1; fi

node .deploy/check-e2es.js ${CONFIG_FILE} ${ENVIRONMENT} ${CIRCLE_TOKEN} || exit 1;

node .deploy/generate-fn-config.js ${CONFIG_FILE} > ${ROOT_DIR}/config.json || { echo 'could not generate config' ; exit 1; };

echo "Deploying to ${ENVIRONMENT}"

echo "Colin to replace" || { echo 'deploy failed' ; exit 1; }

echo "Deployed"

exit 0;
