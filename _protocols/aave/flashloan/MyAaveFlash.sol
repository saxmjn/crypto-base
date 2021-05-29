pragma solidity ^0.6.6;

import "https://raw.githubusercontent.com/aave/protocol-v2/master/contracts/flashloan/base/FlashLoanReceiverBase.sol";
import "https://raw.githubusercontent.com/aave/protocol-v2/master/contracts/interfaces/ILendingPoolAddressesProvider.sol";
import "https://raw.githubusercontent.com/aave/protocol-v2/master/contracts/interfaces/ILendingPool.sol";

//
// REFERENCE FROM
// https://github.com/aave/code-examples-protocol/tree/main/V2/Flash%20Loan%20-%20Batch
//

contract MyAaveFlashLoan is FlashLoanReceiverBase {
    constructor(address _addressProvider) FlashLoanReceiverBase(_addressProvider) public {}
    
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        bytes calldata _params
    )
        external
    {
        //check the contract has the specified balance
        for (uint i = 0; i < assets.length; i++) {
            require(ammounts[i] <= IERC20(assets[i]).balanceOf(address(this)));   
        }
 
        // Your logic goes here.
        
        
        // Approve the LendingPool contract allowance to *pull* the owed amount
        for (uint i = 0; i < assets.length; i++) {
            uint amountOwing = amounts[i].add(premiums[i]);
            IERC20(assets[i]).approve(address(LENDING_POOL), amountOwing);
        }
        
        return true;
    }

    function flashloan(address _asset) public {
        address receiverAddress = address(this);
        address onBehalfOf = address(this);
        bytes memory params = "";
        uint16 referralCode = 0;
        
        address[] memory assets = new address[](1);
        assets[0] = address(0xB597cd8D3217ea6477232F9217fa70837ff667Af); // Kovan AAVE
        
        uint256[] memory amounts = new uint256[](7);
        amounts[0] = 1 ether;
        
        // 0 = no debt, 1 = stable, 2 = variable
        uint256[] memory modes = new uint256[](7);
        modes[0] = 0;
        
        LENDING_POOL.flashLoan(
            receiverAddress,
            assets,
            amounts,
            modes,
            onBehalfOf,
            params,
            referralCode
        );
    }
}