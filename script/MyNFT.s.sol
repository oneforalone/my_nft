//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.10;

import "@forge-std/Script.sol";
import "../src/MyNFT.sol";

contract DeployMyNFT is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        MyNFT nft = new MyNFT("MyNFT", "MYT", "https://www.example.com");
        vm.stopBroadcast();

        console.log("MyNFT deployed at: ", address(nft));
    }
}
