#!/bin/bash

# 方法 1：使用 $UID
if [ "$UID" -eq 0 ]; then
    echo "Root user"
else
    echo "Unprivilege user"
    # 启动 SSH 服务
    echo "Starting SSH service..."
    sudo service ssh start

    # 检查 SSH 服务状态
    echo "Checking SSH service status..."
    sudo service ssh status
fi



# 格式化 HDFS（仅在第一次运行时需要）
if [ ! -f /home/hadoop/hadoop/data/namenode/formatted ]; then
    echo "Formatting HDFS..."
    $HADOOP_HOME/bin/hdfs namenode -format -force
    touch /home/hadoop/hadoop/data/namenode/formatted
fi

# 启动 HDFS
echo "Starting HDFS..."
$HADOOP_HOME/sbin/start-dfs.sh

# 启动 YARN
echo "Starting YARN..."
$HADOOP_HOME/sbin/start-yarn.sh

# 保持容器运行
tail -f /dev/null