#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
    echo "Povide version and checksum for geth release"
    echo "e.g. $0 1.13.1 9e8cffb1de34bf644de413f32f33fb60"
    exit
fi

version=$1
version_checksum=$2
url="https://gethstore.blob.core.windows.net/builds"

arch=$(uname -m)
arch=${arch/x86_64/amd64}
arch=${arch/aarch64/arm64}

commit_id=$(curl -s "https://api.github.com/repos/ethereum/go-ethereum/git/ref/tags/v${version}" | jq -r '.object.sha' | cut -c 1-8)
geth=geth-linux-${arch}-${version}-${commit_id}.tar.gz

echo "==> Install geth binary ${geth}"
cd /tmp
curl -OL ${url}/${geth}
curl -OL ${url}/${geth}.asc

gpg --keyserver hkp://keyserver.ubuntu.com --recv-key 9BA28146
gpg --verify /tmp/${geth}.asc

md5sum  -c <(echo ${version_checksum} /tmp/${geth})

mkdir -p /tmp/bin/
tar -xzf /tmp/${geth} -C /tmp/bin --strip-components=1
mv /tmp/bin/geth /usr/local/bin/geth

geth version
