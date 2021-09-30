pragma solidity ^0.8.0;

interface IERC20 {
    // Return amount of tokens in existence
    function totalSupply() external view returns (uint);

    // Returns amount of tokens owned by `account`
    function balanceOf(address account) external view returns (uint);

    /* 
        Returns the remaining number of tokesn that `spender` will be allowed to spend on
        behalf of `owner` through {transferFrom}, 0 by default

        This value changes when {approve} or {transferFrom} are called
    */
    function allowance(address owner, address spender) external view returns (uint);

    /*
        Moves `amount` tokens from caller's account to 'recipient`
        Returns a boolean value indicate if the operation is succeeded
        Emits a {Transfer} event
    */
    function transfer(address recipient, uint amount) external returns (bool);


    /*
        Sets `amount` as the allowance of `spender` over the caller's token
        Return a boolean value indicating whether the operation succeeded

        IMPORTANT: Possible to get attacked: https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit#heading=h.b32yfk54vyg9
            One possible solution: first reduce spender's allowance to 0 & set desired value after wards
                --> https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        
        Emits an {Approval} event
    */
    function approve(address spender, uint amount) external returns (bool);

    /*
     *  Moves `amount` token from `sender` to `recipient` using allowance mechanism
     *  `amount` is then deducted from caller's allowance
     *
     *  Returns a boolean value indicate if the operation succeeded
     *
     *  Emits a {Transfer} event
     */
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);

    /**
        Emitted when `value` tokens are moved account `from` to `to`
        `value` may be 0

        using 'indexed' we can filter in event listener for alert specific customer for example
     */
    event Transfer(address indexed from, address indexed to, uint value);

    /**
        Emitted when the allowance of `spender` for an `owner` is set by a call to {approve}
        `value` is the new allowance
     */
    event Approval(address indexed owner, address indexed spender, uint value);
}