
pragma solidity ^0.5.1;

contract MyContract {

    mapping(address => uint256) public balances;

    // adressese NEED to be defined as payable to receive crypto
    address payable wallet;

    constructor(address payable _wallet) public {
        wallet = _wallet;
    }

    // this function NEEDS to be defined as public so 
    // it can be called from outside the contract
    function buyToken() public payable {
        // buy the token
        balances[msg.sender] += 1;

        // send ether to wallet
        wallet.transfer(msg.value);
    }
}