#!/bin/bash

export NAME=greeting.k8s.local
export KOPS_STATE_STORE=s3://ycc-prod-k8s-state-store
export VPC_ID=vpc-0adc990243a0cd62f

kops create cluster \
    --node-count 1 \
    --node-size t2.micro \
    --zones eu-central-1a \
    --master-count 1 \ # For maximum availability use 3 master nodes
    --master-size t2.micro \
    --master-zones eu-central-1a \
    --vpc=${VPC_ID} \
    ${NAME} \
    --kubernetes-version=1.17.6


kops edit cluster --name $NAME

# add created public subnet
#
#   subnets:
#   - cidr: ${SUBNET_CIDR}
#     id: ${SUBNET_ID}
#     name: eu-central-1
#     type: Public
#     zone: eu-central-1a

# Next edit cluster and add sshKeyName: ${existedKeyName} under .spec section, where ${existedKeyName} is an already existing EC2 SSH Key Pair.

kops update cluster ${NAME} --yes

kops validate cluster --wait 10m
