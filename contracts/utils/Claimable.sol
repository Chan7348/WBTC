// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import { Ownable } from "./Ownable.sol";
import { IWBTC } from "../interfaces/IWBTC.sol";
contract Claimable is Ownable {
    address public pendingOwner;
    modifier onlyPendingOwner() {
        require(msg.sender == pendingOwner);
        _;
    }
    function transferOwnership(address newOwner) public override onlyOwner {
        pendingOwner = newOwner;
    }
    function claimOwnership() public onlyPendingOwner {
        emit OwnershipTransferred(owner, pendingOwner);
        owner = pendingOwner;
        pendingOwner = address(0);
    }
    function reclaimToken(IWBTC _token) external onlyOwner {
        uint balance = _token.balanceOf(address(this));
        _token.transfer(owner, balance);
    }
}