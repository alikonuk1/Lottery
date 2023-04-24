// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import {Lottery} from "src/Lottery.sol";

contract LotteryScript is Script {

    address airnodeRrp = 0xa0AD79D995DdeeB18a14eAef56A549A04e3Aa1Bd; // mainnet
    address sponsor = 0xa0AD79D995DdeeB18a14eAef56A549A04e3Aa1Bd;
    address airnode = 0x9d3C147cA16DB954873A498e0af5852AB39139f2;
    bytes32 endpointId = 0xfb6d017bb87991b7495f563db3c8cf59ff87b09781947bb1e417006ad7f55a78;
    
    function run() public {
        vm.broadcast();

        Lottery lottery = new Lottery(address(airnode), endpointId, address(sponsor), 0.001 ether, 9, address(airnodeRrp));
    }
}
