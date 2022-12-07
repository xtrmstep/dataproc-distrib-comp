#!/usr/bin/env bash

MAIN_PYTHON_FILE_UNZIP="../3_run_tasks_on_executors/job_run_on_workers.py"
MAIN_PYTHON_FILE="./job_sparksql.py"
DATA_BUCKET_SOURCE_SQL="gs://${OUTPUT_BUCKET}/out/2020/*"
SPARK_PROPERTIES_FILE="./spark.properties"

# prepare data
gcloud dataproc jobs submit pyspark "${MAIN_PYTHON_FILE_UNZIP}" \
--project="${GCP_PROJECT}" \
--region="${GCP_REGION}" \
--cluster-labels="sdce-type=testing" \
--bucket="${CLUSTER_BUCKET}" \
--properties-file="${SPARK_PROPERTIES_FILE}" \
-- "${DATA_BUCKET_SOURCE}" "${DATA_BUCKET_OUTPUT}" notdry 50

# run sql
gcloud dataproc jobs submit pyspark "${MAIN_PYTHON_FILE}" \
--project="${GCP_PROJECT}" \
--region="${GCP_REGION}" \
--cluster-labels="sdce-type=testing" \
--bucket="${CLUSTER_BUCKET}" \
--properties-file="${SPARK_PROPERTIES_FILE}" \
-- "${DATA_BUCKET_SOURCE_SQL}" 10 sql

# run not sql
gcloud dataproc jobs submit pyspark "${MAIN_PYTHON_FILE}" \
--project="${GCP_PROJECT}" \
--region="${GCP_REGION}" \
--cluster-labels="sdce-type=testing" \
--bucket="${CLUSTER_BUCKET}" \
--properties-file="${SPARK_PROPERTIES_FILE}" \
-- "${DATA_BUCKET_SOURCE_SQL}" 10 notsql
