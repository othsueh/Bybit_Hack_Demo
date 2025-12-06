// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract MockTornado {
    IERC20 public token;
    uint256 public denomination;

    mapping(bytes32 => bool) public commitments;

    event Deposit(bytes32 indexed commitment, uint256 timestamp);

    constructor(address _token, uint256 _denomination) {
        token = IERC20(_token);
        denomination = _denomination;
    }

    function deposit(bytes32 _commitment) external {
        require(token.transferFrom(msg.sender, address(this), denomination), "Transfer failed");

        require(!commitments[_commitment], "Commitment already exists");
        commitments[_commitment] = true;

        emit Deposit(_commitment, block.timestamp);
    }
}