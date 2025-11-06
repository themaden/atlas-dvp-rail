// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


import "forge-std/Test.sol";
import {Spoke} from "src/l2/Spoke.sol";
import {MockERC20} from "../src/mock/MockERC20.sol";
import {ProofAdapterMock} from "src/l2/ProofAdapterMock.sol";


contract SpokeProofTest is Test {
Spoke spoke;
MockERC20 token;
ProofAdapterMock adapter;


address user = address(0xBEEF);
address recipient = address(0xCAFE);


function setUp() public {
token = new MockERC20("MockUSD", "mUSD");
adapter = new ProofAdapterMock();
spoke = new Spoke(address(token), address(adapter));


// Kullanıcıya token bas ve onay ver
token.mint(user, 1_000 ether);
vm.prank(user);
token.approve(address(spoke), type(uint256).max);
}


function testLockAndReleaseWithProof() public {
bytes32 txId = keccak256("tx-1");
uint256 amount = 100 ether;


// user -> lock
vm.prank(user);
spoke.lock(txId, amount, bytes("hint"));


// Karşı L2'de kilitleme olmuş gibi mock adapter'a kaydet
adapter.register(txId);


// Geçerli kanıt varsayımıyla release
spoke.release(txId, recipient, amount, bytes("proof"));


// Beklenen bakiyeler
assertEq(token.balanceOf(recipient), amount);
assertEq(token.balanceOf(address(spoke)), 0);
}


function testDoubleUseProofFails() public {
bytes32 txId = keccak256("tx-2");
uint256 amount = 50 ether;


vm.prank(user);
spoke.lock(txId, amount, "");
adapter.register(txId);
spoke.release(txId, recipient, amount, "");


// İkinci kez kullanıma izin verilmemeli (ya "already released" ya da adapter kanıtı tükettiği için revert)
vm.expectRevert();
spoke.release(txId, recipient, amount, "");
}
}