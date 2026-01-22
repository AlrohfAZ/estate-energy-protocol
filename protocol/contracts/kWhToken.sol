// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract kWhToken {
    string tokenName = "Alrohf";
    string tokenSymbol = "ALR";
    uint256 maxMint = 10000000 * 10;

    function mint(uint256 amount) public view {
        require(
            amount < maxMint,
            "Amount must be less than maximum Mint value"
        );
    }
}
