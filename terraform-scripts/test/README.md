# Running a test

Run Terraform Commands:

## Test run

Open a terminal, navigate to the directory where you saved test.tf, and execute the following Terraform commands:

```
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

The init command initializes your working directory, the plan command shows what actions will be taken, and the apply command executes those actions.

This separation of variables into a dedicated file (`variables.tf`) and using a `terraform.tfvars` file for actual values makes it easier to manage and reuse your Terraform configurations.

## Review Outputs:

After running the apply command, Terraform will display the outputs defined in the script. These outputs will tell you whether the recovery plan exists and if the VM meets the prerequisites.

## Destroy Resources (Optional):

If you want to clean up the resources created by the Terraform script, you can execute the following command:

```
terraform destroy

```

This will remove the resources created during the apply step.
