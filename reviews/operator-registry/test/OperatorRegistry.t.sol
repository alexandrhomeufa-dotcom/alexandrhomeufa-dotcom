// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.30;

import {OperatorRegistry} from "../src/OperatorRegistry.sol";

interface Vm {
    function prank(address sender) external;
    function expectRevert(bytes4 selector) external;
}

contract OperatorRegistryTest {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address private constant NOMINEE = address(0xA11CE);
    address private constant REPLACEMENT = address(0xB0B);
    address private constant OPERATOR = address(0xCA11);

    OperatorRegistry private registry;

    function setUp() public {
        registry = new OperatorRegistry(address(this));
    }

    function testOnlyAdministratorCanChangeOperatorApproval() public {
        vm.expectRevert(OperatorRegistry.NotAdministrator.selector);
        vm.prank(OPERATOR);
        registry.setOperator(OPERATOR, true);

        assert(!registry.isOperator(OPERATOR));
        registry.setOperator(OPERATOR, true);
        assert(registry.isOperator(OPERATOR));
        registry.setOperator(OPERATOR, false);
        assert(!registry.isOperator(OPERATOR));
    }

    function testOnlyAdministratorCanNominateOrCancel() public {
        vm.expectRevert(OperatorRegistry.NotAdministrator.selector);
        vm.prank(OPERATOR);
        registry.nominateAdministrator(NOMINEE);

        registry.nominateAdministrator(NOMINEE);
        vm.expectRevert(OperatorRegistry.NotAdministrator.selector);
        vm.prank(NOMINEE);
        registry.cancelNomination();
        assert(registry.pendingAdministrator() == NOMINEE);
    }

    function testOnlyCurrentNomineeCanAcceptAndReceivesAuthority() public {
        registry.nominateAdministrator(NOMINEE);
        vm.expectRevert(OperatorRegistry.NotPendingAdministrator.selector);
        vm.prank(OPERATOR);
        registry.acceptAdministration();
        assert(registry.administrator() == address(this));

        vm.prank(NOMINEE);
        registry.acceptAdministration();
        assert(registry.administrator() == NOMINEE);
        assert(registry.pendingAdministrator() == address(0));

        vm.expectRevert(OperatorRegistry.NotAdministrator.selector);
        registry.setOperator(OPERATOR, true);
        vm.prank(NOMINEE);
        registry.setOperator(OPERATOR, true);
        assert(registry.isOperator(OPERATOR));
    }

    function testReplacementSupersedesTheOriginalNomination() public {
        registry.nominateAdministrator(NOMINEE);
        registry.nominateAdministrator(REPLACEMENT);
        vm.expectRevert(OperatorRegistry.NotPendingAdministrator.selector);
        vm.prank(NOMINEE);
        registry.acceptAdministration();

        vm.prank(REPLACEMENT);
        registry.acceptAdministration();
        assert(registry.administrator() == REPLACEMENT);
    }

    function testCancellationPreservesCurrentAdministrator() public {
        registry.nominateAdministrator(NOMINEE);
        registry.cancelNomination();
        assert(registry.pendingAdministrator() == address(0));

        vm.expectRevert(OperatorRegistry.NotPendingAdministrator.selector);
        vm.prank(NOMINEE);
        registry.acceptAdministration();
        assert(registry.administrator() == address(this));
    }

    function testAcceptAndCancelRequireANomination() public {
        vm.expectRevert(OperatorRegistry.NotPendingAdministrator.selector);
        registry.acceptAdministration();
        vm.expectRevert(OperatorRegistry.NoPendingNomination.selector);
        registry.cancelNomination();
    }

    function testRejectsZeroAddresses() public {
        vm.expectRevert(OperatorRegistry.ZeroAddress.selector);
        new OperatorRegistry(address(0));
        vm.expectRevert(OperatorRegistry.ZeroAddress.selector);
        registry.nominateAdministrator(address(0));
        vm.expectRevert(OperatorRegistry.ZeroAddress.selector);
        registry.setOperator(address(0), true);
    }

    function testApprovalsPersistAcrossAdministratorHandoff() public {
        registry.setOperator(OPERATOR, true);
        registry.nominateAdministrator(NOMINEE);
        vm.prank(NOMINEE);
        registry.acceptAdministration();
        assert(registry.isOperator(OPERATOR));

        vm.prank(NOMINEE);
        registry.setOperator(OPERATOR, false);
        assert(!registry.isOperator(OPERATOR));
    }
}

