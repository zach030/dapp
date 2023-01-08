// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Token {
    constructor(string memory _name,uint128 _price) payable {
        name = _name;
        price = _price;
        owner = msg.sender;
    }
    fallback() external payable{}
    receive() external payable{}
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Sell(address indexed from, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }

    address public owner;
    uint256 public totalSupply;
    string public name;
    uint128 public price;
    mapping(address => uint) public balanceOf;

    function transfer(address to, uint256 value) external returns (bool) {
        require(to != address(0), "Token: transfer to the zero address");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function mint(address to,uint amount) external returns (bool){
        require(to != address(0), "Token: mint to the zero address");
        balanceOf[to] += amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
        return true;
    }

    function sell(uint256 value) external returns(bool){
        require(value > 0 , "Amount to sell must be greater than 0");
        require(balanceOf[msg.sender] >= value, "insufficient token to sell");
        uint256 redeemAmount = value * 600;
        require(address(this).balance > redeemAmount, "insufficient balance to redeem token");
        totalSupply -= value;
        balanceOf[msg.sender] -= value;
        payable(msg.sender).transfer(value * 600 wei);
        emit Sell(msg.sender, value);
        return true;
    }

    function close() public onlyOwner {
        selfdestruct(payable(owner));
    }

}
