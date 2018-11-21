#!/bin/bash

if [[ -z "$KAFKA_BROKER_ID" ]]; then
    export KAFKA_BROKER_ID=0
fi

if [[ -z "$KAFKA_LOG_DIRS" ]]; then
    export KAFKA_LOG_DIRS="/data/kafka-logs-$KAFKA_BROKER_ID"
fi

#Issue newline to config file in case there is not one already
echo -e "\n" >> $KAFKA_HOME/config/server.properties


for VAR in `env`
do
  if [[ $VAR =~ ^KAFKA_ && ! $VAR =~ ^KAFKA_HOME ]]; then
    kafka_name=`echo "$VAR" | sed -r "s/KAFKA_(.*)=.*/\1/g" | tr '[:upper:]' '[:lower:]' | tr _ .`
    env_var=`echo "$VAR" | sed -r "s/(.*)=.*/\1/g"`
    if egrep -q "(^|^#)$kafka_name=" $KAFKA_HOME/config/server.properties; then
        #note that no config values may contain an '@' char
        sed -r -i "s@(^|^#)($kafka_name)=(.*)@\2=${!env_var}@g" $KAFKA_HOME/config/server.properties
    else
        echo "$kafka_name=${!env_var}" >> $KAFKA_HOME/config/server.properties
    fi
  fi
done

exec $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
