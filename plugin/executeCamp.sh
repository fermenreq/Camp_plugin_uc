#!/bin/bash

# This script automates the start-up of CityGo services and it performs a stress test
#
# The ramp-up period tells JMeter how long to take to "ramp-up" to the full number of threads chosen. 
# If 10 threads are used, and the ramp-up period is 100 seconds, 
# then JMeter will take 100 seconds to get all 10 threads up and running
#
# User x second x time = Ramp-up / threads = seconds/thread
#
# Maintainer Fernando Mendez - fernando.mendez@atos.net
#

CONTAINERS= sudo docker ps -q
WEB= sudo lsof -t -i:80
POSTGRES= sudo lsof -t -i:5432
HOST=localhost
PORT=80


if ["$WEB" -ne ""];then
  sudo kill -9 $WEB
fi

if ["$POSTGRES" -ne ""]; then
  sudo kill -9 $POSTGRES
fi

#Ask configuration values for stress tests
echo "Define a number of threads to use:"
read numThreads
echo "Define the Ramp time (to launch the threads):"
read rampTime
echo "--------------------------------------------------"

#Path directory where is the test
TEST_PATH_FILE=../Tests/Test-version2.jmx
RESULT_PATH_FILE=../Tests/Result.jtl
#JMETER_CONF='-Jjmeter.save.saveservice.data_type=false -Jjmeter.save.saveservice.label=true -Jjmeter.save.saveservice.response_message=false
#-Jjmeter.save.saveservice.thread_name=false -Jjmeter.save.saveservice.latency=true -Jjmeter.save.saveservice.bytes=false
#-Jjmeter.save.saveservice.thread_counts=false -Jjmeter.save.saveservice.timestamp_format=none -Jjmeter.save.saveservice.print_field_names=true'
JMETER_CONF='-Jjmeter.save.saveservice.data_type=false -Jjmeter.save.saveservice.label=true -Jjmeter.save.saveservice.response_message=false
-Jjmeter.save.saveservice.thread_name=false -Jjmeter.save.saveservice.latency=true -Jjmeter.save.saveservice.bytes=false
-Jjmeter.save.saveservice.thread_counts=false -Jjmeter.save.saveservice.timestamp_format=none'
echo You are using $numThreads connections to all the tests
echo "--------------------------------------------------"
echo "Starting JMeter.."
echo "with configuration: " $JMETER_CONF
echo " "
echo "Removing previous results file: " $RESULT_PATH_FILE
rm $RESULT_PATH_FILE
jmeter $JMETER_CONF -n -t $TEST_PATH_FILE -l $RESULT_PATH_FILE -JnumThreads=$numThreads -JrampTime=$rampTime -JHost=$HOST -JPort=$PORT
echo "--------------------------------------------------"


echo "Computing Test statistics"
echo "Mean response time:"  
awk -F "\"*,\"*" '{print $1}' $RESULT_PATH_FILE | awk 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}'

echo "Std Deviation response time:"  
awk -F "\"*,\"*" '{print $1}' $RESULT_PATH_FILE | awk '{x+=$0;y+=$0^2}END{print sqrt(y/NR-(x/NR)^2)}'


