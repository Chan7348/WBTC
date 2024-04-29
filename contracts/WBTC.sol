// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
// burnable + mintable + ownable + pausable + claimable
import { Ownable } from "./utils/Ownable.sol";
import { IWBTC } from "./interfaces/IWBTC.sol";
import { Claimable } from "./utils/Claimable.sol";

contract WBTC is IWBTC, Claimable {
    // https://basescan.org/address/0x3b5e737444e81dbeae48d24948e77527f3e5e3c0#code
    // 0x3b5e737444e81dbeae48d24948e77527f3e5e3c0
    string public name;
    string public symbols;
    uint8 public decimals;
    uint internal totalSupply_;
    bool public mintingFinished = false;
    bool public paused = false;
    mapping(address => uint) internal balances_;
    mapping(address => mapping(address => uint)) allowance_;
    constructor() {
        name = "Wrapped BTC";
        symbols = "WBTC";
        decimals = 8;
    }
    function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
        require(balances_[msg.sender] >= _value, "Insufficient Balance!");
        require(_to != address(0), "You must burn it through the function!");
        balances_[msg.sender] -= _value;
        balances_[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    function totalSupply() public view returns (uint) {
        return totalSupply_;
    }
    function balanceOf(address _owner) public view returns (uint) {
        return balances_[_owner];
    }
    function allowance(address _owner, address _spender) public view returns (uint) {
        return allowance_[_owner][_spender];
    }
    function approve(address _spender, uint _value) public whenNotPaused returns (bool) {
        allowance_[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
        require(allowance_[_from][msg.sender] >= _value, "insufficient allowance");
        require(balances_[_from] >= _value, "Insufficient Balance!");
        require(_to != address(0), "Cannot transfer to address0");
        allowance_[_from][msg.sender] -= _value;
        balances_[_from] -= _value;
        balances_[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
        allowance_[msg.sender][_spender] += _addedValue;
        emit Approval(msg.sender, _spender, allowance_[msg.sender][_spender]);
        return true;
    }
    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
        uint oldValue = allowance_[msg.sender][_spender];
        if (oldValue <= _subtractedValue) {
            allowance_[msg.sender][_spender] = 0;
        } else {
            allowance_[msg.sender][_spender] -= _subtractedValue;
        }
        emit Approval(msg.sender, _spender, allowance_[msg.sender][_spender]);
        return true;
    }
    modifier canMint() {
        require(!mintingFinished);
        _;
    }
    modifier hasMintPermission() {
        require(msg.sender == owner);
        _;
    }
    function mint(address _to, uint _amount) public canMint hasMintPermission returns (bool) {
        totalSupply_ += _amount;
        balances_[_to] += _amount;
        emit Mint(_to, _amount);
        emit Transfer(address(0), _to, _amount);
        return true;
    }
    function finishMinting() public view onlyOwner canMint returns (bool) {
        return false;
    }
    function burn(uint _value) public onlyOwner returns (bool){
        require(_value <= balances_[msg.sender], 'Insufficient balance to burn!');
        totalSupply_ -= _value;
        balances_[msg.sender] -= _value;
        emit Burn(msg.sender, _value);
        emit Transfer(msg.sender, address(0), _value);
        return true;
    }
    modifier whenNotPaused() {
        require(!paused);
        _;
    }
    modifier whenPaused() {
        require(paused);
        _;
    }
    function pause() public onlyOwner whenNotPaused {
        paused = true;
        emit Pause();
    }
    function unpause() public onlyOwner whenPaused {
        paused = false;
        emit Unpause();
    }
    function renounceOwnership() public view onlyOwner override {
        revert("renouncing ownership is blocked");
    }
}