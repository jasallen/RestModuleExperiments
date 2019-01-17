#!/bin/bash

# Replace the following URL with a public GitHub repo URL
gitrepo=https://github.com/jasallen/RestModuleExperiments
gitpath=RestModuleExperiments/BookServer/BookServer/BookServer.csproj
webappname=bookserver$RANDOM

# Create a resource group.
az group create --location westus --name MyXam150ResourceGrp

# Create an App Service plan in STANDARD tier (minimum required by deployment slots).
az appservice plan create --name $webappname --resource-group MyXam150ResourceGrp --sku S1

# Create a web app.
az webapp create --name $webappname --resource-group MyXam150ResourceGrp \
--plan $webappname

az webapp config appsettings set -g MyXam150ResourceGrp -n $webappname --settings PROJECT=$gitpath

#Create a deployment slot with the name "staging".
az webapp deployment slot create --name $webappname --resource-group MyXam150ResourceGrp \
--slot staging

# Deploy sample code to "staging" slot from GitHub.
az webapp deployment source config --name $webappname --resource-group MyXam150ResourceGrp \
--slot staging --repo-url $gitrepo --branch master --manual-integration

# Copy the result of the following command into a browser to see the staging slot.
echo http://$webappname-staging.azurewebsites.net

# Swap the verified/warmed up staging slot into production.
az webapp deployment slot swap --name $webappname --resource-group MyXam150ResourceGrp \
--slot staging

# Copy the result of the following command into a browser to see the web app in the production slot.
echo http://$webappname.azurewebsites.net

# Delete the Resources
# az group delete --name myResourceGroup