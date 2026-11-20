# Alexandr Ilin

Smart-contract security researcher and bug-bounty hunter focused on EVM protocols and wallet infrastructure.

I investigate protocol logic, authorization, signature validation, accounting, and cross-contract interactions. My work emphasizes minimal reproducible Foundry PoCs, clear impact analysis, and actionable remediation guidance.

## Smart contract reviews

Available for scoped Solidity and EVM security reviews of authorization, wallet integrations, and DeFi accounting. I provide a written report and can review the fixes.

For a quote, [open a public GitHub inquiry](https://github.com/alexandrhomeufa-dotcom/alexandrhomeufa-dotcom/issues/new?title=Solidity%20audit%20inquiry) with any public project links, what you want reviewed, and your target date. I accept payment in cryptocurrency, including USDC.

## Portfolio

- [Operator registry access review](reviews/operator-registry/README.md) is a demonstration review of operator permissions and two-step administrator transfer. It includes the reviewed commit, a finding, and a reproducible Foundry test suite.

## Focus areas

- Smart accounts and wallet security: ERC-4337, ERC-7579, ERC-1271, Permit2, and EIP-712 signature flows
- DeFi accounting: stale caches, reward distribution, lending indexes, and vault balances
- Governance, staking, upgradeability, and access-control logic
- Solidity security testing and Foundry-based proof-of-concept development
- API and integration security around Web3 applications

## How I work

1. Reproduce the behavior with a minimal test case.
2. Reduce the issue to its security-relevant root cause.
3. Validate exploitability and realistic impact.
4. Share a clear report with concrete remediation steps.

## Responsible disclosure

Vulnerabilities are reported privately through the relevant bug-bounty program or directly to the protocol team. Public write-ups and credited advisories are added only after disclosure permits publication.

## Articles

- [What to check before deploying with Solidity 0.8.39](https://github.com/alexandrhomeufa-dotcom/alexandrhomeufa-dotcom/blob/main/articles/solidity-0.8.39-storage-integrity.md)
