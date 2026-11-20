# Operator registry access review

This portfolio review examines a demonstration contract that records which addresses are approved as operators.

## Scope

The review covers the Solidity registry at commit [`e4df0b78449b`](https://github.com/alexandrhomeufa-dotcom/alexandrhomeufa-dotcom/commit/e4df0b78449b4146207ab9851b269fc982a09815). Scope includes operator approvals and administrator nomination, cancellation, and acceptance. Deployment and contracts that consume the registry are outside the scope. [Reviewed contract](https://github.com/alexandrhomeufa-dotcom/alexandrhomeufa-dotcom/blob/e4df0b78449b4146207ab9851b269fc982a09815/reviews/operator-registry/src/OperatorRegistry.sol)

## Results

- Only the current administrator can grant or revoke operator approvals, nominate a successor, or cancel a pending nomination. [Source](https://github.com/alexandrhomeufa-dotcom/alexandrhomeufa-dotcom/blob/e4df0b78449b4146207ab9851b269fc982a09815/reviews/operator-registry/src/OperatorRegistry.sol#L26-L48)
- Only the active nominee can accept a handoff. A replacement or cancellation invalidates the earlier nomination. Acceptance changes the administrator and clears the pending nomination in one call. [Source](https://github.com/alexandrhomeufa-dotcom/alexandrhomeufa-dotcom/blob/e4df0b78449b4146207ab9851b269fc982a09815/reviews/operator-registry/src/OperatorRegistry.sol#L37-L58)
- Initialization, operator approval, and nomination reject the zero address. [Source](https://github.com/alexandrhomeufa-dotcom/alexandrhomeufa-dotcom/blob/e4df0b78449b4146207ab9851b269fc982a09815/reviews/operator-registry/src/OperatorRegistry.sol#L20-L41)

## Informational finding

### Existing operator approvals carry over after an administrator change

The handoff updates `administrator` and clears `pendingAdministrator`. The `isOperator` mapping keeps its previous values. A team that treats a handoff as an access review could overlook permissions granted by the outgoing administrator. The test suite checks that the new administrator can revoke an approval that carried over. [Acceptance code](https://github.com/alexandrhomeufa-dotcom/alexandrhomeufa-dotcom/blob/e4df0b78449b4146207ab9851b269fc982a09815/reviews/operator-registry/src/OperatorRegistry.sol#L50-L58) · [Test](https://github.com/alexandrhomeufa-dotcom/alexandrhomeufa-dotcom/blob/e4df0b78449b4146207ab9851b269fc982a09815/reviews/operator-registry/test/OperatorRegistry.t.sol#L105-L115)

At each handoff, reconcile approvals with the incoming administrator’s expected list. Use `OperatorApprovalSet` events to identify addresses, confirm current status with `isOperator`, and revoke any approvals that are no longer needed.

## Verification

The review traced the registry’s storage writes to their caller checks. All eight tests passed locally with Foundry 1.7.1 and Solidity 0.8.30. [Tests at the reviewed commit](https://github.com/alexandrhomeufa-dotcom/alexandrhomeufa-dotcom/blob/e4df0b78449b4146207ab9851b269fc982a09815/reviews/operator-registry/test/OperatorRegistry.t.sol)

Run from the repository root.

```sh
forge test --root reviews/operator-registry -vv
```
