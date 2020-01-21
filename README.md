# fn-sfmc-schedules 

A lambda function that keeps the offer schedules within SFMC up to date by listenerning to events triggered when 
changes are made to Offers or Offers are added to/drop off the website.

## Getting Started

Ensure that you have version 2 of the aws cli client installed, if not install here
* [aws cli v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux-mac.html) - ensure you get the correct package for you OS 

Ensure that you have the correct aws creds set up and your aws2 cli tool is working

## Deployment

run:
```
$ bash packageCodeAndDeploy.sh
```

This command will zip the code found within the src dir and then deply that code using the configuration
found within config.json
