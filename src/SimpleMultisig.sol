// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleMultiSig {
    address[] public owners;
    uint256 public threshold;
    uint256 public nonce;
    mapping(address => bool) public isOwner;

    event Execution(address indexed to, uint256 value, bytes data);
    event Deposit(address indexed sender, uint256 value);

    constructor(address[] memory _owners, uint256 _threshold) {
        require(_owners.length > 0, "Owners required");
        require(_threshold > 0 && _threshold <= _owners.length, "Invalid threshold");

        for (uint256 i = 0; i < _owners.length; i++) {
            require(_owners[i] != address(0), "Invalid owner");
            require(!isOwner[_owners[i]], "Duplicate owner");
            isOwner[_owners[i]] = true;
            owners.push(_owners[i]);
        }
        threshold = _threshold;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function execTransaction(
        address to,
        uint256 value,
        bytes memory data,
        bytes memory signatures
    ) public returns (bool success) {
        bytes32 txHash = getTransactionHash(to, value, data, nonce);
        
        checkSignatures(txHash, signatures);

        nonce++;

        (success, ) = to.call{value: value}(data);
        require(success, "Transaction execution failed");

        emit Execution(to, value, data);
    }

    function getTransactionHash(
        address to, 
        uint256 value, 
        bytes memory data, 
        uint256 _nonce
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), to, value, data, _nonce));
    }

    function checkSignatures(bytes32 dataHash, bytes memory signatures) internal view {
        require(signatures.length >= threshold * 65, "Not enough signatures");

        address lastOwner = address(0);
        address currentOwner;
        uint8 v;
        bytes32 r;
        bytes32 s;

        bytes32 ethSignedMessageHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)
        );

        for (uint256 i = 0; i < threshold; i++) {
            assembly {
                let signaturePos := add(add(signatures, 0x20), mul(i, 0x41))
                r := mload(signaturePos)
                s := mload(add(signaturePos, 0x20))
                v := byte(0, mload(add(signaturePos, 0x40)))
            }

            currentOwner = ecrecover(ethSignedMessageHash, v, r, s);

            require(isOwner[currentOwner], "Signature not from owner");
            require(currentOwner > lastOwner, "Signatures not sorted or duplicate");
            
            lastOwner = currentOwner;
        }
    }
}