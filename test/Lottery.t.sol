// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Lottery.sol";

contract LotteryTest is Test {
    Lottery public lottery;

    address creator = address(1);
    address user1 = address(2);
    address user2 = address(3);
    address user3 = address(4);
    address user4 = address(5);
    address user5 = address(6);
    address user6 = address(7);
    address protocol = address(32);

    function setUp() public {
        vm.startPrank(creator);
        lottery = new Lottery(0.001 ether, 9999);
        vm.stopPrank();

        address[] memory user = new address[](6);
        user[0] = user1;
        user[1] = user2;
        user[2] = user3;
        user[3] = user4;
        user[4] = user5;
        user[5] = user6;
    
        for (uint256 i; i < 6;) {
            vm.deal(user[i], 999 ether);
            unchecked {
                ++i;
            }
        }
    }

    function test_enter() public {
        vm.startPrank(user1);
        lottery.enter{value: 0.001 ether}();
        vm.stopPrank();

        assertEq(lottery.getParticipants().length, 1);
        assertEq(lottery.getBalance(), 0.001 ether);
    }

}
