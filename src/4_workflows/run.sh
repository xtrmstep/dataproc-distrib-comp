#!/usr/bin/env bash

WORKFLOW_NAME="${TAG}_test_workflow"
WORKFLOW_CODE_PATH="gs://${CLUSTER_BUCKET}/workflows/${WORKFLOW_NAME}/"

# prepare workflow YAML
cp -f "./test_workflow_template.yaml" "${WORKFLOW_NAME}.yaml"
sed -i 's@ARG1@'"'${DATA_BUCKET_SOURCE}'"'@' "${WORKFLOW_NAME}.yaml"
sed -i 's@ARG2@'"'${DATA_BUCKET_OUTPUT}'"'@' "${WORKFLOW_NAME}.yaml"
sed -i "s/ARG3/'dry'/" "${WORKFLOW_NAME}.yaml"
sed -i "s/ARG4/'100'/" "${WORKFLOW_NAME}.yaml"
sed -i 's@MAIN_PY@'"${WORKFLOW_CODE_PATH}"'job_run_on_workers.py@' "${WORKFLOW_NAME}.yaml"

# copy workflow code
gsutil cp "./../3_run_tasks_on_executors/job_run_on_workers.py" "${WORKFLOW_CODE_PATH}"

# import workflow to a Dataproc
gcloud dataproc workflow-templates import "${WORKFLOW_NAME}" \
--project="${GCP_PROJECT}" \
--region="${GCP_REGION}" \
--source="./${WORKFLOW_NAME}.yaml"

# add necessary role to run a workflow
gcloud projects add-iam-policy-binding "${GCP_PROJECT}" \
    --member serviceAccount:"${CLUSTER_SERVICE_ACCOUNT}" \
    --role roles/dataproc.editor

# create a scheduler for the workflow
gcloud scheduler jobs create http "${WORKFLOW_NAME}" \
--project="${GCP_PROJECT}" \
--location="${GCP_REGION}" \
--schedule="0 0 1 * *" \
--uri="https://dataproc.googleapis.com/v1/projects/${GCP_PROJECT}/regions/${GCP_REGION}/workflowTemplates/${WORKFLOW_NAME}:instantiate?alt=json" \
--http-method=POST \
--max-retry-attempts=1 \
--time-zone=Europe/Sofia \
--oauth-service-account-email="${CLUSTER_SERVICE_ACCOUNT}" \
--oauth-token-scope=https://www.googleapis.com/auth/cloud-platform
