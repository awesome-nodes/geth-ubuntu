#!/bin/bash
set -euo pipefail

# Update version and checksum on the download page
# https://geth.ethereum.org/downloads/

export VERSION_HASH=1.9.22-c71a7e26

echo "==> Check architecture for version ${VERSION_HASH}"
if [ $(uname --m) = x86_64 ]
then
    export GETH=geth-linux-amd64-${VERSION_HASH}
    export VERSION_CHECKSUM=c3b69840891c9a2d29cefa541269472a
elif [ $(uname --m) = aarch64 ]
then
    export GETH=geth-linux-arm64-${VERSION_HASH}
    export VERSION_CHECKSUM=0b499f72c19f8f95204c2a8ee3634393
else
    exit 1
fi
echo "==> Select GETH binary to ${GETH}"

echo "==> Add ethereum user"
useradd -r -m -d /var/lib/geth ethereum -s /bin/bash

echo "==> Prepare ether paths"
[ ! -d "/var/lib/geth/data" ] && mkdir -m0700 -p /var/lib/geth/data
chown ethereum.ethereum /var/lib/geth/data

echo "==> Create systemd config"
cat << EOF > /etc/systemd/system/geth.service
[Unit]
Description=Ethereum daemon
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=ethereum
Group=ethereum
WorkingDirectory=/var/lib/geth

# /run/geth
RuntimeDirectory=geth
RuntimeDirectoryMode=0710

ExecStartPre=+/bin/chown -R ethereum:ethereum /usr/local/bin/geth /var/lib/geth
ExecStart=/usr/local/bin/geth --nousb --cache=512 --datadir=/var/lib/geth/data \
  --ws --wsorigins '*' --ws.api eth,net,web3,debug \
  --http --http.vhosts '*' --http.corsdomain '*' --http.api eth,net,web3,debug
 
PIDFile=/run/geth/geth.pid
StandardOutput=journal
StandardError=journal
KillMode=process
TimeoutSec=180
Restart=always
RestartSec=60

[Install]
WantedBy=multi-user.target
EOF
chmod 0644 /etc/systemd/system/geth.service
chown root.root /etc/systemd/system/geth.service

echo "==> Create syslog config"
echo ':programname, startswith, "geth" /var/log/geth/geth.log' > /etc/rsyslog.d/100-geth.conf
chown root.root /etc/rsyslog.d/100-geth.conf
chmod 0644 /etc/rsyslog.d/100-geth.conf
systemctl restart rsyslog.service

echo "==> Create logrotate config"
cat << EOF > /etc/logrotate.d/geth
/var/log/geth/geth.log
{
  rotate 5
  daily
  copytruncate
  missingok
  notifempty
  compress
  delaycompress
  sharedscripts
}
EOF
chown root.root /etc/logrotate.d/geth
chmod 0644 /etc/logrotate.d/geth
logrotate -f /etc/logrotate.d/geth

echo "==> Install Geth binary"
wget -q -O /tmp/${GETH}.tar.gz \
  https://gethstore.blob.core.windows.net/builds/${GETH}.tar.gz

wget -q -O /tmp/${GETH}.tar.gz.asc \
  https://gethstore.blob.core.windows.net/builds/${GETH}.tar.gz.asc

gpg --keyserver hkp://keyserver.ubuntu.com --recv-key 9BA28146
gpg --verify /tmp/${GETH}.tar.gz.asc

md5sum  -c <(echo $VERSION_CHECKSUM /tmp/${GETH}.tar.gz)

tar -xzf /tmp/${GETH}.tar.gz -C /tmp/
cp /tmp/${GETH}/geth /usr/local/bin/geth
chown root.root /usr/local/bin/geth

echo "==> Update daemon"
systemctl daemon-reload
systemctl enable geth.service
