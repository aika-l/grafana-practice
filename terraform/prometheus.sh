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
#./node_exporter.sh

#1. Create Node Exporter user
sudo useradd --system --no-create-home --shell /bin/false node_exporter

#2. Download and extract node exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz

#3. Move the binaries
sudo mv node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/bin/

#4. Configure node exporter as a systemd service
sudo bash -c 'cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
StartLimitIntervalSec=500
StartLimitBurst=5
[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter \
    --collector.logind
[Install]
WantedBy=multi-user.target
EOF'

#6. Enable and start node exporter
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
sudo systemctl status node_exporter

#7. Add Node Exporter as a Target in Prometheus
PROMETHEUS_YML="/etc/prometheus/prometheus.yml"

#8. Define the new job configuration to append
CONFIG="
  - job_name: 'node_export'
    static_configs:
      - targets: ['localhost:9100']
"

# Append the configuration to the 'scrape_configs' section
sudo sed -i "/scrape_configs:/a $CONFIG" "$PROMETHEUS_YML"

#9. Reload Prometheus Configuration
promtool check config /etc/prometheus/prometheus.yml
curl -X POST http://localhost:9090/-/reload



#1. Install grafana
sudo apt-get install -y apt-transport-https software-properties-common
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

sudo apt-get update
sudo apt-get -y install grafana


#2. Enable 
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
