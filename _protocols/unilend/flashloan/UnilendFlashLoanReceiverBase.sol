pragma solidity 0.8.0;
// SPDX-License-Identifier: MIT

import "./IERC20.sol";
import "./SafeMath.sol";
import "./SafeERC20.sol";

interface IUnilendFlashLoanCoreBase {
    function flashLoan(address _receiver, address _reserve, uint256 _amount, bytes memory _params) external;
}


contract UnilendFlashLoanReceiverBase {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    
    mapping(uint => address payable) private coreAddress;
    address payable public unilendFlashLoanCore;
    
    constructor() {
        coreAddress[1] = payable(0x13A145D215182924c89F2aBc7D358DCc72F8F788);
        coreAddress[3] = payable(0x13A145D215182924c89F2aBc7D358DCc72F8F788);
    }
    
    receive() payable external {}
    
    function ethAddress() internal pure returns(address) {
        return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    }
    
    function getChainID() internal view returns (uint256) {
        uint256 id;
        assembly {
            id := chainid()
        }
        return id;
    }
    
    function getUnilendCoreAddress() internal view returns(address payable) {
        require(coreAddress[getChainID()] != address(0), "UnilendV1: Chain not supported");
        return coreAddress[getChainID()];
    }
    
    function getBalanceInternal(address _target, address _reserve) internal view returns(uint256) {
        if(_reserve == ethAddress()) {
            return _target.balance;
        }
        return IERC20(_reserve).balanceOf(_target);
    }
    
    function transferInternal(address payable _destination, address _reserve, uint256 _amount) internal {
        if(_reserve == ethAddress()) {
            (bool success, ) = _destination.call{value: _amount}("");
            require(success == true, "Couldn't transfer ETH");
            return;
        }
        IERC20(_reserve).safeTransfer(_destination, _amount);
    }
    
    function flashLoan(address _target, address _asset, uint256 _amount, bytes memory _params) internal {
        IUnilendFlashLoanCoreBase(getUnilendCoreAddress()).flashLoan(_target, _asset, _amount, _params);
    }
    
}