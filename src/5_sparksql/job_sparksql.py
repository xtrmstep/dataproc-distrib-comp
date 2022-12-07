import sys

import pyspark as ps
import pyspark.sql as pss
import pyspark.sql.functions as F


class Settings:
    BUCKET_INPUT = ""


def execute_py(number_of_records, session):
    raw_df = session.read.csv(Settings.BUCKET_INPUT, header=True)\
        .filter(F.col("uri_path").endswith('.sgml')) \
        .withColumn("parth_parts", F.split('uri_path', '/')) \
        .withColumn("path_idx_1", F.col('parth_parts').getItem(4)) \
        .withColumn("path_idx_2", F.col('parth_parts').getItem(5)) \
        .withColumn("rn", F.row_number().over(pss.Window.partitionBy('path_idx_1').orderBy('path_idx_2'))) \
        .filter("rn == 1") \
        .select("_time", "uri_path") \
        .limit(number_of_records)
    return raw_df


def execute_sql(number_of_records, session):
    session.read.csv(Settings.BUCKET_INPUT, header=True).createOrReplaceTempView("raw_df")
    session.sql(f"""
        CREATE OR REPLACE TEMPORARY VIEW transformed_df
        AS
        WITH
            raw_data AS (
                SELECT
                    *,
                    SPLIT(uri_path, '/')[4] AS path_idx_1,
                    SPLIT(uri_path, '/')[5] AS path_idx_2
                FROM raw_df
                WHERE uri_path LIKE '%.sgml'
            )
            ,ordered AS (
                SELECT
                    *,
                    ROW_NUMBER() OVER(PARTITION BY path_idx_1 ORDER BY path_idx_2 DESC) AS rn
                FROM raw_data
            )
        SELECT _time, uri_path FROM ordered WHERE rn = 1 LIMIT {number_of_records}
    """)
    df = session.table("transformed_df")
    return df


def main(spark: ps.SparkContext, session: pss.SparkSession, number_of_records, run_mode):
    if run_mode == 'sql':
        df = execute_sql(number_of_records, session)
    else:
        df = execute_py(number_of_records, session)

    rows = df.collect()
    [print(r) for r in rows]


if __name__ == "__main__":
    Settings.BUCKET_INPUT = sys.argv[1]
    number_of_records = int(sys.argv[2])
    run_mode = sys.argv[3]

    print("arguments:")
    print("Settings.BUCKET_INPUT:", Settings.BUCKET_INPUT)
    print("number_of_records:", number_of_records)

    spark_context = ps.SparkContext(appName=__file__)
    spark_session = pss.SparkSession(spark_context)
    main(spark_context, spark_session, number_of_records, run_mode)
