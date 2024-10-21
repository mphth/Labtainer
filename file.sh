#!/bin/bash

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
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch

# Kiểm tra Elasticsearch
curl -X GET "localhost:9200/" || { echo "Elasticsearch không hoạt động"; exit 1; }

# Cài đặt Logstash
sudo yum -y install logstash

# Cài đặt Kibana
sudo yum -y install kibana

# Khởi động Kibana
sudo systemctl start kibana
sudo systemctl enable kibana

# Cài đặt Nginx (nếu chưa có)
sudo yum -y install epel-release
sudo yum -y install nginx

# Cài đặt Filebeat
sudo yum -y install filebeat

# Cấu hình Filebeat
sudo bash -c 'cat <<EOF > /etc/filebeat/filebeat.yml
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/nginx/*.log

output.logstash:
  hosts: ["localhost:5044"]
EOF'

# Khởi động Filebeat
sudo systemctl start filebeat
sudo systemctl enable filebeat

# Cấu hình Logstash
sudo bash -c 'cat <<EOF > /etc/logstash/conf.d/nginx.conf
input {
  beats {
    port => 5044
  }
}

filter {
  grok {
    match => { 
      "message" => "\[%{LOGLEVEL:log_level}\] Request \[id: %{NUMBER:request_id}\] from %{IP:client_ip}:%{NUMBER:client_port} %{WORD:method} %{URIPATHPARAM:uri}" 
    }
  }
}

output {
  elasticsearch {
    hosts => ["127.0.0.1:9200"]
    index => "nginx-%{+YYYY.MM.dd}"
  }
}
EOF'

# Khởi động Logstash
sudo systemctl start logstash
sudo systemctl enable logstash

echo "Cài đặt hoàn tất! Truy cập Kibana tại http://localhost:5601"
