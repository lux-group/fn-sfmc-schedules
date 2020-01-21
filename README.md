# fn-sfmc-schedules 

A lambda function that keeps the offer schedules within SFMC up to date by listenerning to events triggered when 
changes are made to Offers or Offers are added to/drop off the website.

## Getting Started

Ensure that you have version 2 of the aws cli client installed, if not install here
* [aws cli v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux-mac.html) - ensure you get the correct package for you OS 

Ensure that you have the correct aws creds set up and your aws2 cli tool is working

## Deployment

To update the function run: 
run:
```
$ bash updateFunction.bash
```

This will update the code being executed by the lambda function.

In order to do this the script will:

1. Zip the src dir into a zip file
2. Base64 encode the given zip file
3. Update the config.json file with the given base64 value
4. Use this updated json file to update the function


To deploy the function for the first time run: 

```
$ bash createFunction.bash
```

