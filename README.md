# fn-sfmc-schedules 

A lambda function that keeps the offer schedules within SFMC up to date by listenerning to events triggered when 
changes are made to Offers or Offers are added to/drop off the website.

## Getting Started

Ensure that you have version 2 of the aws cli client installed, if not install here
* [aws cli v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux-mac.html) - ensure you get the correct package for you OS 

Ensure that you have the correct aws creds set up and your aws2 cli tool is working

## Configuration

To set the configuration at function creation time alter the config.json file

To alter the configuration once the function is running alter the update.json file

## Deployment

###To update the function run: 
```
$ bash updateFunction.bash
```

This will update the configuration and the code being executed by the lambda function.

###To deploy the function for the first time run: 

```
$ bash createFunction.bash
```

# Rollback

To rollback to a older version of the code revert the to that version within github, then run the update function command.

# Delete function

```
$ aws2 lambda delete-function --function-name fn-sfmc-schedules
```
