// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IProofVerifier} from "./IProofVerifier.sol";

interface IERC20 {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function transfer(address to, uint256 amount) external returns (bool);
}

/// @title L2 Spoke — Kanıt tabanlı release (MVP: Mock adapter)
contract Spoke {
    IProofVerifier public verifier; // atlas kanıtı için arayüz (şimdilik mock)
    address public asset; // ERC20 (ör. USDC-mock)

    mapping(bytes32 => bool) public locked; // txId -> kilitlendi mi
    mapping(bytes32 => bool) public released; // txId -> serbest bırakıldı mı

    event Locked(
        bytes32 indexed txId,
        address indexed from,
        address indexed asset,
        uint256 amount,
        bytes proofHint
    );
    event Released(
        bytes32 indexed txId,
        address indexed to,
        address indexed asset,
        uint256 amount
    );

    constructor(address _asset, address _verifier) {
        asset = _asset;
        verifier = IProofVerifier(_verifier);
    }

    /// @notice Kullanıcı yerel L2'de varlığını kilitler (MVP: kontratta tutulur)
    function lock(
        bytes32 txId,
        uint256 amount,
        bytes calldata proofHint
    ) external {
        require(!locked[txId], "already locked");
        require(amount > 0, "amount=0");
        locked[txId] = true;
        require(
            IERC20(asset).transferFrom(msg.sender, address(this), amount),
            "transferFrom fail"
        );
        emit Locked(txId, msg.sender, asset, amount, proofHint);
    }

    /// @notice Karşı L2 kanıtı geçerliyse serbest bırak
    function release(
        bytes32 txId,
        address to,
        uint256 amount,
        bytes calldata proof
    ) external {
        require(locked[txId], "not locked");
        require(!released[txId], "already released");
        require(verifier.isValid(txId, proof), "invalid proof");
        released[txId] = true;
        require(IERC20(asset).transfer(to, amount), "transfer fail");
        emit Released(txId, to, asset, amount);
    }

    // Duplicate release function removed to resolve compilation error.
}
