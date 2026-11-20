// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.30;

/// @notice Records operator approvals for an application.
contract OperatorRegistry {
    error NotAdministrator();
    error NotPendingAdministrator();
    error NoPendingNomination();
    error ZeroAddress();

    event AdministratorNominated(address indexed administrator, address indexed candidate);
    event AdministratorNominationCancelled(address indexed candidate);
    event AdministratorTransferred(address indexed previousAdministrator, address indexed newAdministrator);
    event OperatorApprovalSet(address indexed operator, bool approved);

    address public administrator;
    address public pendingAdministrator;
    mapping(address => bool) public isOperator;

    constructor(address initialAdministrator) {
        if (initialAdministrator == address(0)) revert ZeroAddress();
        administrator = initialAdministrator;
        emit AdministratorTransferred(address(0), initialAdministrator);
    }

    modifier onlyAdministrator() {
        if (msg.sender != administrator) revert NotAdministrator();
        _;
    }

    function setOperator(address operator, bool approved) external onlyAdministrator {
        if (operator == address(0)) revert ZeroAddress();
        isOperator[operator] = approved;
        emit OperatorApprovalSet(operator, approved);
    }

    function nominateAdministrator(address candidate) external onlyAdministrator {
        if (candidate == address(0)) revert ZeroAddress();
        pendingAdministrator = candidate;
        emit AdministratorNominated(administrator, candidate);
    }

    function cancelNomination() external onlyAdministrator {
        address candidate = pendingAdministrator;
        if (candidate == address(0)) revert NoPendingNomination();
        delete pendingAdministrator;
        emit AdministratorNominationCancelled(candidate);
    }

    /// @notice Accepts the current nomination. Existing operator approvals carry over.
    function acceptAdministration() external {
        address candidate = pendingAdministrator;
        if (candidate == address(0) || msg.sender != candidate) revert NotPendingAdministrator();

        address previousAdministrator = administrator;
        administrator = candidate;
        delete pendingAdministrator;
        emit AdministratorTransferred(previousAdministrator, candidate);
    }
}

