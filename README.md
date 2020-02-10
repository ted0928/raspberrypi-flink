sudo docker run --name flink_jobmanager --hostname pi1.net -d -p 8081:8081 -p 6123-6125:6123-6125 -t ted0928/raspberry_flink:1.9.2.5 jobmanager

sudo docker run --name flink_taskmanager -e JOB_MANAGER_RPC_ADDRESS="pi1.net" -d -t ted0928/raspberry_flink:1.9.2.5 taskmanager
