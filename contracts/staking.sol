
pragma solidity >=0.7.0 <0.9.0;

contract App{
    address public owner;
    bool public paused;
    address public treasuryWallet;

    address[] public stakers;

    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor() public{
        owner = msg.sender;
    }


    function stakeToken(uint _amount) public {
    
        require(_amount > 0, "amount cannot be 0");

        stakingBalance[msg.sender] += _amount;
        
        if(!hasStaked[msg.sender]){
            stakers.push(msg.sender);
        }

        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    function unstakeToken() public{
        
        uint balance = stakingBalance[msg.sender];
        require(balance > 0, "staking Balance cannot be less than 0");

        stakingBalance[msg.sender] = 0;
        
        if(!hasStaked[msg.sender]){
            stakers.push(msg.sender);
        }

        isStaking[msg.sender] = false;

    }

    function issueRewards() public view returns(uint){
        require(msg.sender == owner, "caller must be the owner");
        
        for (uint i = 0; i < stakers.length; i++){
            address recipient = stakers[i];
            uint reward = stakingBalance[recipient]/100;
            if(reward > 0){
                return reward;
            }
        }
        
    }

    function setPaused(bool _paused) public {
        require(msg.sender == owner, "You are not the owner");
        paused = _paused;
    }

    function pauseContract() public view{
        require(msg.sender == owner, "Only owner can pause the contract");
        require(paused == false, "Contract Paused");
        
    }

    // function depositTax() public pure returns(uint){
    //     uint tax = stakingBalance[msg.sender] * 0.05;
    //     return treasuryWallet = stakingBalance[msg.sender] - tax;
    // }

 }
