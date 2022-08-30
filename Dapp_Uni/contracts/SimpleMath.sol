
pragma solidity ^0.5.1;

// a library can be recalled in other codes
// they don't have storage and you cannot hinerit from them
library Math {
    function divide(uint256 a, uint256 b) internal pure returns (uint256){
        require(b > 0);
        uint256 c = a/b;
        return c;
    }
}