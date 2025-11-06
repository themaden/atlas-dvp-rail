// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


import "forge-std/Script.sol";
import {MockERC20} from "../src/mock/MockERC20.sol";
import {ProofAdapterMock} from "src/l2/ProofAdapterMock.sol";
import {Spoke} from "src/l2/Spoke.sol";
import {SettlementRegistry} from "src/SettlementRegistry.sol";


contract Deploy is Script {
function run() external {
uint256 pk = vm.envUint("PRIVATE_KEY");
vm.startBroadcast(pk);


// L2-A tarafı (örnek)
MockERC20 tokenA = new MockERC20("MockUSD-A", "mUSDA");
ProofAdapterMock adapterA = new ProofAdapterMock();
Spoke spokeA = new Spoke(address(tokenA), address(adapterA));


// L2-B tarafı (örnek)
MockERC20 tokenB = new MockERC20("MockUSD-B", "mUSDB");
ProofAdapterMock adapterB = new ProofAdapterMock();
Spoke spokeB = new Spoke(address(tokenB), address(adapterB));


// L1 registry (kanonik kayıt + receipt)
SettlementRegistry registry = new SettlementRegistry();


vm.stopBroadcast();


// Adresleri logla (komut çıktısından kopyalayacağız)
console2.log("tokenA:", address(tokenA));
console2.log("adapterA:", address(adapterA));
console2.log("spokeA:", address(spokeA));
console2.log("tokenB:", address(tokenB));
console2.log("adapterB:", address(adapterB));
console2.log("spokeB:", address(spokeB));
console2.log("registry:", address(registry));
}
}