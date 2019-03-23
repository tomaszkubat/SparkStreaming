name := "SparkApps"

version := "0.1"

// scala version compatible with Spark
scalaVersion := "2.11.12"

val sparkVersion = "2.4.0"

libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-sql" % sparkVersion,
  "org.apache.spark" %% "spark-streaming" % sparkVersion,
  "com.github.karasiq" %% "gdrive-api" % "1.0.13" // Google Drive API
  // libraryDependencies += "org.apache.spark" %%  "spark-streaming-kafka-0-10_2.11" % "2.4.0"
)