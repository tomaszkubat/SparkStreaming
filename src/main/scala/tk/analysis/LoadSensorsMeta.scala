/****************************************
* sensors metadata
****************************************/

package tk.analysis

import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.types.{TimestampType}
import org.apache.spark.sql.functions.{unix_timestamp, to_date, lit}



class LoadSensorsMeta(spark: SparkSession, filepath: String) extends LoadFile(spark, filepath) {

  // import scala.io.Source.fromURL
  // import spark.implicits._
  // import org.apache.spark.sql._


  // TODO get from url (nice to have)
  /*
  val url = "https://www.dati.lombardia.it/resource/t4f9-i4k5.json"

  def get(ss: SparkSession, url: String): DataFrame = {

    /**
    * Get text (content) from a URL
    * Returns the spark DataFrame
    *
    * Warning: This method does not time out when the service is non-responsive.
    */

    val dataString = fromURL(url).mkString
    val dataDataFrame = ss.read.json(Seq(dataString).toDF)

    return dataDataFrame
  }
  */

  override
  val data: DF = spark.read
    .format("csv")
    .option("header", "true")
    .option("inferSchema", "true")
    .load(filepath)
    .na.fill("01/01/1968", Seq("SensorDateStart"))
    .na.fill("31/12/2049", Seq("SensorDateStop"))

  // sensors activity - data subset, strings converted to dates
  import spark.implicits._
  val activity: DF = data
    .select("SensorId", "SensorType", "SensorDateStart", "SensorDateStop")
    .withColumn("SensorDateStart", to_date(unix_timestamp($"SensorDateStart", "dd/MM/yyyy").cast(TimestampType)))
    .withColumn("SensorDateStop", to_date(unix_timestamp($"SensorDateStop", "dd/MM/yyyy").cast(TimestampType)))


  // get active sensors method
  def getActive(checkDate: org.apache.spark.sql.DataFrame): DF = {

    // TODO remove after tests
    // import scala.util.matching.Regex
    // import java.lang.Throwable
    // date pattern, read more on: https://www.scala-lang.org/api/2.12.3/scala/util/matching/Regex.html
    /* val datePattern: scala.util.matching.Regex = raw"(\d{4})-(\d{2})-(\d{2})".r

    checkDate match {
      case datePattern(_*) => data
        .filter(data.col("SensorDateStart") <= checkDate && data.col("SensorDateStop") >= checkDate)
        .select("SensorId","SensorType")
      case _ => throw new Exception("data mask mismatch, expected: " + datePattern)
    }
    */

    // get sensors, which are currently active
    activity
      .crossJoin(checkDate) // join a dataframe with date to check (max date from sensors stream)
      .filter($"SensorDateStart" <= $"maxDate" && $"SensorDateStop" >= $"maxDate") // get active sensors
      //.withColumn("isActive", lit(1))
      .select("SensorId", "SensorType")

  }

}