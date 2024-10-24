sudo apt-get update -y

sudo apt-get install wget -y

sudo apt-get install curl -y

sudo apt-get install apt-utils -y

sudo apt-get install openjdk-11-jdk -y

sudo apt-get install apt-transport-https -y

sudo apt-get install gpg -y

sudo apt-get install firefox -y

wget  -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

sudo apt-get update -y

sudo apt-get install elasticsearch -y

sudo apt install kibana -y

sudo apt-get install filebeat -y


