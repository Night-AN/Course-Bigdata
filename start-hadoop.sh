#!/bin/bash

# 格式化 HDFS
$HADOOP_HOME/bin/hdfs namenode -format

# 启动 SSH 服务
service ssh start

# 启动 HDFS
$HADOOP_HOME/sbin/start-dfs.sh

# 启动 YARN
$HADOOP_HOME/sbin/start-yarn.sh

# 保持容器运行
tail -f /dev/null