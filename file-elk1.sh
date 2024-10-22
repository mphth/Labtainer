#!/bin/bash

set -e  # Dừng script khi có lỗi

# Cập nhật hệ thống
sudo yum -y update && sudo yum -y upgrade

# Cài đặt Java
sudo yum install -y java-1.8.0-openjdk-devel

# Cài đặt Elasticsearch
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat <<EOF | sudo tee /etc/yum.repos.d/elasticsearch.repo
[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
sudo yum -y install elasticsearch

# Khởi động Elasticsearch
sudo service elasticsearch start


echo "Cài đặt hoàn tất!"
