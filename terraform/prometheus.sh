#!/bin/bash

sudo apt update

#1. Create Prometheus user
sudo useradd --system --no-create-home --shell /bin/false prometheus

#2. Download and extract prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz
tar -xvf prometheus-2.45.0.linux-amd64.tar.gz  

#3. Dir for prometheus
sudo mkdir -p /data /etc/prometheus
cd prometheus-2.45.0.linux-amd64
sudo mv prometheus promtool /usr/local/bin/
sudo mv consoles/ console_libraries/ /etc/prometheus/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml

#4. Set ownership
sudo chown -R prometheus:prometheus /etc/prometheus/ /data/

#5. Configure prometheus as a systemd service
sudo bash -c 'cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/data \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle

[Install]
WantedBy=multi-user.target[Install]
WantedBy=multi-user.target
EOF'


#6. Enable and start prometheus
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus


# Installation of Node Exporter
#sudo chmod +x node_exporter.sh
./node_exporter.sh

