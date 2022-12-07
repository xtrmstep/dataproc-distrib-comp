import io
import random
import socket
import sys
from datetime import datetime
from time import time, sleep
from zipfile import ZipFile

import pyspark as ps
import pyspark.sql as pss
from google.cloud import storage


class Settings:
    BUCKET_INPUT = ""
    BUCKET_OUTPUT = ""


def get_bucket_info(gcs_bucket_name):
    """
    Slice the full name of the bucket folder into two parts
    :param gcs_bucket_name: Full path on the bucket, e.g., gs://bucket_name/path/to/folder
    :return: (bucket name, folder)
    """
    bucket_name = gcs_bucket_name.replace("gs://", "")
    parts = bucket_name.split("/")
    bucket_name = parts[0]
    folder = "/".join(parts[1:])
    if folder[-1] == "/":
        folder = folder[0:-1]
    return bucket_name, folder


def read_blob(bucket_name, blob_name):
    """
    Return blob object fetching it from GCS
    :param bucket_name: Bucket name
    :param blob_name: name of the blob
    :return: Blob object
    """
    client = storage.Client()
    bucket = client.get_bucket(bucket_name)
    blob = bucket.get_blob(blob_name)
    return blob


def save_to_bucket(bucket_name, folder, data, filename):
    """
    Store data on bucket from memory
    :param bucket_name: Bucket name where to store
    :param folder: folder where to store
    :param data: Text data in memory to store
    :param filename: File name
    """
    client = storage.Client()
    bucket = client.get_bucket(bucket_name)
    blob = bucket.blob(folder + "/" + filename)
    blob.upload_from_string(data)


def unzip_blob(filename: str, bucket_output):
    """
    Unzip a file located on GCS bucket and store it on another bucket
    :param filename: GCS file path, e.g., gs://...
    :param bucket_output: Name of a bucket to store the result
    """
    start = time()

    src_bucket_name, src_blob_name = get_bucket_info(filename)
    dst_bucket_name, dst_folder = get_bucket_info(bucket_output)
    blob = read_blob(src_bucket_name, src_blob_name)
    zipped_bytes = io.BytesIO(blob.download_as_string())
    with ZipFile(zipped_bytes, 'r') as zip_data:
        for zipped_filename in zip_data.namelist():
            unzipped_data = zip_data.read(zipped_filename)
            save_to_bucket(dst_bucket_name, dst_folder, unzipped_data, zipped_filename)

    elapsed = time() - start
    message = f"{filename} @ {socket.gethostname()}, started {datetime.now().strftime('%Y-%m-%d %H:%m:%S.%f')}, elapsed: {elapsed} seconds"
    return message


def empty_task(filename: str):
    """
    This task doesn't do anything. It just sleeps for a while and return a result
    :param filename: GCS file path, e.g., gs://...
    """
    started_at = datetime.now().strftime('%Y-%m-%d %H:%m:%S.%f')
    start = time()

    sleep(random.Random().randrange(1, 5))  # wait from 1 to 5 seconds

    elapsed = time() - start
    result = dict(
        filename=filename,
        host=socket.gethostname(),
        started_at=started_at,
        elapsed_sec=elapsed
    )
    return result


def output_result(is_dry_run, result, started_at):
    if is_dry_run:
        hosts = set([r["host"] for r in result])
        results_by_host = {host: len([r for r in result if r["host"] == host]) for host in hosts}
        print("Distribution of tasks across workers:")
        [print(f"- {host}: {results_by_host[host]} tasks") for host in results_by_host.keys()]
    else:
        print(f"Processing has finished in {time() - started_at} seconds")
        [print(msg) for msg in result]


def unzip_files_on_workers(gcs_files, is_dry_run, session, spark):
    """
    Submit a task to unzip files to Spark cluster
    :param gcs_files: The list of files to unzip
    :param session:
    :param spark:
    """
    spark_conf = spark.getConf()
    sys_cores = int(spark_conf.get("spark.executor.cores"))
    sys_executors = int(spark_conf.get("spark.executor.instances"))
    effective_partitions = sys_cores * sys_executors
    print("Spark settings:")
    print("- spark.executor.cores:", spark_conf.get("spark.executor.cores"))
    print("- spark.executor.instances:", spark_conf.get("spark.executor.instances"))
    print("Effective number of partitions (cores x instances):", effective_partitions)

    # create a distributed dataset (RDD) to submit to Spark cluster
    files_rdd = spark.parallelize(gcs_files, numSlices=effective_partitions)

    def get_unzip_func(output_bucket):
        def unzip_file(filename):
            return unzip_blob(filename, output_bucket)

        return empty_task if is_dry_run else unzip_file

    process_func = get_unzip_func(Settings.BUCKET_OUTPUT)

    start = time()
    # executing the method on the cluster in parallel manner
    result = files_rdd.map(process_func)\
        .collect()  # this collect triggers the actual work of the Spark
    output_result(is_dry_run, result, start)


def load_filenames(input_bucket, num_of_files):
    """
    Load the list of files from GCS `input_bucket`
    :param input_bucket: GCS bucket with files to process
    :param num_of_files: Number of files to process
    :return: List of files
    """
    bucket_name, bucket_folder = get_bucket_info(input_bucket)
    storage_client = storage.Client()
    bucket_descriptor = storage_client.get_bucket(bucket_name)
    blobs = list(bucket_descriptor.list_blobs(prefix=bucket_folder))
    blobs = [b for b in blobs if b.size > 0]  # keep only files
    # extract literal names of every file
    gcs_files = [f"gs://{bucket_name}/{b.name}" for b in blobs]
    if num_of_files is not None:
        gcs_files = gcs_files[:num_of_files]
    return gcs_files


def main(spark: ps.SparkContext, session: pss.SparkSession, is_dry_run, num_of_files):
    gcs_files = load_filenames(Settings.BUCKET_INPUT, num_of_files)

    total_files_number = len(gcs_files)
    top_files_number = min(total_files_number, 10)
    print(f"processing {total_files_number} files:")
    for filename in gcs_files[:top_files_number]:
        print(f"- {filename}")
    if total_files_number != top_files_number:
        print(f"(showing top {top_files_number} files)")

    unzip_files_on_workers(gcs_files, is_dry_run, session, spark)


if __name__ == "__main__":
    Settings.BUCKET_INPUT = sys.argv[1]
    Settings.BUCKET_OUTPUT = sys.argv[2]
    is_dry_run = sys.argv[3] == "dry"
    number_of_processing_files = int(sys.argv[4])

    print("arguments:")
    print("Settings.BUCKET_INPUT:", Settings.BUCKET_INPUT)
    print("Settings.BUCKET_OUTPUT:", Settings.BUCKET_OUTPUT)
    print("is_dry_run:", is_dry_run)
    print("number_of_processing_files:", number_of_processing_files)

    spark_context = ps.SparkContext(appName=__file__)
    spark_session = pss.SparkSession(spark_context)
    main(spark_context, spark_session, is_dry_run, number_of_processing_files)
