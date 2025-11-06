// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title Minimal 1155-benzeri makbuz (receipt) kontratı (MVP için)
/// Not: Tam ERC-1155 değildir; demo amaçlı minimal fonksiyonlar içerir.
contract Receipt1155 {
    string public name = "SettlementReceipt";
    string public symbol = "SETL";

    // id => owner => balance
    mapping(uint256 => mapping(address => uint256)) public balanceOf;
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    address public registry; // mint yetkisi

    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 value
    );

    event ApprovalForAll(
        address indexed account,
        address indexed operator,
        bool approved
    );

    modifier onlyRegistry() {
        _onlyRegistry();
        _;
    }

    function _onlyRegistry() internal view {
        require(msg.sender == registry, "Only registry");
    }

    constructor(address _registry) {
        registry = _registry;
    }

    function setApprovalForAll(address operator, bool approved) external {
        isApprovedForAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function _mint(address to, uint256 id, uint256 value) internal {
        balanceOf[id][to] += value;
        emit TransferSingle(msg.sender, address(0), to, id, value);
    }

    /// @notice Registry, her settlement için taraflara 1’er adet makbuz basar
    function mintReceipt(address to, uint256 id) external onlyRegistry {
        _mint(to, id, 1);
    }
}
