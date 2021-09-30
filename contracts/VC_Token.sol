// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0; //  version

import "./IERC20.sol";

contract VC_Token is IERC20 {
    string public name = "VCTest";
    string public symbol = "VCT";
    uint8 public decimals = 18;  

    address private _owner; 

    uint internal _totalSupply; // uint; can only call inside

    mapping(address => uint) private _balance;    
    
    mapping(address => mapping(address => uint)) private _allowance;  

    // require(bool condition): abort execution and revert state changes if condition is false (use for malformed ~weird~ input)
    modifier _onlyOwner_() {    // modifier: for checking condition before execute
        require(msg.sender == _owner, "ERR_NOT_OWNER");
        _; // continue to execute body of other functions using this modifier
    }

    /*
        SafeMath: check to avoid overflow 
        pure function: not read or modify the state of variables -> save gas
    */
    function add(uint a, uint b) internal pure returns (uint c) {
        require((c = a + b) >= a);
    }

    function sub(uint a, uint b) internal pure returns (uint c) {
        require((c = a - b) <= a);
    }

    // increase supply by `amount`
    // address(0) ~ address of black_wallet
    function _mint(address receipient, uint amount) internal {
        require (receipient != address(0), "ERC20 Error: Mint to the zero-address");
        _balance[receipient] = add(_balance[receipient], amount);
        _totalSupply = add(_totalSupply, amount);
        emit Transfer(address(0), receipient, amount);
    }

    /* 
        public - all can access

        external - Cannot be accessed internally, only externally

        internal - only this contract and contracts deriving from it can access

        private - can be accessed only from this contract
    */
    constructor(uint initialSupply) public {
        _owner = msg.sender;
        _mint(msg.sender, initialSupply);
    }

    function _transfer(address sender, address receipient, uint amount) internal {
        require(sender != address(0), "ERC20 Error: transfer from the zero-address");
        require(receipient != address(0), "ERC20 Error: transfer to the zero-address");
        
        require(_balance[sender] >= amount, "Error: Balance is less than amount transfer");
        _balance[sender] = sub(_balance[receipient], amount);
        _balance[receipient] = add(_balance[sender], amount);
        emit Transfer(sender, receipient, amount);
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint) {
        return _balance[account];
    } 

    function allowance(address owner, address spender) external view returns (uint) {
        return _allowance[owner][spender];
    }       

    function transfer(address receipient, uint amount) external returns (bool) {
        _transfer(msg.sender, receipient, amount);
        return true;
    }
    
    function approve(address receipient, uint amount) external returns (bool) {
        require(receipient != address(0), "ERC20 Error: approve to the zero address");
        _allowance[msg.sender][receipient] = amount;
        emit Approval(msg.sender, receipient, amount);
        return true;
    }

    function transferFrom(address sender, address receipient, uint amount) external returns (bool) {
        require(msg.sender == sender || amount <= _allowance[sender][msg.sender], "Error: amount exceed allowance");

        _transfer(sender, receipient, amount);

        if (msg.sender != sender) {
            _allowance[sender][msg.sender] = sub(_allowance[sender][msg.sender], amount);
            emit Approval(sender, msg.sender, _allowance[sender][msg.sender]);
        }
        return true;
    }

    function faucet(address receipient, uint amount) external returns (bool) {
        _mint(receipient, amount);
        return true;
    }
}
