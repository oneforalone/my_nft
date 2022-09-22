// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.10;

import "@forge-std/Test.sol";
import "../src/MyNFT.sol";

error SendEtherFailed();

contract MyNFTTest is Test {
    MyNFT my_nft;

    function setUp() public {
        my_nft = new MyNFT("MyNFT", "MYT", "https://www.example.com");
    }

    function testMintTo() public {
        address recipient = address(86069);
        (bool sendTx, ) = payable(recipient).call{value: 1 ether}("");
        if (!sendTx) {
            revert SendEtherFailed();
        }
        vm.prank(recipient);
        my_nft.mintTo{value: 0.08 ether}(recipient);
        assertEq("https://www.example.com1", my_nft.tokenURI(1));
    }

    function testWithdrawPayments() public {
        testMintTo();

        address owner = my_nft.owner();
        vm.prank(owner);
        my_nft.withdrawPayments(payable(address(1)));
    }

    function testFailMintTo(address recipient) public {
        uint256 balance = recipient.balance;
        vm.assume(balance < 0.08 ether);
        vm.prank(recipient);
        my_nft.mintTo{value: 0.08 ether}(recipient);
    }

    function testFailWithdrawPayments(address user) public {
        vm.assume(user != my_nft.owner());
        vm.prank(user);
        my_nft.withdrawPayments(payable(user));
    }
}
