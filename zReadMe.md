1. Tìm hiểu và tạo 1 ERC20 token
Yêu cầu:
- Name: VCTest, Symbol: VCT, Decimals: 18
- Deploy trên Binance Smart Chain testnet
- Verify contract ( hiểu về optimize build)
- Có hàm faucet (khi call vào hàm nay thì mint token và gửi về ví call)
2. Tạo contract Mua/Bán token VCT
Yêu cầu:
- Deploy token BUSD test, BUSD, 18 (gọi tắt là token BUSD)
- Có function mua bằng BUSD (buyByBUSD)
Tỷ giá: 1 BUSD = 30 VCT
- Có function mua bằng BNB testnet (buyByBNB)
1 BNB = 30000 VCT
Khi có người gọi hàm mua, thu token tương ứng và trả về token cho người mua
- có function bán VCT để nhận về BUSD (sellToBUSD)
Tỷ giá 1 BUSD = 30 VCT (fee 2% có thể config, chuyển fee về 1 ví khác)
- Có function bán VCT để nhận về BNB (sellToBNB) 
Tỷ giá 1 BNB = 30000 VCT (fee 2% có thể config, chuyển fee về 1 ví khác)