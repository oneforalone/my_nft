## Foundry 使用 script 部署

最新版本的 Foundry 已经支持使用 solidity 的 script 部署
合约，相比之前的命令行多个参数来说，简化了很多，同时也支持部署时
在 etherscan 开源。在使用前先执行 `foundryup`。

### 创建新项目

```shell
forge init my_nft
# install Openzeppelin lib for my_nft
cd my_nft
forge install openzeppelin/openzeppelin-contracts
```

### 配置 `.env` 和 `foundry.toml`

- `.env`

```shell
PRIVATE_KEY=
MAINNET_RPC_URL=
RINKEBY_RPC_URL=
ANVIL_RPC_URL="http://localhost:8545"
ETHERSCAN_KEY=
```

- `foundry.toml`

```yaml
[rpc_endpoints]
mainnet = "${MAINNET_RPC_URL}"
rinkeby = "${RINKEBY_RPC_URL}"
anvil = "${ANVIL_RPC_URL}"

[etherscan]
mainnet = { key = "${ETHERSCAN_KEY}" }
rinkeby = { key = "${ETHERSCAN_KEY}" }
```

`foundry.toml` 既可以读取 `.env` 中配置的变量，也可以显示定义，
一般来说放在 `.env` 中会更安全一点。

### 编写部署脚本

创建一个 `script/MyNFT.s.sol` 的文件：

```solidity
//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.10;

import "@forge-std/Script.sol";
import "../src/MyNFT.sol";

contract DeployMyNFT is Script {
    function run() external {
        address deployer = vm.addr(vm.envUint("PRIVATE_KEY"));

        console.log("The Deployer address:", deployer);
        console.log("Balance is:", deployer.balance);

        vm.startBroadcast(deployer);

        MyNFT nft = new MyNFT("MyNFT", "MYT", "https://www.example.com");
        vm.stopBroadcast();

        console.log("MyNFT deployed at:", address(nft));
    }
}
```

### 部署合约

```shell
# load config
source .env
# deploy
forge script DeployMyNFT --rpc-url <RPC_URL> --broadcast --verify
```

其中 `--verify` 是将合约代码开源。

目前 script 暂时不支持直接在部署脚本中直接定义 RPC，本地 Anvil 的话可以直接使用 `.env`
的环境变量，其他的网络不可以。

```shell
# load config
source .env
# deploy
forge script DeployMyNFT --rpc-url $ANVIL_RPC_URL --broadcast
```

虽然说还是需要输入 RPC，但是这比之前已经有很大的改进了，相信之后 foundry 会更加友好的。
