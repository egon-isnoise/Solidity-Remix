
pragma solidity ^0.5.1;

contract MyContract {

    address owner;
    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        // this sender refers to the person who called this contract
        require(msg.sender == owner);
        _;  // modifiers do need these underlines
    }

    uint256 public peopleCount = 0;
    mapping(uint => Person) public people;

    struct Person {
        uint _id;
        string _firstName;
        string _lastName;
    }

    function addPerson(string memory _firstName, string memory _lastName) public onlyOwner {
        incrementCount();
        people[peopleCount] = Person(peopleCount,_firstName, _lastName);
    }

    function incrementCount() internal{
        peopleCount ++;
    }
}