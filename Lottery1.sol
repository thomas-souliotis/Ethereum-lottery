pragma solidity ^0.4.0;
contract Lottery1 {
    uint public threshold;
    uint public totalTokens;
    address winner;
    uint public blockNumber;
    uint public playersCount;
    uint public winningToken;
    uint public exchangeRate;
    bytes32 public blockHashNow;
    //event Transfer(address indexed _from, address indexed _to, uint256 _value);
    bytes1 winningHashVal;
    bool flag;
    mapping (uint => address) tokenList;

    function Lottery1 () {
        exchangeRate = 1 ether / 2560; //so as the prize to be around 0.1 ether, it will be a little less though due to the integer division 
        threshold = 256; // number of max tokens to be sold, choose it to be a power of 2
        totalTokens = 0; //initialization of number of tokens
        flag = true;
    }

    function playLottery1 () payable external {
        uint amount = (msg.value)/exchangeRate;
        uint change = (msg.value)%exchangeRate;//ethers if someone does not give a value multiple of exchange rate
        // we fix the problem of extra tokens and the changes
        if (amount > (threshold-totalTokens)) {
            msg.sender.transfer((amount-(threshold-totalTokens))*exchangeRate + change);
            amount = (threshold-totalTokens);
        }else {
            msg.sender.transfer(change);   
        }
        //For each token we store the user that bought it
        for (uint256 i = totalTokens; (i < amount+totalTokens); i++) {
            tokenList[i] = msg.sender;
        } 
        totalTokens += amount;
        //uint gasReturn = msg.gas;       
        if (totalTokens==threshold) {
            blockNumber = block.number;
            blockHashNow = block.blockhash(blockNumber-1);
            winningHashVal = (blockHashNow[31]);//we select the last byte, but any byte is fine
            winningToken = uint(winningHashVal);
            winner = tokenList[winningToken];
            totalTokens = 0;
            winner.transfer(this.balance);
        }    
    }

}
