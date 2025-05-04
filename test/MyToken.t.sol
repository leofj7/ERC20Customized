// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken token;
    address user1 = address(0x1);
    address user2 = address(0x2);

    function setUp() public {
        token = new MyToken();
        token.transfer(user1, 1000 ether);
    }

    function testTransferWorks() public {
        vm.prank(user1);
        token.transfer(user2, 100 ether);
        assertEq(token.balanceOf(user2), 100 ether);
    }

    function testPausePreventsTransfers() public {
        token.pause();
        vm.prank(user1);
        vm.expectRevert("Token: paused");
        token.transfer(user2, 100 ether);
    }

    function testBlacklistSender() public {
        token.addToBlacklist(user1);
        vm.prank(user1);
        vm.expectRevert("Sender is blacklisted");
        token.transfer(user2, 100 ether);
    }

    function testBlacklistReceiver() public {
        token.addToBlacklist(user2);
        vm.prank(user1);
        vm.expectRevert("Recipient is blacklisted");
        token.transfer(user2, 100 ether);
    }
}