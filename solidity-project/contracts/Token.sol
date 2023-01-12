// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "./CustomLib.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Token {
    constructor(string memory name,string memory symbol,uint128 price) payable {
        _name = name;
        _symbol = symbol;
        _price = price;
        owner = msg.sender;
    }
    fallback() external payable{}
    receive() external payable{}

    using customLib for uint256;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Sell(address indexed from, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }

    address public owner;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint128 private _price;
    using SafeMath for uint256;
    mapping(address => uint) private _balanceOf;

    function totalSupply() view public returns(uint256){
        return _totalSupply;
    }

    function getName() view public returns(string memory){
        return _name;
    }

    function getSymbol() view public returns(string memory){
        return _symbol;
    }

    function getPrice() view public returns(uint128){
        return _price;
    }

    function balanceOf(address _account) view public returns(uint){
        return _balanceOf[_account];
    }

    function transfer(address to, uint256 value) external returns (bool) {
        require(to != address(0), "Token: transfer to the zero address");
        require(_balanceOf[msg.sender] >= value, "insufficient token to transfer");

        _balanceOf[msg.sender].sub(value);
        _balanceOf[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function mint(address to,uint amount) external returns (bool){
        require(to != address(0), "Token: mint to the zero address");
        _balanceOf[to].add(amount);
        _totalSupply.add(amount);
        emit Mint(to, amount);
        return true;
    }

    function sell(uint256 value) external returns(bool){
        require(value > 0 , "Amount to sell must be greater than 0");
        require(_balanceOf[msg.sender] >= value, "insufficient token to sell");
        uint256 redeemAmount = value * 600;
        require(address(this).balance > redeemAmount, "insufficient balance to redeem token");
        _totalSupply.sub(value);
        _balanceOf[msg.sender].sub(value);
        (bool success) = redeemAmount.customSend(msg.sender);
        if (!success){
            revert();
        }
        emit Sell(msg.sender, value);
        return true;
    }

    function close() public onlyOwner {
        selfdestruct(payable(owner));
    }

}
