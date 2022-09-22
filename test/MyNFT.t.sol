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

    function testMintTo(address recipient) public {
        vm.deal(recipient, 1 ether);
        vm.prank(recipient);
        my_nft.mintTo{value: 0.08 ether}(recipient);
        assertEq("https://www.example.com1", my_nft.tokenURI(1));
    }

    function testWithdrawPayments() public {
        address owner = my_nft.owner();
        address recipient = address(3);

        testMintTo(recipient);

        vm.prank(owner);
        my_nft.withdrawPayments(payable(recipient));
        assertEq(1 ether, recipient.balance);
    }

    function testFailMintTo(address recipient) public {
        uint256 balance = recipient.balance;
        vm.assume(balance < 0.08 ether);
        vm.prank(recipient);
        my_nft.mintTo{value: 0.08 ether}(recipient);
    }

    function testFailWithdrawPayments(address recipient) public {
        vm.assume(recipient != my_nft.owner());
        vm.prank(recipient);
        my_nft.withdrawPayments(payable(recipient));
    }
}
