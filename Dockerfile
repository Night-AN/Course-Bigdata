# 使用 Ubuntu 作为基础镜像
FROM ubuntu:20.04

# 设置环境变量
ENV HADOOP_VERSION 3.4.1
ENV HADOOP_HOME /opt/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $HADOOP_HOME/bin:$PATH

ENV HDFS_NAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root
ENV YARN_RESOURCEMANAGER_USER=root
ENV YARN_NODEMANAGER_USER=root

# 安装依赖
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirrors.tuna.tsinghua.edu.cn/ubuntu/|g' /etc/apt/sources.list
RUN apt-get update -y
RUN apt-get install -y \
    openjdk-8-jdk \
    wget \
    ssh \
    rsync \
    vim \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# 下载并安装 Hadoop
COPY hadoop-3.4.1.tar.gz /tmp/hadoop.tar.gz
RUN tar -xzf /tmp/hadoop.tar.gz -C /home/hadoop && \
    mv /home/hadoop/hadoop-$HADOOP_VERSION $HADOOP_HOME && \
    rm /tmp/hadoop.tar.gz && \
    chown -R hadoop:hadoop $HADOOP_HOME

# 确保 Hadoop 配置目录存在
RUN mkdir -p $HADOOP_HOME/etc/hadoop && \
    chown -R hadoop:hadoop $HADOOP_HOME

# 配置 Hadoop 环境变量
RUN echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HADOOP_HOME=$HADOOP_HOME" >> /home/hadoop/.bashrc && \
    echo "export PATH=$PATH" >> /home/hadoop/.bashrc
    
# 复制 Hadoop 配置文件
COPY core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml

# 配置 SSH 免密登录
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# 暴露 Hadoop 端口
EXPOSE 9870 8088 50070 50075 50090

# 启动脚本
COPY start-hadoop.sh /start-hadoop.sh
RUN chmod +x /start-hadoop.sh

# 设置工作目录
WORKDIR $HADOOP_HOME

# 启动 Hadoop
CMD ["/start-hadoop.sh"]