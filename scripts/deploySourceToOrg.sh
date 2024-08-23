#!/bin/zsh
echo " "
echo "*******************************************"
echo "DEPLOY SOURCE TO YOUR ORG "
echo "*******************************************"
echo "What is Alias of the org would you like to give to deploy to?"
read targetOrgName

sf project deploy start --source-dir "../force-app/main/default" --target-org $targetOrgName