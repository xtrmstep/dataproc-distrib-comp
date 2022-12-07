#!/usr/bin/env bash

TAG=$(date +"%Y%m%d-%H%M%S")
GCP_PROJECT="??? Enter the GCP project ID here ???"

# enable required services
gcloud services enable dataproc.googleapis.com --project="${GCP_PROJECT}"
gcloud services enable cloudscheduler.googleapis.com --project="${GCP_PROJECT}"

GCP_REGION="europe-central2"
CLUSTER_NAME="sdce-cluster-${TAG}"
CLUSTER_AUTOSCALE_NAME="sdce-autoscale-policy-${TAG}"
CLUSTER_BUCKET="sdce-dataproc-cluster-${TAG}"
CLUSTER_LABELS="sdce-type=testing"
CLUSTER_AUTOSCALE_YAML="./dataproc-autoscaling-policy.yaml"
CLUSTER_MACHINE_TYPE_MASTER="custom-4-51200-ext"
CLUSTER_MACHINE_TYPE_WORKER="custom-6-39936"
CLUSTER_SERVICE_ACCOUNT_NAME="dataproc-${TAG}"
CLUSTER_SERVICE_ACCOUNT="${CLUSTER_SERVICE_ACCOUNT_NAME}@${GCP_PROJECT}.iam.gserviceaccount.com"

# create a cluster service account
gcloud iam service-accounts create "${CLUSTER_SERVICE_ACCOUNT_NAME}" \
    --project "${GCP_PROJECT}" \
    --display-name "Dataproc account"

# assign Dataproc Worker role
gcloud projects add-iam-policy-binding "${GCP_PROJECT}" \
    --member serviceAccount:"${CLUSTER_SERVICE_ACCOUNT}" \
    --role roles/dataproc.worker

# create a bucket to persist some Dataproc cluster data and files
gsutil mb -b on -p "${GCP_PROJECT}" -l "${GCP_REGION}" --pap enforced "gs://${CLUSTER_BUCKET}"

# add Dataproc autoscaling policy
gcloud dataproc autoscaling-policies import "${CLUSTER_AUTOSCALE_NAME}" \
--project "${GCP_PROJECT}" \
--region "${GCP_REGION}" \
--source "${CLUSTER_AUTOSCALE_YAML}" \
--quiet

# this cluster will be automatically removed when idle for 1hr
gcloud dataproc clusters create "${CLUSTER_NAME}" \
--project="${GCP_PROJECT}" \
--bucket="${CLUSTER_BUCKET}" \
--region="${GCP_REGION}" \
--autoscaling-policy="${CLUSTER_AUTOSCALE_NAME}" \
--master-machine-type="${CLUSTER_MACHINE_TYPE_MASTER}" \
--master-boot-disk-size=500 \
--num-workers=2 \
--num-secondary-workers=0 \
--worker-machine-type="${CLUSTER_MACHINE_TYPE_WORKER}" \
--worker-boot-disk-size=500 \
--image-version="2.0-debian10" \
--enable-component-gateway \
--optional-components="JUPYTER" \
--scopes="https://www.googleapis.com/auth/cloud-platform" \
--labels="${CLUSTER_LABELS}" \
--properties="dataproc:dataproc.logging.stackdriver.job.driver.enable=true,dataproc:dataproc.logging.stackdriver.job.yarn.container.enable=true,spark:spark.executor.cores=5,spark:spark.executor.instances=2" \
--initialization-actions="gs://goog-dataproc-initialization-actions-${GCP_REGION}/connectors/connectors.sh,gs://goog-dataproc-initialization-actions-${GCP_REGION}/python/pip-install.sh" \
--metadata="bigquery-connector-version=1.2.0,spark-bigquery-connector-version=0.21.0" \
--metadata="PIP_PACKAGES=psycopg2" \
--service-account="${CLUSTER_SERVICE_ACCOUNT}" \
--max-idle=3600s \
--quiet
