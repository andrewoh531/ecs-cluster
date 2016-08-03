#ECS Cluster
This repo creates the necessary AWS foundation resources to use ECS (Ec2 Container Service).

Applications will need to depend on the resources created from this repo in order to deploy ECS Services and Tasks in AWS.

A `dev.andrewoh.ninja` subdomain is created as part of this Terraform configuration. This is routed from the `andrewoh.ninja`
hosted zone from the `andrewoh531` account that contains a NS record of the `dev.andrewoh.ninja` NS servers. The `dev.andrewoh.ninja`
NS servers were manually copied into the NS record.

This repo relies on Terraform.
