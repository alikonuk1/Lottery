// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "airnode/packages/airnode-protocol/contracts/rrp/requesters/RrpRequesterV0.sol";

contract Lottery is RrpRequesterV0{

    event RequestedRandomNumber(bytes32 indexed requestId);
    event ReceivedRandomNumber(bytes32 indexed requestId, uint256 randomNumber);

    address payable[] public participants;
    uint256 public entryFee;
    uint256 public raffleTime;
    uint256 public endTime;
    address public airnode;
    bytes32 public endpointId;
    address public sponsorWallet;

    mapping(bytes32 => bool) public pendingRequestIds; // mapping to store pending request ids

    constructor(
        address _airnode,
        bytes32 _endpointId,
        address _sponsorWallet,
        uint256 _entryFee,
        uint256 _raffleTime, 
        address _airnodeRrp) 
    RrpRequesterV0(_airnodeRrp)
    {
        airnode = _airnode;
        endpointId = _endpointId;
        sponsorWallet = _sponsorWallet;
        entryFee = _entryFee;
        raffleTime = _raffleTime;
        endTime = block.timestamp + raffleTime;
    }

    function enter() public payable {
        require(msg.value == entryFee, "Invalid entry fee");
        require(block.timestamp < endTime, "Lottery has ended");

        participants.push(payable(msg.sender));

    }

    function pickWinner() public payable {
        require(block.timestamp > endTime, "Lottery has not ended");
/*         require(msg.value == 0.05 ether, "Not enough eth to fund"); // For funding the sponsor wallet */

        bytes32 requestId = airnodeRrp.makeFullRequest(
            airnode,
            endpointId,
            address(this), // Use the contract address as the sponsor. This will allow us to skip the step of sponsoring the requester
            sponsorWallet,
            address(this), // Return the response to this contract
            this.endRaffle.selector, // Call this function with the response
            "" // No params
        );
        pendingRequestIds[requestId] = true;
        emit RequestedRandomNumber(requestId);
/*         (bool sent,) = sponsorWallet.call{value: msg.value}(""); // Send funds to sponsor wallet
        require(sent, "Failed to send Ether"); */
    }

    function endRaffle(bytes32 requestId, bytes calldata data) external onlyAirnodeRrp {

        uint256 randomIndex = abi.decode(data, (uint256)) % participants.length;
        address payable winner = participants[randomIndex];

        emit ReceivedRandomNumber(requestId, randomIndex); // Emit an event that the random number has been received

        winner.transfer(address(this).balance);
        (bool sent,) = winner.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether1");

        // Reset the lottery
        participants = new address payable[](0);
    }

    function getParticipants() public view returns (address payable[] memory) {
        return participants;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

}
