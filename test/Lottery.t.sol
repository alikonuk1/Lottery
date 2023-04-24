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
    address airnodeRrp = 0xa0AD79D995DdeeB18a14eAef56A549A04e3Aa1Bd; // mainnet
    address sponsor = 0xa0AD79D995DdeeB18a14eAef56A549A04e3Aa1Bd;
    address airnode = 0x9d3C147cA16DB954873A498e0af5852AB39139f2;
    bytes32 endpointId = 0xfb6d017bb87991b7495f563db3c8cf59ff87b09781947bb1e417006ad7f55a78;

    function setUp() public {
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

        vm.startPrank(creator);
        lottery = new Lottery(address(airnode), endpointId, address(sponsor), 0.001 ether, 9, address(airnodeRrp));
        vm.stopPrank();

    }

    /////////////////////////////////////////////
    //                 enter
    /////////////////////////////////////////////

    function testSuccess_enter() public {
        vm.startPrank(user1);
        lottery.enter{value: 0.001 ether}();
        vm.stopPrank();

        assertEq(lottery.getParticipants().length, 1);
        assertEq(lottery.getBalance(), 0.001 ether);
    }

    function testSuccess_enter_MultipleParticipants() public {
        vm.startPrank(user1);
        lottery.enter{value: 0.001 ether}();
        vm.stopPrank();

        assertEq(lottery.getParticipants().length, 1);
        assertEq(lottery.getBalance(), 0.001 ether);

        vm.startPrank(user2);
        lottery.enter{value: 0.001 ether}();
        vm.stopPrank();

        assertEq(lottery.getParticipants().length, 2);
        assertEq(lottery.getBalance(), 0.002 ether);

        vm.startPrank(user3);
        lottery.enter{value: 0.001 ether}();
        vm.stopPrank();

        assertEq(lottery.getParticipants().length, 3);
        assertEq(lottery.getBalance(), 0.003 ether);

        vm.startPrank(user4);
        lottery.enter{value: 0.001 ether}();
        vm.stopPrank();

        assertEq(lottery.getParticipants().length, 4);
        assertEq(lottery.getBalance(), 0.004 ether);

        vm.startPrank(user5);
        lottery.enter{value: 0.001 ether}();
        vm.stopPrank();

        assertEq(lottery.getParticipants().length, 5);
        assertEq(lottery.getBalance(), 0.005 ether);

        vm.startPrank(user6);
        lottery.enter{value: 0.001 ether}();
        vm.stopPrank();

        assertEq(lottery.getParticipants().length, 6);
        assertEq(lottery.getBalance(), 0.006 ether);
    }

    /////////////////////////////////////////////
    //               pickWinner
    /////////////////////////////////////////////

    function testRevert_pickWinner() public {
        vm.startPrank(user1);
        lottery.enter{value: 0.001 ether}();
        vm.stopPrank();

        assertEq(lottery.getParticipants().length, 1);
        assertEq(lottery.getBalance(), 0.001 ether);

        vm.startPrank(user2);
        lottery.enter{value: 0.001 ether}();
        vm.stopPrank();

        assertEq(lottery.getParticipants().length, 2);
        assertEq(lottery.getBalance(), 0.002 ether);

        vm.startPrank(user3);
        lottery.enter{value: 0.001 ether}();
        vm.stopPrank();

        assertEq(lottery.getParticipants().length, 3);
        assertEq(lottery.getBalance(), 0.003 ether);

        vm.startPrank(creator);
        vm.expectRevert("Lottery has not ended");
        lottery.pickWinner();
    }

    function testSuccess_pickWinner() public {
        vm.startPrank(user1);
        lottery.enter{value: 0.001 ether}();
        vm.stopPrank();

        assertEq(lottery.getParticipants().length, 1);
        assertEq(lottery.getBalance(), 0.001 ether);

        vm.startPrank(user2);
        lottery.enter{value: 0.001 ether}();
        vm.stopPrank();

        assertEq(lottery.getParticipants().length, 2);
        assertEq(lottery.getBalance(), 0.002 ether);

        vm.startPrank(user3);
        lottery.enter{value: 0.001 ether}();
        vm.stopPrank();

        assertEq(lottery.getParticipants().length, 3);
        assertEq(lottery.getBalance(), 0.003 ether);

        emit log_uint(block.timestamp);
        vm.warp(block.timestamp + 10);
        emit log_uint(block.timestamp);

        vm.startPrank(creator);
        lottery.pickWinner{value: 0.05 ether}();

        emit log_uint(block.timestamp);
        vm.warp(block.timestamp + 999999);
        emit log_uint(block.timestamp);

        emit log_uint(block.timestamp);
        vm.warp(block.timestamp + 999999);
        emit log_uint(block.timestamp);

    }
}
