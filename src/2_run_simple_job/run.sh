#!/usr/bin/env bash

MAIN_PYTHON_FILE="./job_empty.py"
SPARK_PROPERTIES_FILE="./spark.properties"

gcloud dataproc jobs submit pyspark "${MAIN_PYTHON_FILE}" \
--project="${GCP_PROJECT}" \
--region="${GCP_REGION}" \
--cluster-labels="sdce-type=testing" \
--bucket="${CLUSTER_BUCKET}" \
--properties-file="${SPARK_PROPERTIES_FILE}" \
--async
