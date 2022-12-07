#!/usr/bin/env bash

MAIN_PYTHON_FILE="./job_run_on_workers.py"
OUTPUT_BUCKET="sdce-3-output-${TAG}"
DATA_BUCKET_SOURCE="gs://${OUTPUT_BUCKET}/raw/2020/"
DATA_BUCKET_OUTPUT="gs://${OUTPUT_BUCKET}/out/2020/"
SPARK_PROPERTIES_FILE="./spark.properties"


# create a bucket to persist some Dataproc cluster data and files
gsutil mb -b on -p "${GCP_PROJECT}" -l "${GCP_REGION}" --pap enforced "gs://${OUTPUT_BUCKET}"

# copy source data
gsutil -m cp -r "gs://sdce-data-edgar-logs/raw/*" "gs://${OUTPUT_BUCKET}/raw/"

gcloud dataproc jobs submit pyspark "${MAIN_PYTHON_FILE}" \
--project="${GCP_PROJECT}" \
--region="${GCP_REGION}" \
--cluster-labels="sdce-type=testing" \
--bucket="${CLUSTER_BUCKET}" \
--properties-file="${SPARK_PROPERTIES_FILE}" \
-- "${DATA_BUCKET_SOURCE}" "${DATA_BUCKET_OUTPUT}" dry 100
