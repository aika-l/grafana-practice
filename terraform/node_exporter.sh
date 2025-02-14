#!/bin/bash

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
PROMETHEUS_FILE="/etc/prometheus/prometheus.yml"
echo -e "\n- job_name: 'node_export'\n static_configs:\n - targets: [\"localhost:9100\"]" >> "$PROMETHEUS_FILE"
sed -i '/- job_name: '\''node_export'\''/s/^/ /' "$PROMETHEUS_FILE"
