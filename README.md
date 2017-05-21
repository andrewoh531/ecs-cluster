#ECS Cluster
This repo contains YAML based Cloudformation templates for a base ECS infrastructure and then a separate template to build ECS Services on top of it.

The base ECS infrastructure (`ecs-base.yml`) builds the following AWS resources that's shared across the ECS Services:
* An ECS Cluster
* EC2 instances registered to the aforementioned cluster
* An Application Load Balancer (ALB)
    * The ALB can be configured with a separate target group for each containerized service that you deploy


# Deploy scripts
There are two bash scripts used for deployment:
* `validate-and-deploy.sh` - This is used to validate the cloudformation templates and deploy them to a publically readable `andrewoh531-cloudformation-templates` S3 bucket.
* `examples/update-stack.sh` - This is an example script for creating the base resources. It creates the underlying resources on which the `ecs-service.yml` resources will be build on top of. This should be run before your applications execute creation of `ecs-service.yml`.