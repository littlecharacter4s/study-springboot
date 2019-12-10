#! /bin/bash

## java环境变量,若没有配置,则添加下面配置
#export JAVA_HOME=/root/soft/jdk1.8.0_92
#export JRE_HOME=$JAVA_HOME/jre

if [ -z "$1" -o -z "$2" ]; then
    echo "format:springboot start|restart|stop cluster_name"
    exit 1
fi

CLUSTER_NAME="$2"
echo "CLUSTER_NAME:$CLUSTER_NAME"

cd `dirname $0`
BIN_DIR=`pwd`
cd ..
ROOT_DIR=`pwd`
APP_DIR="$ROOT_DIR/app"
LOG_DIR="$ROOT_DIR/log/$CLUSTER_NAME"
CLUSTER_DIR="$APP_DIR/$CLUSTER_NAME"
CONF_DIR="$CLUSTER_DIR/conf"

echo "ROOT_DIR:$ROOT_DIR"
echo "BIN_DIR:$BIN_DIR"
echo "LOG_DIR:$LOG_DIR"
echo "APP_DIR:$APP_DIR"
echo "CLUSTER_DIR:$CLUSTER_DIR"
echo "CONF_DIR:$CONF_DIR"

APP_NAME=`sed '/^#/d;/application.name/!d;s/.*=//' $CONF_DIR/application.properties | tr -d '\r'`
SERVER_PORT=`sed '/^#/d;/server.port/!d;s/.*=//' $CONF_DIR/application.properties | tr -d '\r'`
STDOUT_FILE=`sed '/^#/d;/application.logfile/!d;s/.*=//' $CONF_DIR/application.properties | tr -d '\r'`
#JAVA_OPTS可以以"java.options"为开头一项一项的配置，然后组合成一行java参数，因为一行配置的字符数有限制
JAVA_OPTS=`sed '/^#/d;/java.options/!d;s/.*=-/-/' $CONF_DIR/application.properties | tr -d '\r' | tr '\n' ' '`

if [ -z "$SERVER_PORT" ]; then
    SERVER_PORT=8080
fi

if [ -z "$STDOUT_FILE" ]; then
    STDOUT_FILE="/dev/null"
else
    STDOUT_FILE="$LOG_DIR/$STDOUT_FILE"
fi

if [ -n "$JAVA_OPTS" ]; then
    #GC日志路径无法通过配置文件直接配置
    JAVA_OPTS="$JAVA_OPTS -Xloggc:$LOG_DIR/gc`date +%Y%m%d`.log"
else
    JAVA_OPTS="-Xms1g -Xmx1g -Xmn512m -Xss1m -XX:MetaspaceSize=64m -XX:MaxMetaspaceSize=256m -XX:SurvivorRatio=16 -XX:MaxTenuringThreshold=10 -XX:+UseConcMarkSweepGC -XX:ParallelGCThreads=20 -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:+CMSScavengeBeforeRemark -XX:+UseCMSCompactAtFullCollection -XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:$LOG_DIR/gc`date +%Y%m%d`.log"
fi

echo "APP_NAME:$APP_NAME"
echo "SERVER_PORT:$SERVER_PORT"
echo "STDOUT_FILE:$STDOUT_FILE"
echo "JAVA_OPTS:$JAVA_OPTS"

APP_JAR=$CLUSTER_DIR/$APP_NAME\.jar

echo "APP_JAR:$APP_JAR"

start() {
    PID=`ps -ef | grep java | grep "$CLUSTER_NAME" | grep -v grep | awk '{print $2}'`
    if [ "$PID" != "" ]; then
        echo "$CLUSTER_NAME is already start,process id is:$PID,port is:$SERVER_PORT"
        exit 1
    fi
    mkdir -p $LOG_DIR
    java $JAVA_OPTS -jar $APP_JAR > "$STDOUT_FILE" 2>&1 &
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
