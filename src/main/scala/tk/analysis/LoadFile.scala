/****************************************
* data from csv
****************************************/

package tk.analysis

import org.apache.spark.sql.SparkSession


class LoadFile(spark: SparkSession, filepath: String) {

  type DF = org.apache.spark.sql.DataFrame // type alias

  // loaded data from csv
  val data: DF = spark.read
    .format("csv")
    .option("header", "true")
    .option("inferSchema", "true")
    .load(filepath)

}