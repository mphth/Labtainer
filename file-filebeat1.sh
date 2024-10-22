#!/bin/bash

# Cập nhật hệ thống
sudo yum -y update && sudo yum -y upgrade

# Cài đặt Java (cho Elasticsearch)
sudo yum install -y java-1.8.0-openjdk-devel

# Thêm kho lưu trữ cho Elasticsearch
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

# Cập nhật hệ thống sau khi thêm repository
sudo yum -y update

# Cài đặt Nginx (nếu chưa có)
sudo yum install -y epel-release
sudo yum install -y nginx

# Cài đặt Filebeat
sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
cat <<EOF | sudo tee /etc/yum.repos.d/elastic.repo
[elastic-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
sudo yum install -y filebeat


echo "Cài đặt Filebeat hoàn tất! Sử dụng lệnh " sudo service filebeat start " để Khởi động Filebeat"
