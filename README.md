# Please Note:  

This code is made available free, as part of the Salesforce Labs programme.
Salesforce Labs is a programme that lets salesforce.com engineers, professional services staff & other employees share AppExchange apps they've created with the customer community. Inspired by employees' work with customers of all sizes and industries, these apps range from simple utilities to entire vertical solutions. Salesforce Labs apps are free to use, but are not official salesforce.com products, and should be considered community projects - these apps are not officially tested or documented. For help on any Salesforce Labs app please consult the Salesforce message boards - salesforce.com support is not available for these applications. Questions? Please visit https://success.salesforce.com/answers.

# SalesforceLabs AI Governance App

As Generative AI policies and regulations change, customers need a way to document AI use cases. This app provides a way to document, approve, and audit AI use cases.

## Additional Info

As Generative AI policies and regulations change, customers need a way to document AI use cases. This app will provide a way to document, approve, and audit AI use cases.
Dashboard for reviewing approved AI use cases, risks, mitigation steps, and policies.

## Highlights

Audit and Compliance: tools for auditing AI use cases to ensure ongoing compliance with changing GenAI policies and regulations.

Comprehensive Documentation: Provide a platform for users to comprehensively document AI use cases, including details of the AI technology, intended use, and related policies.

Risk Management: Include features for identifying, documenting, and mitigating risks associated with AI use cases.

Dashboard for Monitoring: Create a dashboard for stakeholders to review approved AI use cases, associated risks, mitigation steps, and compliance with policies.

User-Friendly Interface: simplifies the process of documenting, approving, and auditing AI use cases.

Policy Integration and Updates: Integrate the latest GenAI policies and regulations into the app and ensure they are automatically updated.

Reporting and Analytics: Provide robust reporting and analytics capabilities to track the performance and compliance of AI use cases.

Collaboration and Communication: Facilitate collaboration and communication among stakeholders involved in the documentation, approval, and auditing processes.

## AppExchange Listing

- [AI Governance App](https://appexchange.salesforce.com/appxListingDetail?listingId=69ba309b-93de-4a2c-abcb-157f44bb100b)


## How to use this repository

You will need the latest version of the sfdx cli (https://developer.salesforce.com/tools/sfdxcli) and a hub org configured.  This repository is designed to be deployed to a Scratch Org.  It is possible to create the sfdx components into org metadata and deploy using the sfdx cli to a non-scratch org.  Please see the documentation for deploying metadata using sfdx (https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_top.htm).

Please make sure you are running the latest version

`sf update`

## Getting started

Download or clone this repository to your local machine


## One script to rule them - Create your scratch org and deploy

 - Open your terminal and navigate to the repositories base directory.
 - Make sure the scripts are executable `chmod +x scripts/*.sh`
    - If you want to build everything to a Scratch org, simply run `scripts/createAndDeploy.sh`
    - If you're want to deploy to Salesforce Org use `scripts/deploySourceToOrg.sh` 
 - Wait for the scratch org to build








