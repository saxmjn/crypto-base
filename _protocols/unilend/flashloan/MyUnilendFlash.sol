pragma solidity 0.8.0;
// SPDX-License-Identifier: MIT

import "https://raw.githubusercontent.com/UniLend/flashloan_interface/main/contracts/UnilendFlashLoanReceiverBase.sol";


contract MyUnilendFlashLoan is UnilendFlashLoanReceiverBase {
    using SafeMath for uint256;
    
    constructor() {}
    
    /**
        This function is called after your contract has received the flash loaned amount
     */
     event Borrowed(
        address indexed _from,
        bytes32 indexed _id,
        uint _value
    );

    function executeOperation(
        address _asset,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    )
        external{
            emit Deposit(msg.sender, _id, msg.value);
            // Check if the _amount is less than balance of _asset in user account
            require(_amount <= getBalanceInternal(address(this), _asset),
            "Invalid balance, was the flashLoan successful?");
            _params;
        
            //
            // Your logic goes here.
            //

            // !! Ensure that *this contract* has enough of `_reserve` funds to payback the `_fee` !!
            // Approve your account to payback the _amount & _fee back to the _reserve
            uint totalDebt = _amount.add(_fee);
            transferInternal(getUnilendCoreAddress(), _asset, totalDebt);
        }

    function flashloanCall(address _asset, uint _amount) payable external {
        bytes memory data;
        
        flashLoan(address(this), _asset, _amount, data);
    }
    
}