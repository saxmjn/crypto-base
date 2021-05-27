contract DiscoToken is ERC20 {
    string constant public name = "Disco";
    string constant public symbol = "DISC";
    uint8 constant public decimals = 18;

    bool public mintStopped = false;

    constructor() public {
    }

    function mint(address account, uint256 amount) public onlyOwner returns (bool) {
        require(!mintStopped, "mint is stopped");
        _mint(account, amount);
        return true;
    }

    function stopMint() public onlyOwner {
        mintStopped = true;
    }
}