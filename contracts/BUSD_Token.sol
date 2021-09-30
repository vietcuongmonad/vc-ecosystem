pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BUSD_Token is ERC20 {
    constructor(uint initialSupply) ERC20("BUSD Test Token", "BUSD") {
        _mint(msg.sender, initialSupply);
    }
}