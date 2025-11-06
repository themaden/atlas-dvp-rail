// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Receipt1155} from "./Receipt1155.sol";

/// @title L1 Settlement Registry (kanonik kayıt + receipt basımı)
contract SettlementRegistry {
    enum Status {
        None,
        Settled,
        Reverted
    }

    struct Settlement {
        bytes32 dvpHash; // L2A & L2B kilitleme olaylarının kanonik hash'i
        address partyA; // RWA satan
        address partyB; // USDC ödeyen
        uint256 time;
        Status status;
    }

    event SettlementRecorded(
        bytes32 indexed dvpHash, address indexed partyA, address indexed partyB, uint256 time, Status status
    );

    Receipt1155 public receipt;
    address public owner;
    uint256 public nextReceiptId;

    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        require(msg.sender == owner, "not owner");
    }

    constructor() {
        owner = msg.sender;
        receipt = new Receipt1155(address(this));
    }

    mapping(bytes32 => Settlement) public settlements;

    /// @notice Atlas kanıtları doğrulandıktan sonra çağrılacak kayıt fonksiyonu (MVP: owner-only)
    function recordSettlement(bytes32 dvpHash, address partyA, address partyB) external onlyOwner returns (uint256 id) {
        require(settlements[dvpHash].status == Status.None, "exists");

        settlements[dvpHash] = Settlement({
            dvpHash: dvpHash, partyA: partyA, partyB: partyB, time: block.timestamp, status: Status.Settled
        });

        emit SettlementRecorded(dvpHash, partyA, partyB, block.timestamp, Status.Settled);

        // Taraflara aynı id'den 1'er adet makbuz bas
        id = ++nextReceiptId;
        receipt.mintReceipt(partyA, id);
        receipt.mintReceipt(partyB, id);
    }
}
