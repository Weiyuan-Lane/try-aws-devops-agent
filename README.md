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
git submodule update --init --recursive
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

# Sample skills

Apply uploads every skill from the [sample-skills-for-AWS-Devops-agent](https://github.com/aws-samples/sample-skills-for-AWS-Devops-agent) as a submodule. Remove if you don't need them!

# Testing DevOps Agent (with fake incident)

After apply, grab the public Lambda Function URL:

```bash
terraform output test_agent_lambda_function_url
```

That Lambda is the only public entrypoint. Fargate sits behind an internal ALB (`test_agent_fargate_internal_endpoint`) and is only reachable when Lambda is called with `?proxy=true`.

### Healthy request

No query params. Lambda sleeps 0.5s and returns `200` with `true`.

```bash
curl -i "$(terraform output -raw test_agent_lambda_function_url)"
```

### Fake Lambda incident (`?fail=true`)

Lambda sleeps 1s, then returns `500` with `{"ok": false, "error": "fail requested"}`. Nothing is sent to Fargate.

```bash
curl -i "$(terraform output -raw test_agent_lambda_function_url)?fail=true"
```

### Fake Fargate incident (`?proxy=true`)

Lambda GETs the internal ALB at `/` (not `/healthcheck`). The Fargate app always succeeds on `/healthcheck` so the ALB stays healthy. On every other path, it exits the process with probability `FAIL_RATE` (default `0.2`). That kills the task, so Lambda often sees a `502` from the ALB.

```bash
curl -i "$(terraform output -raw test_agent_lambda_function_url)?proxy=true"
```

Repeat the proxy call a few times until a request fails. Use those Lambda/Fargate errors as the fake incident for DevOps Agent to investigate.


