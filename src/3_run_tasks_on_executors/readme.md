# Run Tasks on Executors

Submit long-running job on the cluster. It will unzip files to the output bucket.~~~~ 

NB: Environment variables from `./run.sh` should be created in the shel before running this script. 

```bash
gcloud dataproc jobs submit pyspark "${MAIN_PYTHON_FILE}" \
--project="${GCP_PROJECT}" \
--region="${GCP_REGION}" \
--cluster-labels="sdce-type=testing" \
--bucket="${CLUSTER_BUCKET}" \
--properties-file="${SPARK_PROPERTIES_FILE}" \
-- "${DATA_BUCKET_SOURCE}" "${DATA_BUCKET_OUTPUT}" notdry 50
```

## Unzipping files on a Spark cluster

- Total time: 82.46 seconds
- Cluster time: 19.91 seconds
- Using `.Map().Collect()` to get the output

```txt
Spark settings:
- spark.executor.cores: 5
- spark.executor.instances: 2
Effective number of partitions (cores x instances): 10
Processing has finished in 19.90818762779236 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200519.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:32.103157, elapsed: 0.7588915824890137 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200520.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:33.965205, elapsed: 1.8607957363128662 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200521.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:34.674535, elapsed: 0.7051370143890381 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200522.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:36.104465, elapsed: 1.4294521808624268 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200523.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:36.757776, elapsed: 0.6500706672668457 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200524.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:32.225715, elapsed: 0.9165470600128174 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200525.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:33.316657, elapsed: 1.0891668796539307 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200527.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:34.166236, elapsed: 0.848259449005127 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200528.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:35.941179, elapsed: 1.7730679512023926 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200529.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:36.910814, elapsed: 0.9669618606567383 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200530.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:31.605220, elapsed: 0.45058608055114746 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200531.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:32.699992, elapsed: 1.0937814712524414 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200601.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:33.678054, elapsed: 0.9750964641571045 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200602.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:35.575806, elapsed: 1.8949193954467773 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200603.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:36.735380, elapsed: 1.154571771621704 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200604.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:32.695371, elapsed: 1.3511056900024414 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200605.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:34.432985, elapsed: 1.7347347736358643 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200606.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:35.278399, elapsed: 0.8424041271209717 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200607.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:35.769802, elapsed: 0.4896974563598633 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200608.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:36.604896, elapsed: 0.8347263336181641 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200609.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:32.377434, elapsed: 1.0594356060028076 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200610.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:33.473605, elapsed: 1.0923969745635986 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200611.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:36.440399, elapsed: 2.9641988277435303 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200612.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:38.070089, elapsed: 1.6246182918548584 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200613.zip @ sdce-cluster-1-w-1, started 2022-11-28 11:11:39.134581, elapsed: 1.0623078346252441 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200614.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:34.126401, elapsed: 1.9508461952209473 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200615.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:34.655334, elapsed: 0.5259089469909668 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200616.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:36.934048, elapsed: 2.2784602642059326 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200617.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:38.350203, elapsed: 1.410221815109253 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200618.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:40.827649, elapsed: 2.474499464035034 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200619.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:34.839373, elapsed: 2.5064311027526855 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200620.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:36.464315, elapsed: 1.6189370155334473 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200621.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:37.435459, elapsed: 0.9681320190429688 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200622.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:39.281341, elapsed: 1.8442401885986328 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200623.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:41.830876, elapsed: 2.542173385620117 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200624.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:34.425580, elapsed: 2.0493311882019043 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200625.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:35.533613, elapsed: 1.1029331684112549 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200626.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:36.691997, elapsed: 1.1554012298583984 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200627.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:37.826946, elapsed: 1.1328098773956299 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200628.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:38.808965, elapsed: 0.978980302810669 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200629.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:33.243356, elapsed: 0.9018919467926025 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200630.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:37.136345, elapsed: 3.890770435333252 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200701.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:40.547621, elapsed: 3.4024977684020996 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200702.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:46.435423, elapsed: 5.878671884536743 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200703.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:48.346517, elapsed: 1.9015724658966064 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200704.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:35.408538, elapsed: 3.0322928428649902 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200705.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:38.712866, elapsed: 3.29905104637146 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200706.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:40.806586, elapsed: 2.089500665664673 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200707.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:43.127204, elapsed: 2.316579580307007 seconds
gs://188128318973-sdce-3-output/raw/2020/log20200708.zip @ sdce-cluster-1-w-0, started 2022-11-28 11:11:44.718592, elapsed: 1.5872645378112793 seconds
```