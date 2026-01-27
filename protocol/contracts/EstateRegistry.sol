// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EstateRegistry {
    address public admin;
    address private stableCoin;
    address private treasury;
    string public estateName;
    uint256 public dailyTariff;
    uint256 public dailyMintcap;
    mapping(address => bool) approvedHouses;
    mapping(address => bool) revokedHouses;
    enum Role {
        None,
        Producer,
        Consumer,
        Both
    }
    mapping(address => Role) roles;
    address public oracle;
    enum ProtocolState {
        Active,
        Settlement_Pending,
        Blackout,
        Paused
    }
    ProtocolState public protocolState;

    event HouseApproved(address wallet, Role role);
    event HouseRevoked(address wallet);
    event TarrifUpdated(uint256 newTariff);
    event MintCapUpdated(uint256 newCap);

    constructor(
        address _admin,
        string memory _estateName,
        address _stableCoin,
        address _treasury,
        ProtocolState _protocolState
    ) {
        admin = _admin;
        estateName = _estateName;
        stableCoin = _stableCoin;
        treasury = _treasury;
        protocolState = _protocolState;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not the admin");
        _;
    }

    modifier onlyActive() {
        require(protocolState == ProtocolState.Active, "Protocol is inactive");
        _;
    }

    // This function approves houses
    function approveHouses(
        address wallet,
        Role role
    ) public onlyActive onlyAdmin {
        require(!approvedHouses[wallet], "House already approved");
        approvedHouses[wallet] = true;
        roles[wallet] = role;
        emit HouseApproved(wallet, role);
    }

    // This function revokes houses
    function revokeHouses(address wallet) public onlyActive onlyAdmin {
        require(!revokedHouses[wallet], "House has been revoked");
        approvedHouses[wallet] = false;
        roles[wallet] = Role.None;
        emit HouseRevoked(wallet);
    }

    // This function sets daily tariff
    function setTariff(uint256 newTariff) public onlyActive onlyAdmin {
        dailyTariff = newTariff;
        emit TarrifUpdated(newTariff);
    }

    // This function sets the cap for minting
    function setMintCap(uint256 newCap) public onlyActive onlyAdmin {
        dailyMintcap = newCap;
        emit MintCapUpdated(newCap);
    }

    // This function sets up the oracle
    function setOracle(address newOracle) public onlyActive onlyAdmin {
        oracle = newOracle;
    }

    function getstableCoin() public view returns (address) {
        return stableCoin;
    }

    function getRole(address wallet) public view onlyActive returns (Role) {
        return roles[wallet];
    }

    function isApproved(address wallet) public view onlyActive returns (bool) {
        return approvedHouses[wallet];
    }

    function getProtocolState() public view returns (ProtocolState) {
        return protocolState;
    }

    function getMintCap() public view returns (uint256) {
        return dailyMintcap;
    }

    function isProducer(address wallet) external view returns (bool) {
        Role r = roles[wallet];
        return r == Role.Producer || r == Role.Both;
    }

    function isProtocolActive() external view returns (bool) {
        require(protocolState == ProtocolState.Active, "Protocol is inactive");
        return true;
    }
}
