// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import { IWBTC } from "./IWBTC.sol";
interface IController {
    function mint(address to, uint amount) external returns (bool);
    function burn(uint value) external returns (bool);
    function isCustodian(address addr) external view returns (bool);
    function isMerchant(address addr) external view returns (bool);
    function getWBTC() external view returns (IWBTC);
}