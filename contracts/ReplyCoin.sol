// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IStudentsRegistry.sol";

contract ReplyCoin is ERC20 {
    IStudentsRegistry registry;

    event TokenGranted(address indexed student, uint256 value);

    constructor(address registryAddress) ERC20("ReplyCoin", "RPL") {
        registry = IStudentsRegistry(registryAddress);
    }

    function getTokens(uint256 amount) public {
        require(
            registry.isStudent(msg.sender),
            "Only students can receive tokens"
        );
        _mint(msg.sender, amount);
        emit TokenGranted(msg.sender, amount);
    }
}
