// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./RrpRequesterV0.sol";

contract Lottery is RrpRequesterV0{
    address payable[] public participants;
    uint256 public entryFee;
    uint256 public endTime;

    constructor(uint256 _entryFee, uint256 _endTime, address _airnodeRrpAddress) 
    RrpRequesterV0(_airnodeRrpAddress)
    {
        entryFee = _entryFee;
        endTime = _endTime;
    }

    function enter() public payable {
        require(msg.value == entryFee, "Invalid entry fee");
        require(block.timestamp < endTime, "Lottery has ended");

        participants.push(payable(msg.sender));

    }

    function pickWinner() public {
        require(block.timestamp < endTime, "Lottery has ended");

        uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % maxParticipants;
        address payable winner = participants[randomIndex];

        winner.transfer(address(this).balance);

        // Reset the lottery
        participants = new address payable[](0);
    }

    function getParticipants() public view returns (address payable[] memory) {
        return participants;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getRandom() public view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)));
    }
}
