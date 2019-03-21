/****************************************
* STREAMER
* 1.0 beta
*****************************************
* read data from csv (local)
* and save as parquet (local)
****************************************/

package tk.stream

import org.apache.spark.SparkConf
import org.apache.spark.sql._


object Streamer {

  case class SensorsSchema(SensorId: Int, Timestamp: String, Value: Double, State: String, OperatorId: Int)

  def main(args: Array[String]): Unit = {

    // Configuration parameters (to create spark session and contexts)
    val appName = "StreamingApp" // app name
    val master = "local[*]" // master configuration
    val dataDir = "/home/usr_spark/Projects/SparkStreaming/data/"
    val refreshInterval = 30 // seconds


    // initialize context
    val conf = new SparkConf().setMaster(master).setAppName(appName)
    val spark = SparkSession.builder.config(conf).getOrCreate()


    import spark.implicits._

    // TODO change file source to Kafka (must)

    // read streaming data
    val sensorsSchema = Encoders.product[SensorsSchema].schema
    val streamIn = spark.readStream
      .format("csv")
      .schema(sensorsSchema)
      .load(dataDir + "stream/input/")
      .drop("OperatorId") // remove "OperatorId" column


    // TODO save result in S3 (nice to have)

    // write streaming data
    import org.apache.spark.sql.streaming.Trigger
    val streamOut = streamIn.writeStream
      .queryName("streamingOutput")
      .format("parquet")
      .option("checkpointLocation", dataDir + "stream/output/checkpoint/")
      .option("path", dataDir + "stream/output/")
      .trigger(Trigger.ProcessingTime(refreshInterval + " seconds"))
      .start()

    streamOut.awaitTermination() // start streaming data

  }
}

