/****************************************
* ANALYZER
* v 1.0 beta
***************************************
* read data from parquet file
* process and aggregate data
* export data to Dropbox
****************************************/

package tk.analysis

import org.apache.spark.SparkConf
import org.apache.spark.sql._



object Analyzer {

  def main(args: Array[String]): Unit = {


    /*****************************************
    * parameters and configuration
    *****************************************/

    val appName = "Analyzer"      // application name
    val master = args(0)          // master to run application
    val minEfficiency = args(1)   // sensor minimal efficiency (min ratio of valid observation to classify sensor as valid)
    val dataDir = args(2)         // directory to get/store data


    // initialize context
    val conf = new SparkConf().setMaster(master).setAppName(appName)
    val spark = SparkSession.builder.config(conf).getOrCreate()


    /*****************************************
    * loading data
    *****************************************/

    import org.apache.spark.sql.functions._
    import org.apache.spark.sql.types._
    import spark.implicits._

    // load sensors data from parquet file
	  // extend data with a flag columns
    val sensorsData = spark.read
      .parquet(dataDir + "stream/output/")
      .withColumn("Timestamp", unix_timestamp($"Timestamp", "dd/MM/yyyy HH:mm:ss").cast(TimestampType)) // convert string to timestamp


    // load air standards data and sensors meta
    val standards = new LoadFile(spark, dataDir + "static/input/airStandards.csv") // air standards
    val sensorsMeta = new LoadSensorsMeta(spark, dataDir + "static/input/sensorsMeta.csv") // sensors metadata


    /*****************************************
    * calculating time windows
    *****************************************/

    // get max timestamp/max date and return result as data frame
    val maxTime = sensorsData
      .agg(max($"Timestamp") as "maxTmstmp") // get max timestamp
      .withColumn("maxDate", to_date($"maxTmstmp")) // add timestamp converted to date


    // calculate time window for each air standard
    val timeWindows = standards.data
      .crossJoin(maxTime) // add max timestamp
      .withColumn("minTmstmp", from_unixtime(unix_timestamp($"maxTmstmp") - ($"WindowHours" * 3600 - 3600))) // calculate time window; add 1 hour to avoid over calculation
      .drop("Verified", "maxDate") // remove unnecessary columns


    /*****************************************
    * joining and aggregating data
    *****************************************/

    // get active sensors only
    // technical data frame to join sensors data with air standards
	  val sensorsActive = sensorsMeta.getActive(maxTime) // two columns: SensorID and SensorType


    // prepare data (join) before aggregating
    val sensorsDataAggPre = sensorsData
      .join(sensorsActive, "SensorId") // join sensors data with sensors metadata (N:1 relation)
      .join(timeWindows,
        (sensorsActive("SensorType") === timeWindows("SensorType")) &&
        (sensorsData("Timestamp") >= timeWindows("minTmstmp")) &&
        (sensorsData("Timestamp") <= timeWindows("maxTmstmp"))
      ) // time window/air standaards (1:M relation), exclude out of range data
      .drop("SensorType", "Timestamp", "minTmstmp", "maxTmstmp", "Limit") // remove unused columns


    // aggregate data
    val sensorsDataAgg = sensorsDataAggPre
      .groupBy($"SensorId", $"WindowHours") // group by
      .agg(
        sum(when($"State" === "VA",1)) as "VA",
        sum(when($"State" === "NA", 1)) as "NA",
        avg(when($"State" === "VA", $"Value")) as "avgValue"
      ) // aggregations, sum/count data conditionally
      .withColumn("avgValue", round($"avgValue",1)) // round value to the human-readable form


    /*****************************************
    * calculating metrics
    *****************************************/

    // prepare data to calculate metrics
    val metricsPre = sensorsActive
      .join(standards.data, "SensorType") // get window hours
      .join(sensorsDataAgg, Seq("SensorId", "WindowHours"), "left_outer") // left join - don't miss active sensors with no data; 1:N relation
      .withColumn("VA", when($"VA".isNotNull, $"VA").otherwise(0))
      .withColumn("NA", when($"NA".isNotNull, $"NA").otherwise(0))
      .withColumn("ND", $"WindowHours" - $"VA" - $"NA")
      .drop("Verified")


    // calculate metric
    val metrics = metricsPre
      .withColumn("ND", $"WindowHours" - $"VA" - $"NA") // count hours with no data
      .withColumn("Efficiency",
        when($"WindowHours" > 0, round(($"VA" + $"NA") / $"WindowHours",3)
        ).otherwise(0.0)
      ) // calculate efficiency (% of valid observations
      .withColumn("Ratio", when($"Limit" > 0, round($"avgValue" / $"Limit",1)))
      .withColumn("State",
        when(col("Efficiency") >= lit(minEfficiency),
          when($"Ratio" >= lit(1), "air pollution"
          ).otherwise("ok")
        ).otherwise("broken")
      )
      .select("SensorId", "State", "VA", "NA", "ND", "avgValue", "Limit", "Ratio")


    /*****************************************
    * saving results
    *****************************************/

    // prepare final data frame to export
    val metricsOut = metrics
      .join(sensorsMeta.data, Seq("SensorId")) // get coordinates
      .withColumn("Label", concat(
        $"SensorId", lit(" "), $"StationName", lit("   ["),
        $"State", lit(": "), $"avgValue", lit("/"), $"Limit", lit(" "), $"SensorType",
        lit(" "), $"VA", lit("/"), $"NA", lit("/"), $"ND", lit("]")
       ))
      .select("SensorId", "State", "Ratio", "Label", "CordsLat", "CordsLng")


    // export sensors data
    metricsOut
      .repartition(1)
      .write
      .mode(SaveMode.Overwrite) // override file if exists
      .format("csv")
      .option("header","true")
      .save(dataDir + "static/output/sensorsOut.csv")

    // export timestamp
    maxTime
      .repartition(1)
      .write
      .mode(SaveMode.Overwrite) // override file if exists
      .format("csv")
      .option("header","true")
      .save(dataDir + "static/output/timestamp.csv")


    // stop Spark session
    spark.stop()

  }
}
