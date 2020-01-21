#!/bin/bash

echo "updating function configuration"
sed '/$*base64EncodedFile/d; /$*Tags/d; /$*Publish/d' config.json > update_config.json
aws2 lambda update-function-configuration --cli-input-json file://update_config.json
rm update_config.json


echo "updating function code"
cd src; zip -r -X "../fn-sfmc-schedules.zip" *; cd ..
base64EncodedFile=$(base64 fn-sfmc-schedules.zip)
sed 's:base64EncodedFile:'${base64EncodedFile}':' update.json > deployment.json
aws2 lambda update-function-code --cli-input-json file://deployment.json
rm fn-sfmc-schedules.zip
rm deployment.json
