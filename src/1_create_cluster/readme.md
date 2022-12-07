# Create Dataproc cluster

## Documentation:

- [Initialization actions](https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/init-actions)
- [Autoscaling clusters](https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/autoscaling)
- [Cluster properties](https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/cluster-properties)

## Operations:

- [gcloud dataproc clusters create](https://cloud.google.com/sdk/gcloud/reference/dataproc/clusters/create)
- [gcloud dataproc autoscaling-policies import](https://cloud.google.com/sdk/gcloud/reference/dataproc/autoscaling-policies/import)

> :warning: **Don't create production clusters that reference initialization actions located in the gs://goog-dataproc-initialization-actions-REGION public buckets. These scripts are provid
ed as reference implementations, and they are synchronized with ongoing GitHub repository changes. A new version of a initialization action in public buckets may break your cluster crea
tion.

## Issues

### 1. Insufficient quota

Depends on the machine type you may face the following (or similar) issue during cluster creation:

```
- Insufficient 'CPUS' quota. Requested 48.0, available 24.0.
- Insufficient 'CPUS_ALL_REGIONS' quota. Requested 48.0, available 32.0.
```

Run this command to check your current quotas and adjust machine size accordingly:

```bash
gcloud compute regions describe ${GCP_REGION} --project=${GCP_PROJECT}
```
