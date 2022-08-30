// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract GasGolf {
    //
    // start - 50548 gas

    // use calldata - 48803 gas
    // simply using calldata instead of memory

    // load state variables to memory - 48592 gas
    // creating a var inside the function that is equal to the puplic,
    // this way we do not call the state var every time we call the loop

    // short circuit - 48274 gas
    // optimizing for code runs in if statements and && || and similar

    // loop increments - 48244 gas
    // simply using ++i instead of i ++ or i+=1

    // cache array length - 48209 gas
    // saving in a var the length of an array instead of calling array.legth over and over

    // load array elements to memory - 48047 gas
    // saving in a var the array[i] so we do not have to "find" in the array over and over 

    //
    // in total these techniques saved us 2500 gas

    uint public total;

    // this is how the function was at the start before being optimized for gas
    // [1, 2, 3, 4, 5, 100]
    // function sumIfEvenAndLessThan99(uint[] memory nums) external {
    //     for(uint i = 0; i < nums.length; i ++){
    //         bool isEven = nums[i] % 2 == 0;
    //         bool isLessThan99 = nums[i] < 99;
    //         if (isEven && isLessThan99) {
    //             total += nums[i];
    //         }
    //     }
    // }
    

    function sumIfEvenAndLessThan99(uint[] calldata nums) external {
        uint _total = total;
        uint len = nums.length;
        for(uint i = 0; i < len; ++i){
            uint num = nums[i];
            if (num % 2 == 0 && num < 99) {
                _total += num;
            }
        }
        total = _total;
    }
}