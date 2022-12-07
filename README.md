# Spark Distributed Computation Examples (SDCE) using PySpark and GCP Dataproc

Data: [EDGAR Log File Data Sets](https://www.sec.gov/about/data/edgar-log-file-data-sets.html) for 2022 and 2021 years.
Total unzipped size of files in the bucket: `62.04 GiB`

GCP Locations
- [Cloud locations](https://cloud.google.com/about/locations)
- [Regions and zones](https://cloud.google.com/compute/docs/regions-zones)

## Prerequisites

1. Install Python virtual environment to the root of the repository
   - Using JetBrains PyCharm (it's the simplest way if you don't have Python on the system level)
   - or using the manual [Creation of virtual environments](https://docs.python.org/3/library/venv.html)
2. You should authenticate `gcloud` on your local machine: `gcloud auth login`
3. Create a new GCP project or choose the one where you would like to create Dataproc assets and save its name

## GCP Project Creation

> **Warning**
> 
> **Creating or deleting GCP projects affects your quota. You may need to increase quota after some repetition of the
> operations below to be able to continue creation of new projects. Some more information [here](https://github.com/GoogleCloudPlatform/deploymentmanager-samples/issues/512)
> and [here](https://support.google.com/cloud/answer/6330231).**

If you'd like to create a new GCP project, here is the script. Your billing account for this script should have
name `My Billing Account`. It's a default one. 

```bash
TAG=$(date +"%Y%m%d-%H%M%S")
GCP_PROJECT="dataproc-test-${TAG}"

# create a project
gcloud projects create "${GCP_PROJECT}"
GCP_PROJECT_NUMBER=$(gcloud projects describe "${GCP_PROJECT}" | grep projectNumber | cut -d':' -f 2 | cut -d"'" -f 2)

# enable billing for the project using your account
# NB: this is not general approach and suite only for the case with 'My Billing Account' in the name
GCP_BILLING_ACCOUNT=$(gcloud alpha billing accounts list | grep "My Billing Account" | cut -d' ' -f 1)
gcloud alpha billing projects link "${GCP_PROJECT}" --billing-account "${GCP_BILLING_ACCOUNT}"
```

When you finish and would like to delete the project, you may use this script:

```bash
gcloud alpha billing projects unlink "${GCP_PROJECT}"

gcloud projects delete "${GCP_PROJECT}" --quiet
```

