// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@thirdweb-dev/contracts/prebuilts/account/utils/BaseAccountFactory.sol";
import "./UsernameBasedAccount.sol";

contract UsernameBasedAccountFactory is BaseAccountFactory {
    event Registered(string username, address account);
    mapping(string => address) public accountOfUsername;

    constructor(
        IEntryPoint _entrypoint
    )
    BaseAccountFactory(
    address (new UsernameBasedAccount(_entrypoint,address(this))),
    address(_entrypoint)
    )
    {}

    function _initializeAccount(
        address _account,
        address _admin,
        bytes calldata
    ) internal override {
        UsernameBasedAccount(payable(_account)).initialize(_admin, "");
    }

    function onRegistered(string calldata username  ) external {
        address account = msg.sender;
        require(this.isRegistered(account),"Not an account");
        require(accountOfUsername[username] == address (0), "Username taken...");
        accountOfUsername[username] = account;
        emit Registered(username,account);

    }

    function getAccountForUsername(string calldata username) public view returns (address) {
        return accountOfUsername[username];
    }

    function isUsernameAvailable(string calldata username) public view returns (bool) {
        return accountOfUsername[username] == address (0);
    }
}
