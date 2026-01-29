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

    /**
     * @dev Approves houses and assigns roles.
     * @param wallet Address of the house to be proved.
     * @param role Assigned on approval of address.
     */

    function approveHouses(
        address wallet,
        Role role
    ) public onlyActive onlyAdmin {
        require(!approvedHouses[wallet], "House already approved");
        approvedHouses[wallet] = true;
        roles[wallet] = role;
        emit HouseApproved(wallet, role);
    }

    /**
     * @dev Revokes a house and is not capable of role assignment.
     * @param wallet Address of the house to be revoked.
     */

    function revokeHouses(address wallet) public onlyActive onlyAdmin {
        require(!revokedHouses[wallet], "House has been revoked");
        approvedHouses[wallet] = false;
        roles[wallet] = Role.None;
        emit HouseRevoked(wallet);
    }

    /**
     * @dev Sets dailyTariff to be used for the protocol.
     * @param newTariff The new value to be set for the tariff.
     */
    function setTariff(uint256 newTariff) public onlyActive onlyAdmin {
        dailyTariff = newTariff;
        emit TarrifUpdated(newTariff);
    }

    /**
     * @dev Sets the mintCap to be used by the protocol.
     * @param newCap The new value to be set for the mintCap.
     */
    function setMintCap(uint256 newCap) public onlyActive onlyAdmin {
        dailyMintcap = newCap;
        emit MintCapUpdated(newCap);
    }

    /**
     * @dev Sets the address for the Oracle used in the protocol.
     * @param newOracle The new address to be set oracle..
     */
    function setOracle(address newOracle) public onlyActive onlyAdmin {
        oracle = newOracle;
    }

    /**
     * @dev A simple getter function for the StableCoin.
     * @return The address of the stablecoin.
     */
    function getstableCoin() public view returns (address) {
        return stableCoin;
    }

    /**
     * @dev A simple getter function to get the role of a house.
     * @param wallet The address of the house to be queried.
     * @return The role of the house.
     */
    function getRole(address wallet) public view onlyActive returns (Role) {
        return roles[wallet];
    }

    /**
     * @dev A simple getter function to get the approval status of a house.
     * @param wallet The address of the house to be queried.
     * @return True or False.
     */
    function isApproved(address wallet) public view onlyActive returns (bool) {
        return approvedHouses[wallet];
    }

    /**
     * @dev A simple getter function to get the state of the protocol.
     * @return The Protocol state.
     */
    function getProtocolState() public view returns (ProtocolState) {
        return protocolState;
    }

    /**
     * @dev A simple getter function to get the mint cap.
     * @return The mint cap.
     */
    function getMintCap() public view returns (uint256) {
        return dailyMintcap;
    }

    /**
     * @dev A simple view function to check if an address is specifically a producer.
     * @param wallet The address of the house to be queried.
     * @return True or False.
     */
    function isProducer(address wallet) external view returns (bool) {
        Role r = roles[wallet];
        return r == Role.Producer || r == Role.Both;
    }

    /**
     * @dev A simple view function to specifically check if the protocol is active.
     * @return True or False.
     */
    function isProtocolActive() external view returns (bool) {
        require(protocolState == ProtocolState.Active, "Protocol is inactive");
        return true;
    }

    function getOracle() public view returns (address) {
        return oracle;
    }
}
