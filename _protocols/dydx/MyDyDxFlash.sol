contract MyDyDxFlash is DyDxFlashLoan {
    uint256 public loan;

    constructor() public payable {
        (bool success, ) = WETH.call.value(msg.value)("");
        require(success, "fail to get weth");
    }

    function getFlashloan(address flashToken, uint256 flashAmount) external {
        uint256 balanceBefore = IERC20(flashToken).balanceOf(address(this));
        bytes memory data = abi.encode(flashToken, flashAmount, balanceBefore);
        flashloan(flashToken, flashAmount, data); // execution goes to `callFunction`
    }

    function callFunction(
        address, /* sender */
        Info calldata, /* accountInfo */
        bytes calldata data
    ) external onlyPool {
        (address flashToken, uint256 flashAmount, uint256 balanceBefore) = abi
            .decode(data, (address, uint256, uint256));
        uint256 balanceAfter = IERC20(flashToken).balanceOf(address(this));
        require(
            balanceAfter - balanceBefore == flashAmount,
            "contract did not get the loan"
        );
        loan = balanceAfter;

        /*******
        * Pseudo-code
        * Use the money here!
        *******/

        // function arb() internal {
        //     uint amount = 10000000000000000000; // 100 tokens
        //     ERC20(token).approve(exchange1, amount); // Approve tokens
        //     uint ethAmount = Exchange1(exchange1).sellTokens(token, amount); // Sell Tokens for Ether
        //     Exchange2(exchange1).buyTokens.value(ethAmount)(token); // Buys tokens back
        // }
            
        // }



    }
}