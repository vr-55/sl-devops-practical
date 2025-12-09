#!/bin/bash
set -e

# Basic updates
apt-get update -y

# Install chrony as NTP client/server
apt-get install -y chrony

# Ensure chrony is enabled and started
systemctl enable chrony
systemctl restart chrony

# Optional: basic time status log
timedatectl > /var/log/time-sync-status.log 2>&1
