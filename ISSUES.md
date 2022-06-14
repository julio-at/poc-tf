# Amazon Elastic Kubernetes Service

The average of time of creating an EKS cluster to
then start running EC2 instances (without running
any helm instructions), is about 9 minutes average,
only to bootstrap the cluster.

Destroying the entire infrastructure for this basic
application takes an average of 7 minutes.

Any other operations regarding the EKS takes around
a minute, considering we implement IAM and Route53 alongside VPCs, this is all reduced to a total of
20 minutes for just one test.

```
module.cluster.aws_eks_node_group.worker-node-group: 
Still destroying...  [id=dev-demo-deploy-3000:*, 7m30s elapsed]
```
