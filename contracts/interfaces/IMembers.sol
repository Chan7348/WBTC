// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

interface IMembers {
    function setCustodian(address _custodian) external returns (bool);
    function addMerchant(address merchant) external returns (bool);
    function removeMerchant(address merchant) external returns (bool);
    function isCustodian(address addr) external view returns (bool);
    function isMerchant(address addr) external view returns (bool);
}