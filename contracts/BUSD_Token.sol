pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BUSD_Token is ERC20 {
    constructor() ERC20("BUSD Test Token", "BUSD") {
    }
}