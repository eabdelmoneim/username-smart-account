// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@thirdweb-dev/contracts/prebuilts/account/non-upgradeable/Account.sol";
import "./UsernameBasedAccountFactory.sol";

contract UsernameBasedAccount is Account {

    bool public isUsernameSet = false;
    string public username = "";

    constructor(
        IEntryPoint _entrypoint,
        address _factory
    ) Account(_entrypoint, _factory) {
        _disableInitializers();
    }
    
    function register(
        string calldata _username,
        string calldata _metadataUri
        ) external {
        require(msg.sender == address(this), "Only account can register");
        require(isUsernameSet == false, "Username already set on account");
        UsernameBasedAccountFactory(factory).onRegistered(_username);
        _setupContractURI(_metadataUri);
        
        // set username flag
        isUsernameSet = true;
        username = _username;
    }

    function getUsername() public view returns (string memory) {
        return username;
    }
}