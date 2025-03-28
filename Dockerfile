# 使用 Ubuntu 作为基础镜像
FROM ubuntu:20.04

# 设置环境变量
ENV HADOOP_VERSION 3.4.1
ENV HADOOP_HOME /opt/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $HADOOP_HOME/bin:$PATH

# 以root用户运行所有Hadoop服务
ENV HDFS_NAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root
ENV YARN_RESOURCEMANAGER_USER=root
ENV YARN_NODEMANAGER_USER=root

# 安装依赖并配置SSH
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirrors.tuna.tsinghua.edu.cn/ubuntu/|g' /etc/apt/sources.list
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openjdk-8-jdk \
    wget \
    openssh-server \
    ssh \
    rsync \
    vim \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# 配置SSH允许root登录
RUN mkdir -p /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# 设置SSH环境变量
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# 安装Hadoop
COPY hadoop-3.4.1.tar.gz /tmp/hadoop.tar.gz
RUN mkdir -p /opt && \
    tar -xzf /tmp/hadoop.tar.gz -C /opt && \
    mv /opt/hadoop-$HADOOP_VERSION $HADOOP_HOME && \
    rm /tmp/hadoop.tar.gz

# 配置Hadoop环境变量
RUN echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HADOOP_HOME=$HADOOP_HOME" >> /root/.bashrc && \
    echo "export PATH=$PATH" >> /root/.bashrc

# 复制配置文件
COPY core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml

# 配置SSH免密登录
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 600 ~/.ssh/authorized_keys

# 暴露端口
EXPOSE 9870 8088 50070 50075 50090 22

# 启动脚本
COPY start-hadoop.sh /start-hadoop.sh
RUN chmod +x /start-hadoop.sh

# 设置工作目录
WORKDIR $HADOOP_HOME

# 启动命令
CMD ["/start-hadoop.sh"]