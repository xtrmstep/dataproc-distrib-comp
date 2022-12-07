#!/usr/bin/env bash

gcloud scheduler jobs delete "${WORKFLOW_NAME}" \
--project="${GCP_PROJECT}" \
--location="${GCP_REGION}" \
--quiet

gcloud dataproc workflow-templates delete "${WORKFLOW_NAME}" \
--project="${GCP_PROJECT}" \
--region="${GCP_REGION}" \
--quiet

gcloud dataproc clusters delete "${CLUSTER_NAME}" \
--project="${GCP_PROJECT}" \
--region="${GCP_REGION}" \
--quiet

gcloud dataproc autoscaling-policies delete "${CLUSTER_AUTOSCALE_NAME}" \
--project "${GCP_PROJECT}" \
--region "${GCP_REGION}" \
--quiet

gsutil -m rm -rf "gs://${CLUSTER_BUCKET}/*"
gsutil rb -f "gs://${CLUSTER_BUCKET}"
gsutil -m rm -rf "gs://${OUTPUT_BUCKET}/*"
gsutil rb -f "gs://${OUTPUT_BUCKET}"

gcloud iam service-accounts delete "${CLUSTER_SERVICE_ACCOUNT}" \
--project "${GCP_PROJECT}" \
--quiet
