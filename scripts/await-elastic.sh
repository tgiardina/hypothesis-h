#!/bin/bash
RETRIES=20
until curl http://elasticsearch:9200 > /dev/null 2>&1 || [ $RETRIES -eq 0 ];
do
  echo "Waiting for elasticsearch server, $((RETRIES--)) remaining attempts..."
  sleep 1
done
