pragma solidity =0.6.6;

import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Callee.sol';
import '@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
import '@uniswap/v2-core/contracts/interfaces/IERC20.sol';

contract MyUniswapFlashSwap is IUniswapV2Callee {
  address immutable factory;
  uint constant deadline = 10 days;
  IUniswapV2Router02 immutable otherSwapRouter;
  // Other Swaps: Pancake, Sushiswap, Bakeryswap

  constructor(address _factory, address _otherSwapRouter) public {
    factory = _factory;  
    otherSwapRouter = IUniswapV2Router02(_otherSwapRouter);
  }

  function uniswapV2Call(address _sender, uint _amount0, uint _amount1, bytes calldata _data) external {  
      address[] memory path = new address[](2); // Store addresses of both the tokens
    
      address token0 = IUniswapV2Pair(msg.sender).token0();
      address token1 = IUniswapV2Pair(msg.sender).token1();
      
      require(_amount0 == 0 || _amount1 == 0); // Both token ammount cannot be 0
      require(msg.sender == UniswapV2Library.pairFor(factory, token0, token1), "Unauthorized"); // ensure that msg.sender is actually a V2 pair

      path[0] = amount0 == 0 ? token1 : token0; // path[0] is token with amount non 0
      path[1] = amount0 == 0 ? token0 : token1; // path[1] is token with amount 0

      IERC20 token = IERC20(_amount0 == 0 ? token1 : token0);
      uint amountToken = _amount0 == 0 ? _amount1 : _amount0;
      token.approve(address(uRouter), amountToken);
      
      uint amountRequired = UniswapV2Library.getAmountsIn(factory, amountToken, path)[0];
      uint amountReceived = otherSwapRouter.swapExactTokensForTokens(amountToken, amountRequired, path, address(this), deadline)[1];
      assert(amountReceived > amountRequired); // fail if we didn't get enough ETH back to repay our flash loan
      
      token.transfer(msg.sender, amountRequired); // return tokens to V2 pair
      token.transfer(_sender, amountReceived-amountRequired); // keep the rest!
  }

}
