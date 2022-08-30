// SPDX_License_identifier: MIT

pragma solidity ^0.6.0;

import"./SimpleStorage.sol";

contract StorageFactory is SimpleStorage {

    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function howManyContracts() public view returns(uint256){
        return simpleStorageArray.length;
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public{
        // Address
        // ABI
        SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(_simpleStorageNumber);
    }

    function sfPerson(uint256 _simpleStorageIndex, string memory _simpleName, uint256 _simpleFavoriteNumber) public{
        // Address
        // ABI
        SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).addPerson(_simpleName, _simpleFavoriteNumber);
    }


    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){
        return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve();
    }


}