// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import { IWBTC } from "./WBTC.sol";
import { IMembers } from "./Members.sol";
import { IController } from "./interfaces/IController.sol";
import { Ownable } from "./utils/Ownable.sol";
import { SafeWBTC } from "./libraries/SafeWBTC.sol";
import { Claimable } from "./utils/Claimable.sol";

contract OwnableContractOwner is Claimable {
    event CalledTransferOwnership(Claimable ownedContract, address newOwner);
    function callTransferOwnership(Claimable ownedContract, address newOwner) external onlyOwner returns (bool) {
        require(newOwner != address(0), "invalid newOwner address");
        ownedContract.transferOwnership(newOwner);
        emit CalledTransferOwnership(ownedContract, newOwner);
        return true;
    }
    event CalledClaimOwnership(Claimable contractToOwn);
    function calledClaimOwnership(Claimable contractToOwn) external onlyOwner returns (bool) {
        contractToOwn.claimOwnership();
        emit CalledClaimOwnership(contractToOwn);
        return true;
    }
    event CalledReclaimToken(Claimable ownedContract, IWBTC _token);
    function callReclaimToken(Claimable ownedContract, IWBTC _token) external onlyOwner returns (bool) {
        require(address(_token) != address(0), "invalid token address");
        ownedContract.reclaimToken(_token);
        emit CalledReclaimToken(ownedContract, _token);
        return true;
    }
}
contract Controller is IController, OwnableContractOwner {
    IWBTC public token;
    IMembers public members;
    address public factory;
    event MembersSet(IMembers indexed members);
    event FactorySet(address indexed factory);
    event Paused();
    event Unpaused();
    constructor(IWBTC _token) {
        require(address(_token) != address(0), "invalid token address");
        token = _token;
    }
    modifier onlyFactory() {
        require(msg.sender == factory, "sender not authorized for minting or burning");
        _;
    }
    function setFactory(address _factory) external onlyOwner returns (bool) {
        require(_factory != address(0), "invalid factory address");
        factory = _factory;
        emit FactorySet(factory);
        return true;
    }
    function pause() external onlyOwner returns (bool) {
        token.pause();
        emit Paused();
        return true;
    }
    function unpause() external onlyOwner returns (bool) {
        token.unpause();
        emit Unpaused();
        return true;
    }
    function mint(address to, uint amount) external onlyFactory returns (bool) {
        require(to != address(0), "invalid to address");
        require(!token.paused(), "token is paused");
        require(token.mint(to,amount), "minting failed");
        return true;
    }
    function burn(uint value) external onlyFactory returns (bool) {
        require(!token.paused(), "token is paused");
        token.burn(value);
        return true;
    }
    function isCustodian(address addr) external view returns (bool) {
        return members.isCustodian(addr);
    }
    function isMerchant(address addr) external view returns (bool) {
        return members.isMerchant(addr);
    }
    function getWBTC() external view returns (IWBTC) {
        return token;
    }
    function renounceOwnership() public override view onlyOwner {
        revert("renouncing ownership is blocked");
    }
}

