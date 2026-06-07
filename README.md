# try-aws-devops-agent

Sandbox for experimenting with AWS DevOps Agent.

Adapted from https://github.com/aws-samples/sample-aws-devops-agent-terraform


# Deploying to AWS

### 1. Install Terraform

Install [Terraform](https://developer.hashicorp.com/terraform/install) **1.0 or later** (see `versions.tf`), then verify:

```bash
terraform version
```

### 2. Initialize the project

```bash
terraform init
```

### 3. Configure variables

Copy the example file and set your AWS region, space name, and tags:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` in your editor. This file is gitignored, so your local values won't be committed.

### 4. Run creation of resource on AWS

Inspect the output from plan
```bash
terraform plan -var-file="terraform.tfvars" -out=tfplan
```

Then apply it once all is good
```bash
terraform apply tfplan
```

(Optional) Inspect the outputs
```
terraform output
```



