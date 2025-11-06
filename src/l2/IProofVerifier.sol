// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IProofVerifier {
    /// @notice Karşı L2'deki lock olayına ait kanıtı doğrular ve tek kullanımlık tüketir.
    function isValid(bytes32 txId, bytes calldata proof) external returns (bool);
}
