#!/bin/bash

if [[ -z "$KAFKA_BROKER_ID" ]]; then
    export KAFKA_BROKER_ID=-1
fi
if [[ -z "$KAFKA_LOG_DIRS" ]]; then
    export KAFKA_LOG_DIRS="/data/kafka-logs-$KAFKA_BROKER_ID"
fi
if [[ -z "$KAFKA_ZOOKEEPER_CONNECT" ]]; then
    export KAFKA_ZOOKEEPER_CONNECT=$(env | grep ZK.*PORT_2181_TCP= | sed -e 's|.*tcp://||' | paste -sd ,)
fi

#Issue newline to config file in case there is not one already
echo -e "\n" >> $KAFKA_HOME/config/server.properties


for VAR in `env`
do
  if [[ $VAR =~ ^KAFKA_ && ! $VAR =~ ^KAFKA_HOME ]]; then
    kafka_name=`echo "$VAR" | sed -r "s/KAFKA_(.*)=.*/\1/g" | tr '[:upper:]' '[:lower:]' | tr _ .`
    env_var=`echo "$VAR" | sed -r "s/(.*)=.*/\1/g"`
    if egrep -q "(^|^#)$kafka_name=" $KAFKA_HOME/config/server.properties; then
        sed -r -i "s@(^|^#)($kafka_name)=(.*)@\2=${!env_var}@g" $KAFKA_HOME/config/server.properties #note that no config values may contain an '@' char
    else
        echo "$kafka_name=${!env_var}" >> $KAFKA_HOME/config/server.properties
    fi
  fi

  if [[ $VAR =~ ^LOG4J_ ]]; then
    log4j_name=`echo "$VAR" | sed -r "s/(LOG4J_.*)=.*/\1/g" | tr '[:upper:]' '[:lower:]' | tr _ .`
    log4j_env=`echo "$VAR" | sed -r "s/(.*)=.*/\1/g"`
    if egrep -q "(^|^#)$log4j_name=" $KAFKA_HOME/config/log4j.properties; then
        sed -r -i "s@(^|^#)($log4j_name)=(.*)@\2=${!log4j_env}@g" $KAFKA_HOME/config/log4j.properties #note that no config values may contain an '@' char
    else
        echo "$log4j_name=${!log4j_env}" >> $KAFKA_HOME/config/log4j.properties
    fi
  fi
done

exec $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
