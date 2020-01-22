#!/bin/bash
cd src; zip -r -X "../fn-sfmc-schedules.zip" *; cd ..
base64EncodedFile=$(base64 fn-sfmc-schedules.zip)
echo $base64EncodedFile
sed 's:base64EncodedFile:'${base64EncodedFile}':' config.json > deployment.json
cat deployment.json
aws2 lambda create-function --cli-input-json file://deployment.json
rm fn-sfmc-schedules.zip
rm deployment.json
