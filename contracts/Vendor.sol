pragma solidity ^0.8.0;

import "./IERC20.sol";

contract Vendor {
    address private _myVCTAddress;
    address private _myBUSDAddress;
    address payable private _myBNBWallet;
    address private _myCommisionAddress; // in VCT

    uint8 private constant BUSD_to_VCT = 30;
    uint16 private constant BNB_to_VCT = 30000;
    uint8 private constant feeRate = 2;

    event Bought_By_BUSD(address buyer, uint amt_BUSD, uint amt_VCT);
    event Bought_By_BNB(address buyer, uint amt_BNB, uint amt_VCT);

    event Sold_By_BUSD(address seller, uint amt_VCT, uint amt_BUSD);
    event Sold_By_BNB(address seller, uint amt_VCT, uint amt_BNB);

    constructor(address myVCTAddress, address myBUSDAddress, address payable myBNBWallet) public {
        _myVCTAddress = myVCTAddress;
        _myBUSDAddress = myBUSDAddress;
        _myBNBWallet = myBNBWallet;
    }

    // BUSD is non-native token --> not use 'payable'
    // user buy VCT by BUSD
    function buyByBUSD(uint BUSD_Amount) external returns (bool) {
        require(BUSD_Amount > 0, "You need to have some BUSD");

        uint VCT_amt_buy = BUSD_Amount * BUSD_to_VCT;
        uint vendorVCTBalance = IERC20(_myVCTAddress).balanceOf(_myVCTAddress);
        
        require(vendorVCTBalance >= VCT_amt_buy, "Not enough VCT in the fund");
        
        // Transfer token to msg.sender
        require(IERC20(_myVCTAddress).transfer(msg.sender, VCT_amt_buy), "Failed to transfer VCT to user");

        // Transfer token to vendor
        require(IERC20(_myBUSDAddress).transferFrom(msg.sender, _myVCTAddress, BUSD_Amount), "Failed to transfer BUSD to vendor");

        emit Bought_By_BUSD(msg.sender, BUSD_Amount, VCT_amt_buy);
        return true;
    }

    // user sell VCT to get BUSD
    function sellToBUSD(uint VCT_amount) external returns (bool) {
        require (VCT_amount > 0, "Selling VCT amount must be > 0");

        uint userBalance = IERC20(_myVCTAddress).balanceOf(msg.sender);
        require (userBalance >= VCT_amount, "User VCT balance < amount you want to sell");

        uint BUSD_amt_transfer = VCT_amount * ((100 - feeRate) / 100) / BUSD_to_VCT;
        uint vendorBUSDBalance = IERC20(_myBUSDAddress).balanceOf(_myBUSDAddress);
        require(vendorBUSDBalance >= BUSD_amt_transfer, "Vendor has not enough BUSD in the funds");

        //Transfer BUSD to msg.sender
        require(IERC20(_myBUSDAddress).transfer(msg.sender, BUSD_amt_transfer), "Failed to transfer BUSD to user");

        //Transfer VCT to vendor
        require(IERC20(_myBUSDAddress).transferFrom(msg.sender, _myBUSDAddress, VCT_amount), "Failed to transfer VCT to vendor");

        uint commisionFee = VCT_amount * feeRate / 100;
        require(IERC20(_myCommisionAddress).transfer(_myCommisionAddress, commisionFee));

        emit Sold_By_BUSD(msg.sender, VCT_amount, BUSD_amt_transfer);
        return true;
    }

    // user buy VCT by BNB
    function buyByBNB() public payable returns (bool) {
        require(msg.value > 0, "You need to have some BNB");

        uint VCT_amt_buy = msg.value * BNB_to_VCT;
        uint vendorVCTBalance = IERC20(_myVCTAddress).balanceOf(_myVCTAddress);

        require (vendorVCTBalance >= VCT_amt_buy, "Not enough VCT in the fund");

        // Transfer VCT to msg.sender
        require(IERC20(_myVCTAddress).transfer(msg.sender, VCT_amt_buy), "Failed to transfer VCT to user");

        // Transfer BNB to vendor
        _myBNBWallet.transfer(msg.value);

        emit Bought_By_BNB(msg.sender, msg.value, VCT_amt_buy);
        return true;
    }

    // user sell VCT to get BNB
    function sellToBNB() public payable returns (bool) {
        require (msg.value > 0, "Selling VCT amount must be > 0");

        uint userBalance = IERC20(_myVCTAddress).balanceOf(msg.sender);
        require (userBalance >= msg.value, "User VCT balance < amount you want to sell");

        uint BNB_amt_transfer = msg.value * ((100 - feeRate) / 100) / BNB_to_VCT;
        uint vendorBNBBalance = _myBNBWallet.balance;
        require(vendorBNBBalance >= vendorBNBBalance, "Vendor has not enough BNB in the funds");

        //Transfer BNB to msg.sender
        require(_myBNBWallet.transfer(msg.sender, BNB_amt_transfer), "Failed to transfer BNB to user");

        //Transfer VCT to vendor
        require(IERC20(_myVCTAddress).transferFrom(msg.sender, _myVCTAddress, msg.value), "Failed to transfer VCT to vendor");

        uint commisionFee = msg.value * feeRate / 100;
        require(IERC20(_myCommisionAddress).transfer(_myCommisionAddress, commisionFee));

        emit Sold_By_BUSD(msg.sender, msg.value, BNB_amt_transfer);
        return true;
    }
}