#!/bin/bash
zip -r -X "fn-sfmc-schedules.zip" src/*
base64EncodedFile=$(base64 fn-sfmc-schedules.zip)
echo $base64EncodedFile
sed 's:base64EncodedFile:'${base64EncodedFile}':' update.json > deployment.json
cat deployment.json
aws2 lambda update-function-code --cli-input-json file://deployment.json
rm fn-sfmc-schedules.zip
rm deployment.json
