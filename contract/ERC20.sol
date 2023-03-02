pragma solidity ^0.8.17;

import "./IERC20.sol";

/*
* we use the IERC20 that we created to have the interface of ERC20
* wallets like metamask and all other wallets that supports ERC20 tokens
* can support our coin if we have functions and variables of this standard
* that is defined in our 
*/
contract ERC20 is IERC20 {
    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "Example of ERC20";//our name
    string public symbol = "ERCEX";//our symbol
    /*
    * we don't have floating points in solidity so we use uint256 which is a very big 
    * number and the operatioons of subtraction adding and all others like integers
    * and then when we want to represent the number, we put decimal and the decimals
    * variable is to show how many of the first numbers should be part of the decimal
    */
    uint8 public decimals = 18;

    constructor(uint256 total) public {
      totalSupply = total;
      balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address recipient, uint amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(// this is used by other contracts that have permission and are approved to transfer user's coin
        address sender,
        address recipient,
        uint amount
    ) external returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}
