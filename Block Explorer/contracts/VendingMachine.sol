// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VendingMachine {
    address public owner;
    mapping (address => uint256) public donutBalances;

    // simple modifier to make some functions available only to the owner
    modifier onlyOwner(){
        require (msg.sender == owner, "Only the owner can call this function you putz");
        _;
    }

    // a constructor is a function that is called only when deploying the contract
    // makes the owner the address that deploys and sets 100 donuts as the initial "balance"
    constructor(){
        owner = msg.sender;
        donutBalances[address(this)] = 100;
    }

    // shows how many donuts are stored into the contract address
    function getMachineDonutsBalance() public view returns(uint) {
        return donutBalances[address(this)];
    }
    
    // shows how much ether is stored in the contract address
    function getMachineBalance() public view onlyOwner returns(uint){
        return address(this).balance; // (10 **18);
    }

    // lets any contract purchase a donut IF they have enough ETH and the machine has enough stock
    function purchase(uint buyingAmount) public payable {
        require(msg.value >= buyingAmount * 1 ether, "1 ETH per donut you poor bastard");
        require(donutBalances[address(this)] >= buyingAmount, "Not enough donuts in stock MF");
        donutBalances[address(this)] -= buyingAmount;
        donutBalances[msg.sender] += buyingAmount;
        
    }

    // restocks the smart contract of "donuts"
    function restock(uint amount) public payable onlyOwner {
        // the price of restoking donuts is half of the paying price
        uint256 restockPrice = amount/2 * (10 **18);
        require(msg.value >= restockPrice, "You have to pay for donuts too you know? Food is not free");
        donutBalances[address(this)] += amount;

        // this sends the amount to a burner address
        payable(0xb69Fba56B2E67E7DdA61c8aA057886A8d1468575).transfer((restockPrice /amount) *(amount-1));
    }

    // lets only the owner retrieve the funds inside the smart contract to an address of choice
    function retrieveFunds(address payable _to) public onlyOwner{
        _to.transfer(address(this).balance);
    }
}
