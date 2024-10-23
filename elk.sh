|#!/bin/bash

# Cập nhật hệ thống
sudo apt update && sudo apt upgrade -y

# Cài đặt Java
sudo apt install openjdk-11-jdk -y

# Cài đặt Elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update
sudo apt install elasticsearch -y

# Khởi động Elasticsearch
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch

# Kiểm tra Elasticsearch
curl -X GET "localhost:9200/" || { echo "Elasticsearch không hoạt động"; exit 1; }

# Cài đặt Logstash
sudo apt install logstash -y

# Cài đặt Kibana
sudo apt install kibana -y

# Khởi động Kibana
sudo systemctl start kibana
sudo systemctl enable kibana

# Cài đặt Nginx (nếu chưa có)
sudo apt install nginx -y

# Khởi động Logstash
sudo systemctl start logstash
sudo systemctl enable logstash

echo "Cài đặt hoàn tất! Truy cập Kibana tại http://localhost:5601"
