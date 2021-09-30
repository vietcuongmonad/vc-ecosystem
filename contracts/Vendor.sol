pragma solidity ^0.8.0;

import "./VC_Token.sol";
import "./BUSD_Token.sol";

contract Vendor {
    VC_Token private myVCT;
    BUSD_Token private myBUSD;

    uint8 private constant BUSD_to_VCT = 30;
    uint16 private constant BNB_to_VCT = 30000;

    event Bought_By_BUSD(address buyer, uint256 amt_BUSD, uint256 amt_VCT);
    event Sold_By_BUSD(address seller, uint256 amt_VCT, uint256 amt_BUSD);

    constructor() public {
        myVCT = new VC_Token(1000);
        myBUSD = new BUSD_Token(500);
    }

    function buyByBUSD(uint amount) external returns (bool) {
        uint vendorBalance = myVCT.balanceOf(address(this));

        uint amountToBuy = amount * BUSD_to_VCT;

        require(amount > 0, "You need to have some BUSD");
        require(vendorBalance >= amountToBuy, "Not enough tokens in the fund");
        
        // Transfer token to msg.sender
        require(myVCT.transfer(msg.sender, amountToBuy), "Failed to transfer token to user");

        // Transfer token to vendor
        require(myBUSD.transferFrom(msg.sender, address(this), amount));

        emit Bought_By_BUSD(msg.sender, amount, amountToBuy);
        return true;
    }
}