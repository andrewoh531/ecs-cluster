#ECS Cluster
This repo contains YAML based Cloudformation templates for a base ECS infrastructure and then a separate template to build an ECS Service on top of it.

The base ECS infrastructure will build and share the following common AWS resources across the ECS Services:
* EC2 instances
* An Application Load Balancer (ALB)
    * The ALB can be configured with a separate target group for each containerized service that you deploy
* ECS Cluster

