// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Token {
    mapping (address => uint) public balances;
    mapping (address => mapping(address => uint)) public allowance;

    uint public totalSupply = 10000 * 10 ** 18;
    string public name = "Fist BNB Token";
    string public symbol = "TKN";
    uint public decimals = 18;

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    constructor() {
        balances[msg.sender] = totalSupply;
    }

    function balanceOf(address _owner) public view returns(uint){
        return balances[_owner];
    }

    function transfer(address _to, uint _value) public returns(bool){
        require(balanceOf(msg.sender) > _value, "Balance is too low");
        balances[_to] += _value;
        balances[msg.sender] -= _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) public returns(bool){
        require(balanceOf(_from) > _value, "Balance too low");
        require(allowance[_from][msg.sender] > _value, "Allowance is too low");
        balances[_to] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint _value) public returns(bool){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

}