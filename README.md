# Geth on Ubuntu

You need to run consensus and execution client after the Merge hardfork. But this script is still useful for installing and updating of existing Geth deploynments

### System requirements for Geth Ethereum node

| Resource | Testnet minimal  | Testnet recommended | Mainnet minimal  | Mainnet recommended |
|----------|------------------|---------------------|------------------|---------------------|
| Memory   | 4 GB             | 8 GB                | 8 GB             | 16 GB               |
| CPU      | 1 Cores          | 2 Cores             | 2 Cores          | 4 Cores             |
| SSD Disk | 350 GB           | 500 GB              | 1 TB _*_         | 2 TB                |
| Network  | 5 Mbps Up/Down   | 50 Mbps Up/Down     | 10  Mbps Up/Down | 100 Mbps Up/Down    |

_*_ It is possible to separate ancient directory from hot cache with `--datadir.ancient` options

Startig from geth version `1.13.1` geth support online prunning with option `--state.scheme=path`
Any version before after the initial fast sync of the full node, the data size is growing faster, so it recommended to truncate the blockchain periodically.

### Deployment on Ubuntu
This recipe can be used for direct deployment on *Ubuntu 22.04* or *20.04*, creating Packer or Docker images.
For initiall installation download edit and run [installation script](geth-ubuntu/geth-install-ubuntu.sh)

```bash
wget https://raw.githubusercontent.com/awesome-nodes/geth-ubuntu/master/geth-install-ubuntu.sh
chmod +x geth-install-ubuntu.sh
sudo ./geth-install-ubuntu.sh
```

To update an existing installation run [update script](geth-ubuntu/geth.sh)

- Script detects x86_64 / arm64 platform automatically
- Websocket and JSON-RPC api are enabled for public
