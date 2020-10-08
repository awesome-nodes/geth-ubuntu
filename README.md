# Ethereum Awesome Nodes

Ethereum is a global, open-source platform for decentralized applications. [Offical site](https://ethereum.org)

### System requirements for Geth Ethereum node

Testnet (Rinkeby):

| Resource | Minimal option   | Recommended option |
|----------|------------------|--------------------|
| Memory   | 4 GB _*_         | 8 GB               | 
| CPU      | 1 Cores          | 2 Cores            |
| Disk     | 50 GB SSD        |                    |
| Network  | 5 Mbps Up/Down   | 50 Mbps Up/Down    |

_*_ Require `--cache=512` option

Mainnet:

| Resource | Minimal option   | Recommended option      |
|----------|------------------|-------------------------|
| Memory   | 8 GB             | 16 GB                   | 
| CPU      | 2 Cores          | 4 Cores                 |
| Disk     | 200 GB _*_          | 500 GB SSD for hot data |
| Disk     | 200 GB _*_          | 500 GB HDD for ancient  |
| Network  | 10  Mbps Up/Down | 100 Mbps Up/Down        |

_*_ It is possible to separate ancient directory from hot cache with `--datadir.ancient` options: 

After the initial fast sync of the full node, the data size is growing faster, so it recommended to truncate the blockchain periodically

### Contents
- [Deployment in Ubuntu](#deployment-in-ubuntu)

### Deployment in Ubuntu
This recipe can be used for direct deployment in *Ubuntu 20.04* or *18.04*, creating Packer or Docker images.
Download, update and run [installation script](geth-ubuntu/geth-install-ubuntu.sh)

```bash
wget https://raw.githubusercontent.com/awesome-nodes/ethereum/master/geth-ubuntu/geth-install-ubuntu.sh
chmod +x geth-install-ubuntu.sh
sudo ./geth-install-ubuntu.sh
```

* Script detects x86_64 / arm64 platform automatically
* Websocket and JSON-RPC api are enabled for localhost
* `--cache=512` is set to fit into 4GB RAM servers, i.g. Raspbery Pi4. Remove to use default value 4096 for 8 GB RAM.