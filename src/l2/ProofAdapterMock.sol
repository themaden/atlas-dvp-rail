// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


import {IProofVerifier} from "./IProofVerifier.sol";


/// @title ProofAdapterMock — MVP: atlas kanıtı yerine elde kayıt
contract ProofAdapterMock is IProofVerifier {
mapping(bytes32 => bool) public valid;


/// @notice Test/demoda karşı L2'de lock gerçekleştiğinde bu txId'yi kaydediyoruz
function register(bytes32 txId) external {
valid[txId] = true;
}


/// @dev Tek kullanımlık tüketim: bir kez doğrulanınca yeniden kullanılamaz
function isValid(bytes32 txId, bytes calldata) external override returns (bool) {
bool ok = valid[txId];
require(ok, "no-proof");
valid[txId] = false;
return true;
}
}