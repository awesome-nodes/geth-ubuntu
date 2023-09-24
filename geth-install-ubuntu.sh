#!/bin/bash
set -euo pipefail

version=1.13.1
version_checksum=9e8cffb1de34bf644de413f32f33fb60
mount="/data/ethereum"

echo "==> Create ethereum data directory"
mkdir -p ${mount}

echo "==> Add ethereum user"
useradd -r -m -d ${mount} ethereum

echo "==> Prepare ether paths"
mkdir -m0700 -p ${mount}/execution/geth/
chown ethereum.ethereum ${mount}/execution/geth/

echo "==> Copy systemd config"
install -m 0644  -o root -g root etc/geth.service /etc/systemd/system/geth.service
systemctl daemon-reload

echo "==> Copy syslog config"
install -m 0644  -o root -g root etc/40-geth.conf /etc/rsyslog.d/40-geth.conf
systemctl restart rsyslog.service

echo "==> Copy logrotate config"
install -m 0644  -o root -g root etc/geth /etc/logrotate.d/geth
logrotate -f /etc/logrotate.d/geth

echo "==> Install geth ${version} ${version_checksum}"
bash geth.sh ${version} ${version_checksum}
systemctl daemon-reload
systemctl enable geth.service
