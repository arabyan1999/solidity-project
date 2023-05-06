pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; // library, which provides a standard implementation of the ERC20 token interface
import "@openzeppelin/contracts/access/Ownable.sol";

contract Chip is ERC20, Ownable {
    uint256 public rate;
    uint256 public fee;
    address public treasury;
    address public casino;
    // the events are emit for monitoring in front end
    event newRate(uint256 rate);
    event newFee(uint256 fee);
    event newTreasury(address treasury);
    event newCasino(address casino);
    event withdraw(uint256 amount);
    constructor(uint256 _initialSupply, uint256 _initialRate) ERC20("Chip token", "Chip") {
        rate = _initialRate;
        // Contract deployer
        _mint(msg.sender, _initialSupply);
    }

    // external - call only out of contract
    // allows external addresses to buy tokens by sending ether to the contract
    function mint(address _address) payable external {
        // contition
        require(msg.value != 0, "Message value is 0"); // if false code reverted
        _mint(_address, msg.value / rate); // Ether rate by chip
    }

    // onlyOwner - can call only owner
    function setRate(uint256 _newRate) external onlyOwner {
        require(_newRate != 0, "newRate can't be 0");
        rate = _newRate;
        emit newRate(_newRate);
    }

    // allow token holders to transfer tokens to other addresses
    function transfer(address _to, uint256 _amount) public override returns(bool) {
        _transfer(msg.sender, treasury, fee); // send fee to treasury
        _transfer(msg.sender, _to, _amount); // send amount
        return true; // check if function is ok
    }

    function transferFrom(address _from, address _to, uint256 _amount) public override returns(bool) {
        if (msg.sender != casino) {
            _spendAllowance(_from, msg.sender, _amount + fee); // approve to spend
        }
        _transfer(_from, treasury, fee); // send fee to treasury
        _transfer(_from, _to, _amount); // send amount
        return true;
    }

    function setFee(uint256 _newFee) external onlyOwner {
        require(_newFee != 0, "newFee can't be 0");
        fee = _newFee;
        emit newFee(_newFee);
    }

    function setTreasury(address _newTreasury) external onlyOwner {
        require(_newTreasury != address(0), "_newTreasury can't be empty");
        treasury = _newTreasury;
        emit newTreasury(_newTreasury);
    }

    function setCasino(address _newCasino) external onlyOwner {
        require(_newCasino != address(0), "_newCasino can't be");
        casino = _newCasino;
        emit newCasino(_newCasino);
    }

    function withdrawChip() external onlyOwner {
        // burn all amount in treasury and spend ether to owner
        uint256 chipToBurn = balanceOf(treasury);
        _burn(treasury, chipToBurn);
        payable(owner()).transfer(chipToBurn * rate);
        emit withdraw(chipToBurn * rate);
    }
}