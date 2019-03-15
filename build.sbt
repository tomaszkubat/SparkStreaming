name := "SparkApps"

version := "0.1"

// scala version compatible with Spark
scalaVersion := "2.11.12"

val sparkVersion = "2.4.0"

libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-sql" % sparkVersion,
  "org.apache.spark" %% "spark-streaming" % sparkVersion
  // libraryDependencies += "org.apache.spark" %%  "spark-streaming-kafka-0-10_2.11" % "2.4.0"
)