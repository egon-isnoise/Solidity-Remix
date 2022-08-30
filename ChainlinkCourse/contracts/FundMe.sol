
//SPDX-License-Identifier: MIT

pragma solidity >= 0.6.6 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    using SafeMathChainlink for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;

    constructor() public{
        owner = msg.sender;
    }

    modifier onlyOwner {
        // only want the contract admin/owner
        require(msg.sender == owner, "You are not the contract owner");
        _;
    }

    function fund() public payable {
        // $25
        uint256 minimumUSD = 5 *10 **18;
        // 1Gwei < $50
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
        // what ETH -> USD conversion rate

        funders.push(msg.sender);
    }

    function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);

        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex ++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }

    // function showHowMuch(uint256 funderIndex) public view returns(uint256) {
    //     address funder = funders[funderIndex];
    //     return addressToAmountFunded[funder];
    // }

    function revertFundings() payable onlyOwner public{
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex ++){
            address funder = funders[funderIndex];
            payable(funder).transfer(addressToAmountFunded[funder]);
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }

    // function getVersion() public view returns(uint256){
    //     AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    //     return priceFeed.version();
    // }

    function getEthPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed =  AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
    }

    function getMaticPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed =  AggregatorV3Interface(0x7794ee502922e2b723432DDD852B3C30A911F021);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
    }

    function getXtzPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed =  AggregatorV3Interface(0xf57FCa8B932c43dFe560d3274262b2597BCD2e5A);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getEthPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount / 1000000000000000000);
        return ethAmountInUsd;
    }
}