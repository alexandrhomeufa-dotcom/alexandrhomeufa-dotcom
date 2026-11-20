# What to check before deploying with Solidity 0.8.39

November 20, 2026

Solidity 0.8.39, released on November 19, fixes a compiler bug that could silently corrupt persistent state during certain copies involving recursive structs. The compiler team rated it medium severity. [Solidity release announcement](https://www.soliditylang.org/blog/2026/11/19/solidity-0.8.39-release-announcement/)

## Check the build and the stored state

1. **Identify the compiler that built the contract.** Check the exact `solc` version recorded in the build artifacts used for deployment. Keep that version and the compiler settings with the release record.
2. **Rebuild affected projects with Solidity 0.8.39 or later.** Run the regression suite against the rebuilt artifact. For code that updates nested state, assert both the expected new values and the values that should be preserved.
3. **Assess existing deployments separately.** Start from the artifacts of the original deployment. If an affected copy could have run, review the stored state as well as the upgrade plan. For a proxy-based upgrade, validate storage layout compatibility before replacing the implementation. [OpenZeppelin guidance on writing upgradeable contracts](https://docs.openzeppelin.com/upgrades-plugins/writing-upgradeable#modifying-your-contracts)
