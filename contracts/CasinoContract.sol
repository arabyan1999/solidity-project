pragma solidity ^0.8.7;

contract Casino {
    address public owner;
    uint256 public chest; // total amount of chips
    uint256 public constant CHEST_FEE_PERCENTAGE = 20;
    uint256 public constant MIN_DEPOSIT_AMOUNT = 10 ether;
    uint256 public constant MAX_DEPOSIT_AMOUNT = 100 ether;

    struct Round { // struct - custom data structure
        uint256 capacity; // maximum amount of chips that can be deposited in the round
        uint256 depositedAmount;
        address winner;
        bool isActive;
    }

    Round public currentRound; // variable called currentRound of type Round

    constructor() {
        owner = msg.sender;
        chest = 0;
        currentRound.isActive = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
        // In this modifier, the underscore (_) is a placeholder for
        // the function body of the function being modified. When the function is executed,
        // the code in the modifier is executed first,
        // followed by the original function body. The underscore tells Solidity where to
        // insert the original function body
    }

    function startNewRound(uint256 capacity) public onlyOwner {
        require(!currentRound.isActive, "Current round is still active");
        require(capacity > 0, "Capacity should be greater than 0");

        currentRound.capacity = capacity;
        currentRound.depositedAmount = 0;
        currentRound.isActive = true;
        currentRound.winner = address(0);
    }

    function deposit() public payable {
        require(currentRound.isActive, "No active round at the moment");
        require(currentRound.depositedAmount < currentRound.capacity, "Round capacity already reached");
        require(msg.value >= MIN_DEPOSIT_AMOUNT && msg.value <= MAX_DEPOSIT_AMOUNT, "Deposit amount should be between min and max");

        currentRound.depositedAmount += msg.value;
        if (currentRound.depositedAmount == currentRound.capacity) {
            currentRound.isActive = false;
            currentRound.winner = msg.sender;
            uint256 winnerAmount = (currentRound.depositedAmount * (100 - CHEST_FEE_PERCENTAGE)) / 100;
            uint256 chestAmount = currentRound.depositedAmount - winnerAmount;
            payable(msg.sender).transfer(winnerAmount);
            chest += chestAmount;
        }
    }

    function withdrawChest() public onlyOwner {
        require(chest > 0, "No chips in the chest");
        uint256 amount = chest;
        chest = 0;
        payable(owner).transfer(amount);
    }
}