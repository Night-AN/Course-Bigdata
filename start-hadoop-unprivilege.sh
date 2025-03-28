#!/bin/bash

# 以 root 启动 SSH 服务
/usr/sbin/sshd

# 以 hadoop 用户运行，并加载完整环境
su - hadoop << EOF
export HADOOP_HOME=/home/hadoop/hadoop
export PATH=\$PATH:\$HADOOP_HOME/bin

# 启动 Hadoop 服务
hdfs namenode -format -force

${HADOOP_HOME}/sbin/start-dfs.sh
${HADOOP_HOME}/sbin/start-yarn.sh
${HADOOP_HOME}/bin/mapred --daemon start historyserver

# 保持容器运行
tail -f /dev/null
EOF
