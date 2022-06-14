# The `envs` folder

This folder holds all environment configuration files. Your environment name is chosen by using the name you gave to your `.tfvars` file.

# Configuration properties

Create your environment file using the included example file. **All properties are
required.**

<center>
<br />

| Property                  | Type         | Description                          |
| ------------------------- |:------------:| ------------------------------------:|
| environment               | string       | Name of the file without `.tfvars`   |
| aws_region                | string       | Name of AWS region, e.g: us-east-1   |
| aws_access_key_id         | string       | Access Key ID                        |
| aws_secret_key            | string       | Secret key token                     |
| vpc_cidr                  | string       | CIDR Block for VPC network           |
| private_subnets           | list(string) | List of private subnets for VPC      |
| public_subnets            | list(string) | List of public subnets for VPC       |
| aws_route53_record_name   | string       | Route53 record name, e.g: www        |
| aws_route53_zone_name     | string       | Route53 zone name, e.g: company.com. |
| eks_worker_instance_types | list(string) | List of EC2 instance types to deploy |

<center />
