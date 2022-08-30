// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract CSAMM {
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    // keeping score of the reserve of tokens
    uint public reserve0;
    uint public reserve1;

    // keeping track of the total supply and the users balance
    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    // this initializes the token contracts
    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    // this function mints some tokens to an account
    function _mint(address _to, uint _amount) private{
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    // this function burns some tokens
    function _burn(address _from, uint _amount) private{
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    // this updates the reserveS
    function _update(uint _res0, uint _res1) private {
        reserve0 = _res0;
        reserve1 = _res1;
    }


    function swap(address _tokenIn, uint _amountIn) external returns (uint amountOut){
        require(_tokenIn == address(token0) || _tokenIn == address(token1), "invalid token" );

        // making variables to avoid if statements - thus optimizing gas use
        // the ternary operation (? :) gives some var before a question
        // then assigns them based on the answer to that question
        bool isToken0 = _tokenIn == address(token0);
        (IERC20 tokenIn, IERC20 tokenOut, uint resIn, uint resOut) = isToken0 ? 
        (token0, token1, reserve0, reserve1) : (token1, token0, reserve1, reserve0);

        // transfer token in
        // sending the token from smart contract caller to the contract
        tokenIn.transferFrom(msg.sender, address(this), _amountIn);
        uint amountIn = token0.balanceOf(address(this)) - resIn;

        // calculate amount out (including fees of 0.3%)
        amountOut = (amountIn *997) / 1000;

        // updating the reserve0 and reserve1
        // using another ternary operation
        (uint res0, uint res1) = isToken0 
            ? (resIn + _amountIn, resOut - amountOut)
            : (resOut - amountOut, resIn + _amountIn);
        _update(res0, res1);

        // transfer tokens out
        tokenOut.transfer(msg.sender, amountOut);
    }

    // this is what the user calls to addLiquidity and get some rewards
    function addLiquidity(uint _amount0, uint _amount1) external returns (uint shares){
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);

        uint bal0 = token0.balanceOf(address(this));
        uint bal1 = token1.balanceOf(address(this));

        uint d0 = bal0 - reserve0;
        uint d1 = bal1 - reserve1;   

        if(totalSupply == 0){
            shares = d0 + d1;
        } else {
            shares = (d0 + d1) *totalSupply / (reserve0 + reserve1);
        }

        require(shares > 0, "shares = 0");
        _mint(msg.sender, shares);
        _update(bal0, bal1);
    }
    
    // when a user calls this they burn their shares and get back the tokens locked in
    function removeLiquidity(uint _shares) external returns (uint d0, uint d1){
        d0 = (reserve0 * _shares) / totalSupply;
        d1 = (reserve1 * _shares) / totalSupply; 

        _burn(msg.sender, _shares);
        _update(reserve0 - d0, reserve1 - d1);

        if(d0 >0) {
            token0.transfer(msg.sender, d0);
        }

        if(d1 >0) {
            token1.transfer(msg.sender, d1);
        }
    }
}