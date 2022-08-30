
pragma solidity ^0.5.1;

contract ERC20Token {
    mapping(address => uint256) public balances;

    function mint() public {
        balances[tx.origin] ++;
    }
}

contract MyContract {
    address payable wallet;
    address public token;

    constructor(address payable _wallet, address _token) public {
        wallet = _wallet;
        token = _token;
    }

    function buyToken() public payable {
        ERC20Token(address(token)).mint();
        wallet.transfer(msg.value);
    }

}