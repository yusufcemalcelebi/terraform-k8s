#!/bin/bash

export NAME=greeting.k8s.local
export KOPS_STATE_STORE=s3://ycc-prod-k8s-state-store
export VPC_ID=vpc-0adc990243a0cd62f

kops create cluster \
    --node-count 1 \
    --node-size t2.micro \
    --zones eu-central-1a \
    --master-count 1 \
    --master-size t2.micro \
    --master-zones eu-central-1a \
    --vpc=${VPC_ID} \
    ${NAME} \
    --kubernetes-version=1.17.6