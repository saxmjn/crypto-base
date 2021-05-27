const Web3 = require('web3');
const web3 = new Web3('https://eth-ropsten.alchemyapi.io/v2/x6JgbVD8L7CkPWWdWzx_NkDS_bHo3GeW');

// Your Ethereum wallet private key
const myPrivateKey = 'f59ebcf24beb17862938d6a50024ea8cb33c2f4fa2fc8e61251e305f411cbab3';
// Add your Ethereum wallet to the Web3 object
web3.eth.accounts.wallet.add('0x' + myPrivateKey);
const myWalletAddress = web3.eth.accounts.wallet[0].address;

const getContract = (abiJson, contractAddress) => {
    return new web3.eth.Contract(abiJson, contractAddress);
}

module.exports = {
    myWalletAddress,
    getContract
}