#!/bin/sh

yum update -y && \
yum install -y python3 git curl nano tree bash tar maven docker wget \
yum autoremove -y && \
rm -rf ~/.cache/pip && \
yum clean all && \
rm -rf /var/cache/yum

wget https://download.java.net/java/GA/jdk13.0.2/d4173c853231432d94f001e99d882ca7/8/GPL/openjdk-13.0.2_linux-x64_bin.tar.gz
tar xvf openjdk-13.0.2_linux-x64_bin.tar.gz
sudo mv jdk-13.0.2/ /opt

export JAVA_HOME=/opt/jdk-13.0.2
export PATH=$PATH:$JAVA_HOME/bin

#export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.8.10-0.el7_8.x86_64/
export JAVA=$JAVA_HOME/bin/java
#export PATH=$PATH:$JAVA_HOME/bin
export JAVA_VERSION=13