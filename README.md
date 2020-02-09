sudo docker run --name flink_jobmanager --hostname pi1 -p 8081:8081 -p 6123:6123 -d -t raspberry/flink:1.9.2 jobmanager
