#!/bin/bash

# teraSort.test.sh

HDFS_ROOT_DIR=hdfs://d05-001.bigtop.deploy:8020
INPUT_DIR=$HDFS_ROOT_DIR"/Terasort-Input"
OUTPUT_DIR=$HDFS_ROOT_DIR"/Terasort-Output"
VALIDATE_DIR=$HDFS_ROOT_DIR"/Terasort-Validate"
VALIDATE_RESULTS_FILES=$VALIDATE_DIR"/*"
LOCAL_VALIDATE_DIR=/home/guodong/teraValidate_results-0427

echo $INPUT_DIR
echo $OUTPUT_DIR
echo $VALIDATE_RESULTS_FILES

JAR_FILENAME=/usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples-2.8.5.jar
N_MAP_TASKS=858
N_REDUCE_TASKS=143
SIZE=10737418240

N_LOOPS=100

test_once() {
 hadoop fs -rm -r $INPUT_DIR
 hadoop jar $JAR_FILENAME teragen -Dmapred.map.tasks=$N_MAP_TASKS $SIZE $INPUT_DIR

 hadoop fs -rm -r $OUTPUT_DIR

 hadoop jar $JAR_FILENAME terasort -Dmapred.reduce.tasks=$N_REDUCE_TASKS $INPUT_DIR $OUTPUT_DIR

 hadoop fs -rm -r $VALIDATE_DIR

 hadoop jar $JAR_FILENAME teravalidate $OUTPUT_DIR $VALIDATE_DIR

 hadoop fs -ls -R $VALIDATE_DIR

 hadoop fs -cat $VALIDATE_RESULTS_FILES
}

dump_local() {
 loop_num=$1
 local_dir=$LOCAL_VALIDATE_DIR"/"$loop_num
 mkdir -p $local_dir
 hadoop fs -get $VALIDATE_DIR $local_dir
} 

for (( c=1;c<$N_LOOPS+1; c++ ))
do  
   echo "=================="
   echo "Welcome $c times"
   echo "=================="
   test_once
   dump_local $c
done
