#!/bin/bash

# Cập nhật hệ thống
sudo apt update && sudo apt upgrade -y

# Cài đặt Java
sudo apt install openjdk-11-jdk -y

# Cài đặt Elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update

# Cài đặt Nginx (nếu chưa có)
sudo apt install nginx -y

# Cài đặt Filebeat
sudo apt install filebeat -y

# Khởi động Filebeat
sudo systemctl start filebeat
sudo systemctl enable filebeat

