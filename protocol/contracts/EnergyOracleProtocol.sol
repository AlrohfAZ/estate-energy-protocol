// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./EstateRegistry.sol";

contract EnergyOracleProtocol {
    address public oracle;
    uint256 roundId;
    uint256 totalValidatedPerDay = 0;
    enum ClaimState {
        None,
        Submitted,
        Validated,
        Consumed
    }
    mapping(address => ClaimState) public claim;
    mapping(address => uint256) lastRoundClaimed;
    event ClaimSubmitted(address _address, uint256 roundId);
    event ClaimValidated(address _address, uint256 roundId);
    event ClaimConsumed(address _address, uint256 roundId);
    event CycleReset(uint256 roundId);

    EstateRegistry public estateRegistry;

    constructor(EstateRegistry _estateRegistry) {
        estateRegistry = EstateRegistry(_estateRegistry);
    }

    modifier onlyOracle() {
        require(msg.sender == oracle, "you are not the oracle");
        _;
    }

    /**
     * @dev Submits claim of production by an approved house with the Producer Role .
     */
    function submitClaim() public {
        require(estateRegistry.isProtocolActive(), "Protocol is inactive");
        estateRegistry.isApproved(msg.sender);
        require(
            estateRegistry.isProducer(msg.sender),
            "You are not a Producer"
        );
        if (lastRoundClaimed[msg.sender] < roundId) {
            claim[msg.sender] = ClaimState.None;
            lastRoundClaimed[msg.sender] = roundId;
        }
        require(
            claim[msg.sender] == ClaimState.None,
            "Already claimed this round"
        );
        claim[msg.sender] = ClaimState.Submitted;
        emit ClaimSubmitted(msg.sender, roundId);
    }

    /**
     * @dev Only the oracle validates the claim.
     * @param _address The address of the house that submits a production claim.
     */
    function validation(address _address) public onlyOracle {
        require(claim[_address] == ClaimState.Submitted);
        require(
            totalValidatedPerDay < estateRegistry.getMintCap(),
            "You have exceeded the daily cap"
        );
        totalValidatedPerDay++;
        claim[_address] = ClaimState.Validated;
        emit ClaimValidated(_address, roundId);
    }

    /**
     * @dev Approves mint after validation, called by rhe TokenContract.
     * @param _address The address of the house to be minted to.
     */
    function approveMint(address _address) public onlyOracle {
        require(claim[_address] == ClaimState.Validated);
        claim[_address] = ClaimState.Consumed;
        emit ClaimConsumed(_address, roundId);
    }

    /**
     * @dev Oracle resets the cycle daily.
     */
    function resetCycle() public onlyOracle {
        roundId += 1;
        totalValidatedPerDay = 0;
        emit CycleReset(roundId);
    }
}
