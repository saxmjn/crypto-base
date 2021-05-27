pragma solidity ^0.8.3;

contract Token {
    address public minter;
    mapping (address => uint) public balances;

    event Sent (address from, address to, uint amount);

    constructor () {
        // This is called only once in life when contract is being created
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public {
        require (minter == msg.sender);
        require (amount < 1e60);
        balances[receiver] += amount;
    }
    
}