// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

interface IWBTC {
    function totalSupply() external view returns (uint256);
    function balanceOf(address _who) external view returns (uint256);
    function transfer(address _to, uint256 _value) external returns (bool);
    function allowance(address _owner, address _spender) external view returns (uint);
    function transferFrom(address _from, address _to, uint _value) external returns (bool);
    function approve(address _spender, uint _value) external returns (bool);
    function increaseApproval(address _spender, uint _addedValue) external returns (bool);
    function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool);
    function mint(address _to, uint _amount) external returns (bool);
    function finishMinting() external returns (bool);
    function burn(uint _value) external returns (bool);
    function paused() external returns (bool);
    function pause() external;
    function unpause() external;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address owner, address spender, uint value);
    event Mint(address indexed to, uint amount);
    event MintFinished();
    event Burn(address indexed burner, uint value);
    event Pause();
    event Unpause();
}