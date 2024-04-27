// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./ERC20CGPA.sol";
import "./IVotingStrategy.sol";
import "./VotingStrategy.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract VotingToken is ERC20CGPA, AccessControl {
    enum UserType {
        NONE, STUDENT, CM
    }

    uint public constant MAX_PER_USER = 400;
    address public admin; // platform admin
    bytes32 public MINT_BURN_ROLE = keccak256("MINT_BURN_ROLE");

    IVotingStrategy public votingStrategy;

    mapping (address => UserType) public userType;

    constructor(address _admin) ERC20("Student Voting Power", "SVP", 4) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINT_BURN_ROLE, msg.sender);

        _admin = msg.sender;
        votingStrategy = new VotingStrategy();
    }

    error EXCEEDED_MAX_PER_USER();
    error UNDESIRED_BEHAVIOR();
    error USERTYPE_NONE();
    error EMPTY_BALANCE();

    function decimals() public pure override(ERC20) returns(uint8) {
        return 2;
    }

    function balanceOf(address account) public view override(ERC20) returns (uint256) {
        return votingStrategy.getVotingPower(account);
    }

    function cgpa(address account) public view returns (uint256) {
        return super.balanceOf(account);
    }

    function mint(address _user, uint _amount, UserType _userType) public onlyRole(MINT_BURN_ROLE) {
        if(_amount + super.balanceOf(_user) > MAX_PER_USER) revert EXCEEDED_MAX_PER_USER();
        if(_userType == UserType.NONE) revert USERTYPE_NONE();
        userType[_user] = _userType;
        _mint(_user,_amount);
    }

    function burn(address user, uint amount) public onlyRole(MINT_BURN_ROLE) {
        if(balanceOf(user) == amount) delete userType[user];
        _burn(user,amount);
    }

    function revoke(address _user) external onlyRole(MINT_BURN_ROLE){
        uint _balance = balanceOf(_user);
        if (_balance == 0) revert EMPTY_BALANCE();
        delete userType[_user];
        _burn(_user, _balance);
    }

    /// @dev updates voting power strategy
    function setStrategy(IVotingStrategy newVotingStrategy) external onlyRole(DEFAULT_ADMIN_ROLE) {
        votingStrategy = newVotingStrategy;
    }

    /// @note param _admin and ADMIN role should be managed by different addresses
    function setAdmin(address _admin) external onlyRole(DEFAULT_ADMIN_ROLE) {
        admin = _admin;
    }
}
