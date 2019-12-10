#! /bin/bash

## java环境变量,若没有配置,则添加下面配置
#export JAVA_HOME=/root/soft/jdk1.8.0_92
#export JRE_HOME=$JAVA_HOME/jre

if [ -z "$1" -o -z "$2" ]; then
    echo "format:dubbo start|restart|stop cluster_name"
    exit 1
fi

CLUSTER_NAME="$2"
echo "CLUSTER_NAME:$CLUSTER_NAME"

cd `dirname $0`
BIN_DIR=`pwd`
cd ..
ROOT_DIR=`pwd`
SERVICE_DIR="$ROOT_DIR/service"
LOG_DIR="$ROOT_DIR/log/$CLUSTER_NAME"
CLUSTER_DIR="$SERVICE_DIR/$CLUSTER_NAME"
CONF_DIR="$CLUSTER_DIR/conf"

echo "ROOT_DIR:$ROOT_DIR"
echo "BIN_DIR:$BIN_DIR"
echo "LOG_DIR:$LOG_DIR"
echo "SERVICE_DIR:$SERVICE_DIR"
echo "CLUSTER_DIR:$CLUSTER_DIR"
echo "CONF_DIR:$CONF_DIR"

SERVER_NAME=`sed '/^#/d;/dubbo.application.name/!d;s/.*=//' $CONF_DIR/dubbo.properties | tr -d '\r'`
SERVER_PORT=`sed '/^#/d;/dubbo.protocol.port/!d;s/.*=//' $CONF_DIR/dubbo.properties | tr -d '\r'`
STDOUT_FILE=`sed '/^#/d;/dubbo.log.file/!d;s/.*=//' $CONF_DIR/dubbo.properties | tr -d '\r'`
#JAVA_OPTS可以以"dubbo.java.options."为开头一项一项的配置，然后组合成一行java参数，因为一行配置的字符数有限制
JAVA_OPTS=`sed '/^#/d;/dubbo.java.options/!d;s/.*=//' $CONF_DIR/dubbo.properties | tr -d '\r'`

echo "JAVA_OPTS:$JAVA_OPTS"

if [ -n "$JAVA_OPTS" ]; then
    #GC日志路径无法通过配置文件直接配置
    JAVA_OPTS="$JAVA_OPTS -Xloggc:$LOG_DIR/gc`date +%Y%m%d`.log"
else
    JAVA_OPTS="-Xms1g -Xmx1g -Xmn512m -Xss1m -XX:MetaspaceSize=64m -XX:MaxMetaspaceSize=256m -XX:SurvivorRatio=16 -XX:MaxTenuringThreshold=10 -XX:+UseConcMarkSweepGC -XX:ParallelGCThreads=20 -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:+CMSScavengeBeforeRemark -XX:+UseCMSCompactAtFullCollection -XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:$LOG_DIR/gc`date +%Y%m%d`.log"
fi

echo "SERVER_NAME:$SERVER_NAME"
echo "SERVER_PORT:$SERVER_PORT"
echo "STDOUT_FILE:$STDOUT_FILE"
echo "JAVA_OPTS:$JAVA_OPTS"

STDOUT_DIR="$LOG_DIR/$STDOUT_FILE"
SERVICE_JAR=$CLUSTER_DIR/$SERVER_NAME\.jar

echo "STDOUT_DIR:$STDOUT_DIR"
echo "SERVICE_JAR:$SERVICE_JAR"

start() {
    PID=`ps -ef | grep java | grep "$CLUSTER_NAME" | grep -v grep | awk '{print $2}'`
    if [ "$PID" != "" ]; then
        echo "$CLUSTER_NAME is already start,process id is:$PID,port is:$SERVER_PORT"
        exit 1
    fi
    mkdir -p $LOG_DIR
    java $JAVA_OPTS -jar $SERVICE_JAR > "$STDOUT_DIR" 2>&1 &
    PID=`ps -ef | grep java | grep "$CLUSTER_NAME" | grep -v grep | awk '{print $2}'`
    if [ "$PID" == "" ]; then
        echo "$CLUSTER_NAME start fail"
    else
        echo "$CLUSTER_NAME start success,process id is:$PID,port is:$SERVER_PORT"
    fi
}

stop() {
    echo "stopping $CLUSTER_NAME"
    PID=`ps -ef | grep java | grep "$CLUSTER_NAME" | grep -v grep | awk '{print $2}'`
    if [ "$PID" == "" ]; then
        echo "$CLUSTER_NAME process not exists or stop success"
    else
        echo "killing $CLUSTER_NAME,process id is:$PID"
        sleep 5
        kill -9 $PID
        echo "$CLUSTER_NAME is stoped"
    fi
}

restart() {
    stop
    start
}

case "$1" in
    start)
        start
        ;;

    stop)
        stop
        ;;

    restart)
        restart
        ;;

    *)
        echo "format:dubbo start|restart|stop cluster_name"
        ;;
esac
exit 0
