#!/bin/bash

# Prometheus and Node Exporter Installation Script for Rocky Linux
# Author: DevOps Automation Script
# Description: Installs Prometheus and Node Exporter with validation, dependency checks, and cleanup.

set -e

# Variables
PROMETHEUS_VERSION="2.52.0"
NODE_EXPORTER_VERSION="1.8.0"
PROMETHEUS_USER="prometheus"
NODE_EXPORTER_USER="node_exporter"
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# -------------------------------
# 🚀 Install Dependencies
# -------------------------------
echo "🛠️ Ensuring required dependencies are installed..."
#yum update -y
yum install -y tar wget

# Disable SELinux Temporarily
echo "🔧 Disabling SELinux temporarily..."
setenforce 0 || echo "SELinux is already disabled."

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# -------------------------------
# 🚀 Install Prometheus
# -------------------------------
if command_exists prometheus && systemctl is-active --quiet prometheus; then
    echo "✅ Prometheus is already installed and running. Skipping installation."
else
    echo "🛠️ Installing Prometheus..."

    # Create Prometheus User and Directories
    if id "$PROMETHEUS_USER" &>/dev/null; then
        echo "✅ Prometheus user already exists."
    else
        useradd --no-create-home --shell /bin/false $PROMETHEUS_USER
    fi

    mkdir -p /etc/prometheus /var/lib/prometheus
    chown $PROMETHEUS_USER:$PROMETHEUS_USER /etc/prometheus /var/lib/prometheus

    # Download and Install Prometheus
    wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
    tar -xvf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
    cd prometheus-${PROMETHEUS_VERSION}.linux-amd64
    mv prometheus promtool /usr/local/bin/
    chown $PROMETHEUS_USER:$PROMETHEUS_USER /usr/local/bin/prometheus /usr/local/bin/promtool
    mv consoles console_libraries prometheus.yml /etc/prometheus
    chown -R $PROMETHEUS_USER:$PROMETHEUS_USER /etc/prometheus
    cd ..
    rm -f prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
    rm -rf prometheus-${PROMETHEUS_VERSION}.linux-amd64

    # Configure Prometheus
    echo "🔧 Configuring Prometheus with IP: $IP_ADDRESS"
    bash -c "cat > /etc/prometheus/prometheus.yml" <<EOF
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['$IP_ADDRESS:9090']

  - job_name: 'node_exporter'
    static_configs:
      - targets: ['$IP_ADDRESS:9100']
EOF

    # Create Prometheus Service
    bash -c "cat > /etc/systemd/system/prometheus.service" <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=$PROMETHEUS_USER
Group=$PROMETHEUS_USER
Type=simple
ExecStart=/usr/local/bin/prometheus \\
  --config.file /etc/prometheus/prometheus.yml \\
  --storage.tsdb.path /var/lib/prometheus \\
  --web.console.templates=/etc/prometheus/consoles \\
  --web.console.libraries=/etc/prometheus/console_libraries \\
  --web.listen-address=0.0.0.0:9090

[Install]
WantedBy=multi-user.target
EOF

    # Start Prometheus Service
    echo "🚀 Starting Prometheus service..."
    systemctl daemon-reload
    systemctl enable --now prometheus
    systemctl status prometheus --no-pager
fi

# -------------------------------
# 🚀 Install Node Exporter
# -------------------------------
if command_exists node_exporter && systemctl is-active --quiet node_exporter; then
    echo "✅ Node Exporter is already installed and running. Skipping installation."
else
    echo "🛠️ Installing Node Exporter..."

    # Create Node Exporter User
    if id "$NODE_EXPORTER_USER" &>/dev/null; then
        echo "✅ Node Exporter user already exists."
    else
        useradd --no-create-home --shell /bin/false $NODE_EXPORTER_USER
    fi

    # Download and Install Node Exporter
    wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
    tar -xvf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
    mv node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/
    chown $NODE_EXPORTER_USER:$NODE_EXPORTER_USER /usr/local/bin/node_exporter
    rm -f node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
    rm -rf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64

    # Create Node Exporter Service
    bash -c "cat > /etc/systemd/system/node_exporter.service" <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=$NODE_EXPORTER_USER
Group=$NODE_EXPORTER_USER
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOF

    # Start Node Exporter Service
    echo "🚀 Starting Node Exporter service..."
    systemctl daemon-reload
    systemctl enable --now node_exporter
    systemctl status node_exporter --no-pager
fi

# -------------------------------
# ✅ Final Message
# -------------------------------
echo "🎯 Installation Complete!"
echo "Prometheus UI: http://$IP_ADDRESS:9090"
echo "Node Exporter Metrics: http://$IP_ADDRESS:9100/metrics"
