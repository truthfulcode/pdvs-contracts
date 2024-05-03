// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {UserType} from "./IERC20CGPA.sol";
import "./ERC20CGPA.sol";
import "./IVotingStrategy.sol";
import "./VotingStrategy.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract VotingToken is ERC20CGPA, AccessControl {
    uint public constant MAX_PER_USER = 400;
    address public admin; // platform admin
    bytes32 public MINT_BURN_ROLE = keccak256("MINT_BURN_ROLE");

    IVotingStrategy public votingStrategy;

    // mapping (address => UserType) public userType;

    constructor(address _admin, address _keeper) ERC20CGPA("Student Voting Power", "SVP", 4) {
        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
        _grantRole(MINT_BURN_ROLE, _keeper);
        _setRoleAdmin(MINT_BURN_ROLE, DEFAULT_ADMIN_ROLE);

        _admin = _admin;
        votingStrategy = new VotingStrategy(ERC20CGPA(address(this)));
    }

    error EXCEEDED_MAX_PER_USER();
    error UNDESIRED_BEHAVIOR();
    error USERTYPE_NONE();
    error EMPTY_BALANCE();

    function balanceOf(address _account) public view override returns (uint256) {
        return votingStrategy.getVotingPower(super.balanceOf(_account));
    }

    function mint(address _user, uint _amount, UserType _userType) public onlyRole(MINT_BURN_ROLE) {
        if(_amount + super.balanceOf(_user) > MAX_PER_USER) revert EXCEEDED_MAX_PER_USER();
        if(_userType == UserType.NONE) revert USERTYPE_NONE();

        _setUserType(_user, _userType);
        _mint(_user,_amount);
    }

    function burn(address user, uint amount) public onlyRole(MINT_BURN_ROLE) {
        if(balanceOf(user) == amount) _setUserType(user, UserType.NONE);
        _burn(user,amount);
    }

    function revoke(address _user) external onlyRole(MINT_BURN_ROLE){
        uint _balance = balanceOf(_user);
        if (_balance == 0) revert EMPTY_BALANCE();
        _setUserType(_user, UserType.NONE);
        _burn(_user, _balance);
    }

    /// @dev updates voting power strategy
    function setStrategy(IVotingStrategy newVotingStrategy) external onlyRole(DEFAULT_ADMIN_ROLE) {
        votingStrategy = newVotingStrategy;
    }

    /// param _admin and ADMIN role should be managed by different addresses
    function setAdmin(address _admin) external onlyRole(DEFAULT_ADMIN_ROLE) {
        admin = _admin;
    }
}
