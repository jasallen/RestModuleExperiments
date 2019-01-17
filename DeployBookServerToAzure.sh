#!/bin/bash

# Replace the following URL with a public GitHub repo URL
gitrepo=https://github.com/jasallen/RestModuleExperiments
gitpath=BookServer/BookServer/BookServer.csproj
webappname=bookserver$RANDOM

# Create a resource group.
az group create --location westus --name MyXam150ResourceGroup

# Create an App Service plan in STANDARD tier (minimum required by deployment slots).
az appservice plan create --name $webappname --resource-group MyXam150ResourceGroup --sku S1

# Create a web app.
az webapp create --name $webappname --resource-group MyXam150ResourceGroup \
--plan $webappname

az webapp config appsettings set -g MyXam150ResourceGroup -n $webappname --settings PROJECT=$gitpath

# Deploy sample code from GitHub.
az webapp deployment source config --name $webappname --resource-group MyXam150ResourceGroup \
--repo-url $gitrepo --branch master --manual-integration

# Copy the result of the following command into a browser to see the web app in the production slot.
echo http://$webappname.azurewebsites.net

# Delete the Resources
# az group delete --name MyXam150ResourceGroup