#!/bin/bash

echo "Bắt đầu hoạt động của file.sh"
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

# Cài đặt Logstash
sudo yum -y install logstash 

# Tạo Tập Tin Dịch Vụ cho Logstash
cat <<EOF | sudo tee /etc/init.d/logstash
#!/bin/bash
# logstash: Startup script for Logstash

LOGSTASH_HOME=/usr/share/logstash
LOGSTASH_CONF=/etc/logstash/conf.d/nginx.conf

case "\$1" in
    start)
        echo "Starting Logstash..."
        nohup \$LOGSTASH_HOME/bin/logstash -f \$LOGSTASH_CONF > /var/log/logstash.log 2>&1 &
        echo \$! > /var/run/logstash.pid
        ;;
    stop)
        echo "Stopping Logstash..."
        if [ -f /var/run/logstash.pid ]; then
            kill \$(cat /var/run/logstash.pid)
            rm -f /var/run/logstash.pid
        else
            echo "Logstash is not running"
        fi
        ;;
    restart)
        echo "Restarting Logstash..."
        \$0 stop
        \$0 start
        ;;
    status)
        if [ -f /var/run/logstash.pid ]; then
            echo "Logstash is running"
        else
            echo "Logstash is not running"
        fi
        ;;
    *)
        echo "Usage: \$0 {start|stop|restart|status}"
        exit 1
esac
exit 0
EOF

# Cấp Quyền Thực Thi cho Dịch Vụ Logstash
sudo chmod +x /etc/init.d/logstash


# Khởi động Logstash
sudo service logstash start


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

# Khởi động lại Logstash
sudo service logstash restart

echo "Cài đặt hoàn tất!"
