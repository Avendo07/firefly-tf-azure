**This is the terraform code to deploy [firefly-iii](https://github.com/firefly-iii/firefly-iii) on azure app service along with mysql db installation.**
- The secrets in secrets folder have dummy values, please change them as required
- The secrets folder should not be commited to source control in production, it is just present for reference
- These secrets are synced with the keyvault in azure and are then referenced to generate db and app service configurations
- Architecture
  - The app service and db are in the same vnet, db is behind a private DNS. This DNS has an a record to the private endpoint of the database
  - Resource group contains all the resources created by the terraform code
  - App service plan is running a docker container with latest firefly-iii image.

Running a `terraform apply` from the tf-src directory should provision the resources in azure after doing `az login` on a terminal.