
pragma solidity ^0.5.1;

import "./SimpleMath.sol";

contract MyContract {
    uint256 public value;

    // remember that solidity does NOT support floating points numbers
    function calculate(uint _value1, uint _value2) public {
        value = Math.divide(_value1, _value2);
    }
}