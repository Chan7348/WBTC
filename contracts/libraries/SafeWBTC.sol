// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import "../interfaces/IWBTC.sol";

library SafeWBTC {
  function safeTransfer(
    IWBTC _token,
    address _to,
    uint256 _value
  )
    internal
  {
    require(_token.transfer(_to, _value));
  }

  function safeTransferFrom(
    IWBTC _token,
    address _from,
    address _to,
    uint256 _value
  )
    internal
  {
    require(_token.transferFrom(_from, _to, _value));
  }

  function safeApprove(
    IWBTC _token,
    address _spender,
    uint256 _value
  )
    internal
  {
    require(_token.approve(_spender, _value));
  }
}