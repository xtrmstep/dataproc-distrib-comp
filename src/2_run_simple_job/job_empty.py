import pyspark as ps
import pyspark.sql as pss


def main(spark: ps.SparkContext, session: pss.SparkSession):
    conf = spark.getConf()
    config_items = conf.getAll()
    print("spark.executor.cores:", conf.get("spark.executor.cores"))
    print("spark.executor.instances:", conf.get("spark.executor.instances"))
    print("=== ALL ===")
    [print(item) for item in config_items]
    print("===========")


if __name__ == "__main__":
    spark_context = ps.SparkContext.getOrCreate()
    spark_session = pss.SparkSession(spark_context)
    main(spark_context, spark_session)
