// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract App{
    address public owner;
    bool public paused;
    bool public blockUser;
    uint public treasuryWallet;

    struct Stakers{
        uint amount;
        uint since;
    }

   Stakers userFunds;

    mapping(address => Stakers[]) public funds;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor() public{
        owner = msg.sender;

    }


    // Deposit Tokens
    function stakeToken() payable public {
    
        require(msg.value > 0, "amount cannot be 0");
        require(blockUser == false, "User Blocked!");
        userFunds.amount = msg.value;
        userFunds.since = block.timestamp;

        funds[msg.sender].push(userFunds);

        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    // Withdraw Tokens
    function unstakeToken() public{
        
        require(userFunds.amount > 0, "funds cannot be less than 0");
        userFunds.amount = 0;
        
        isStaking[msg.sender] = false;

    }


    // Reward function
    uint public reward;

    function issueRewards() payable public{
        require(msg.sender == owner, "caller must be the owner");
        
        
        for (uint i = 0; i < funds[msg.sender].length; i++){
            // address recipient = st.stakers[i];
            uint currentUserFund = funds[msg.sender][i].amount;
            reward += (((block.timestamp - funds[msg.sender][i].since) / 86400) * currentUserFund/100);    
        }
        payable(msg.sender).transfer(reward);

        
    }

    
    // Pause function
    function setPaused(bool _paused) public {
        require(msg.sender == owner, "You are not the owner");
        paused = _paused;
    }

    function pauseContract() public view{
        require(msg.sender == owner, "Only owner can pause the contract");
        require(paused == false, "Contract Paused");
        
    }

    // Code for treasury wallet
    function depositTax() public{
        uint tax = userFunds.amount * 5 / 100;
        treasuryWallet = userFunds.amount + tax;
    }

    function withdrawTax() public{
        uint tax = userFunds.amount * 5 / 100;
        treasuryWallet = userFunds.amount - tax;
    }

    // Block / unblock user
    function setBlockUser(bool _blockUser) public {
        require(msg.sender == owner, "Only owner can block the user");
        blockUser = _blockUser;
    }

 }
