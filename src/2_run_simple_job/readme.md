# Run a Simple Job

## Documentation:

- [Submit a job](https://cloud.google.com/dataproc/docs/guides/submit-job)
- [Job Scheduling](https://spark.apache.org/docs/latest/job-scheduling.html)
- [Life of a Dataproc job](https://cloud.google.com/dataproc/docs/concepts/jobs/life-of-a-job)

## Operations:

- [gcloud dataproc jobs submit pyspark](https://cloud.google.com/sdk/gcloud/reference/dataproc/jobs/submit/pyspark)

### Submitting by label or by name

You may specify a cluster to submit a job there. The cluster for execution will be chosen by its name.

```bash
--cluster="CLUSTER_NAME"
```

You may also use labels to submit a job on some cluster. In such a case the job will be submitted to ne of cluster from 
all, which have such label. When submitting a job to a cluster selected via `--cluster-labels`, either a staging bucket
must be provided via the `--bucket` argument, or all provided files must be non-local.

```bash
--cluster-labels="KEY=VALUE"
--bucket="BUCKET_NAME"
```

