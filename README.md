# Terraform - Proof of Concept

The purpose of this PoC is to create an AWS infrastructure capable of running
the following set of requirements:

1. EKS Cluster with managed EC2 nodes
2. VPC with at least 2 subnets
3. Route53 for DNS
4. Deploy NGINX in nodes
5. Deploy [this application](https://github.com/gt-sk-1654/client-a-app) in nodes

This solution also ensures the following instructions:

1. Ensure only a configurable list of IPs can access the solution
2. Ensure security at every layer and follow best practices
3. Ensure scalability and high availability

# Running the solution

**To run this solution `Terraform >= v1.1.9` and GNU/make are both required**

<br />

## 1. Load up your environment


To do this, simply rename the file `tfvars.example` to your desired
environment, e.g:

```
$ mv envs/tfvars.example envs/dev.tfvars
```

Add to the file your Amazon credentials to the following lines:

```
aws_access_key_id = ""
aws_secret_key = ""
```

## 2. Initiate cluster and provisioning

Set your environment to the current configuration file
you want to load, e.g:

(File: envs/dev.tfvars)

```
$ ENV=dev
```

Inside the project root, run the following command to
start creating our cluster infrastructure:

```
$ make apply_cluster
```

After this is done, deploy the necessary software
and website running the following command:

```
$ make apply_deploy
```
