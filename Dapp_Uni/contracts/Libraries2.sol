
pragma solidity ^0.8.0;

import "./SafeMath.sol";

contract MyContract {
    using SafeMath for uint256;
    uint256 public value;

    // remember that solidity does NOT support floating points numbers
    function calculate(uint _value1, uint _value2) public {
        value = SafeMath.div(_value1, _value2);
    }
}