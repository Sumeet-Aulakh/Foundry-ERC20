//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourtoken;
    DeployOurToken public deployer;
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourtoken = deployer.run();

        vm.prank(msg.sender);
        ourtoken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(ourtoken.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowancesWork() public {
        uint256 initialAllowance = 1000;

        // Bob allows Alice to spend 1000 tokens on his behalf
        vm.prank(bob);
        ourtoken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        ourtoken.transferFrom(bob, alice, transferAmount);

        assertEq(ourtoken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(ourtoken.balanceOf(alice), transferAmount);
    }
}
