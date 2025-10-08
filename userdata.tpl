#!/bin/bash
set -e
# install docker
yum update -y
yum install -y docker
service docker start
usermod -a -G docker ec2-user

# install awslogs (CloudWatch logs) (or rely on docker awslogs driver)
yum install -y awslogs

# create CW logs group if needed (instances can create)
aws logs create-log-group --log-group-name ${log_group} || true

# run container (replace with your app env vars, and RDS endpoint via template rendering)
docker run -d --name cloudcart_app \
  -p 80:80 \
  --restart always \
  --log-driver=awslogs \
  --log-opt awslogs-region=${aws_region} \
  --log-opt awslogs-group=${log_group} \
  --log-opt awslogs-stream=instance-$(curl -s http://169.254.169.254/latest/meta-data/instance-id) \
  ${docker_image}
