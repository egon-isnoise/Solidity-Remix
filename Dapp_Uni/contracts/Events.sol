
pragma solidity ^0.5.1;

contract MyContract {

    mapping(address => uint256) public balances;

    // adressese NEED to be defined as payable to receive crypto
    address payable wallet;

    //this writes in the logs of the smart contract these events
    //this way you can check all the events directly 
    event Purchase(address indexed _buyer, uint256 _amount);

    constructor(address payable _wallet) public {
        wallet = _wallet;
    }

    // external means it can be called ONLY from outside the contract
    function() external payable {
        buyToken();
    }

    function buyToken() public payable {
        // buy the token
        balances[msg.sender] += 1;

        // send ether to wallet
        wallet.transfer(msg.value);

        emit Purchase(msg.sender, 1);
    }
}
