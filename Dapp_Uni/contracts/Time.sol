

pragma solidity ^0.5.1;

contract MyContract {

    uint256 openingTime = 1653408189;

    modifier onlyWhileOpen() {
        // block.timestap is how u get "current" time 
        require(block.timestamp > openingTime);
        _;  
    }

    uint256 public peopleCount = 0;
    mapping(uint => Person) public people;

    struct Person {
        uint _id;
        string _firstName;
        string _lastName;
    }

    function addPerson(string memory _firstName, string memory _lastName) public onlyWhileOpen {
        incrementCount();
        people[peopleCount] = Person(peopleCount,_firstName, _lastName);
    }

    function incrementCount() internal{
        peopleCount ++;
    }
}