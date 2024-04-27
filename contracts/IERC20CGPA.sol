// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface extending from the ERC20 standard which serves the use case of university voting system.
 */
 
interface IERC20CGPA {
    

    struct UserData {
        // tightly packed within 32 bytes slot
        uint248 balance;
        uint8 userType; // used instead of enum for flexibility
    }

  /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when a new strategy has been set
     */
    event NewStrategy(address indexed strategy);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Returns the cgpa value held by `account` derived from strategy.
     */
    function cgpa(address account) external view returns (uint256);

    function userType(address account) external view returns (uint8);
    /**
     * @dev Returns the strategy address.
     */
    function strategy() external view returns (address);

    function maxPerUser() external view returns(uint256);

}
