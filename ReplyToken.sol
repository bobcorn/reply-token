// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./contracts/IStudentsRegistry.sol";
import "./contracts/ReplyCoin.sol";

contract ReplyToken is ERC721 {
    // Counter used to enumerate tokens IDs
    using Counters for Counters.Counter;
    Counters.Counter private _ids;

    // Registry of all recorded students
    IStudentsRegistry _registry;
    // Accepted currency for the token
    ReplyCoin _coin;

    // Mapping of token IDs to their values
    mapping(uint256 => uint256) _values;

    // Event emitted when the token is created
    event TokenCreated(uint256 id, uint256 value);
    // Event emitted when the token is transferred
    event TokenTransferred(address sender, address recipient);

    // Constructor requiring the student registry and the accepted currency
    constructor(IStudentsRegistry registry, ReplyCoin coin)
        ERC721("MyToken", "MT")
    {
        _registry = registry;
        _coin = coin;
    }

    // Creation of the token
    function createToken(uint256 value) public returns (uint256) {
        // Check if the token creation is requested by a registered student
        require(
            _registry.isStudent(msg.sender),
            "Only registered students can create tokens"
        );

        // Increment the token IDs
        _ids.increment();
        // Get the current token ID
        uint256 _currentId = _ids.current();
        // Safely mint a new token
        _safeMint(msg.sender, _currentId);
        // Update token values
        _values[_currentId] = value;

        // Emit the token creation event
        emit TokenCreated(_currentId, value);

        // Return the newly created token's ID
        return _currentId;
    }

    // Transfer of the token and coin exchange
    function _transfer(
        address sender,
        address recipient,
        uint256 id
    ) internal virtual override {
        // Transfer the required coins amount from the token's recipient to its sender
        _coin.transferFrom(recipient, sender, _values[id]);
        // Transfer the token from its sender to its recipient
        super._transfer(sender, recipient, id);

        // Emit the token transfer event
        emit TokenTransferred(sender, recipient);
    }

    // Utility function to get the value of a token
    function getTokenValueById(uint256 id) public view returns (uint256) {
        // Check if the token is assigned to an owner
        ownerOf(id);

        // If yes, return the token's value
        return _values[id];
    }
}
