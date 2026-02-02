// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./EstateRegistry.sol";
import "./EnergyOracleProtocol.sol";
contract EnergyToken {
    string tokenName = "Alrohf";
    string tokenSymbol = "ALR";
    uint256 maxMint = 10000000 * 10;

    event EnergyMinted(address producerer, uint256 amouunt);
    event EnergyTransferred(address from, address to, uint256 amount);
    event EnergyConsumed(address consumer, uint256 amount);

    function mint(uint256 amount) public payable {}

    function transferTo(address to, uint256 amount) public payable {}

    function convertToUsage(uint256 amount) public {}

    function usageOf(address user) public view returns (uint256) {}
}
