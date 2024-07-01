// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;

import "./IERC20CGPA.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "./IVotingStrategy.sol";

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * The default value of {decimals} is 18. To change this, you should override
 * this function so it returns a different value.
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20CGPA is Context, IERC20CGPA, IERC20Metadata {
    mapping(address => UserData) private _userData;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    IVotingStrategy public _votingStrategy;
    uint private immutable _MAX_PER_USER;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     * @param scale_ to define the scale of grading, e.g. (4, 10, 100)
     */
     
    constructor(string memory name_, string memory symbol_, uint8 scale_) {
        _name = name_;
        _symbol = symbol_;
        _MAX_PER_USER = scale_ * 10 ** decimals(); // we multiply to count for decimal points
    }

    function _setUserType(address _account, UserType _userType) internal virtual {
        _userData[_account].userType = _userType;
    }

    function _validUserType(address _account) private view {
        require(_userData[_account].userType != UserType.NONE, "Invalid User Type");
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the default value returned by this function, unless
     * it's overridden.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 2;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override(IERC20, IERC20CGPA) returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override(IERC20, IERC20CGPA) returns (uint256) {
        return _userData[account].balance;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function cgpa(address account) public view virtual override returns (uint256) {
        return _userData[account].balance;
    }

    function userType(address account) external view returns (UserType) {
        return _userData[account].userType;
    }

    function strategy() public view virtual override returns(address) {
        return address(_votingStrategy);
    }

    function maxPerUser() public view virtual override returns(uint256) {
        return _MAX_PER_USER;
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _userData[account].balance += uint248(amount);
        }
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");


        uint248 accountBalance = _userData[account].balance;
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _userData[account].balance = accountBalance - uint248(amount);
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);
    }

    function _setCGPA(address account, UserData memory userData) internal virtual {
        uint newBalance = userData.balance;
        require(newBalance > 0 && newBalance <= _MAX_PER_USER, "Invalid New Balance!");
        
        uint oldBalance = _userData[account].balance;

        if (oldBalance == 0) {
            _setUserType(account, userData.userType);
        }

        if( newBalance >= oldBalance ) {
            _mint(account, newBalance - oldBalance);
        } else {
            _burn(account, oldBalance - newBalance);
        }
    }

    function _setStrategy(address newVotingStrategy) internal virtual {
        _votingStrategy = IVotingStrategy(newVotingStrategy);
    }

    // disabled functionalities:

    function transfer(address to, uint256 amount) external pure returns (bool) {
        require(false, "disabled");
    }

    function allowance(address owner, address spender) external pure returns (uint256) {
        return 0;
    }

    function approve(address spender, uint256 amount) external pure returns (bool) {
        require(false, "disabled");
    }
    
    function transferFrom(address from, address to, uint256 amount) external pure returns (bool) {
        require(false, "disabled");
    }
}
