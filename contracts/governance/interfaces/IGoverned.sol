// SPDX-License-Identifier: MIT
pragma solidity >=0.7.6 <0.9;

import {IGovernanceSettings} from "@flarenetwork/flare-periphery-contracts/flare/IGovernanceSettings.sol";

interface IGoverned {
    error OnlyExecutor();
    error OnlyGovernance();
    error TimelockInvalidSelector();
    error TimelockNotAllowedYet();
    error AlreadyInProductionMode();
    error GovernedAlreadyInitialized();
    error GovernedAddressZero();

    /**
     * Governance call was timelocked. It can be executed after `allowedAfterTimestamp` by one of the executors.
     * @param encodedCall ABI encoded call data, to be used in executeGovernanceCall
     * @param encodedCallHash keccak256 hash of the ABI encoded call data
     * @param allowedAfterTimestamp the earliest timestamp when the call can be executed
     */
    event GovernanceCallTimelocked(bytes encodedCall, bytes32 encodedCallHash, uint256 allowedAfterTimestamp);

    /**
     * Previously timelocked governance call was executed.
     * @param encodedCallHash keccak256 hash of the ABI encoded call data
     *      (same as `GovernanceCallTimelocked.encodedCallHash`)
     */
    event TimelockedGovernanceCallExecuted(bytes32 encodedCallHash);

    /**
     * Previously timelocked governance call was canceled.
     * @param encodedCallHash keccak256 hash of the ABI encoded call data
     *      (same as `GovernanceCallTimelocked.encodedCallHash`)
     */
    event TimelockedGovernanceCallCanceled(bytes32 encodedCallHash);

    /**
     * Governed contract was initialised (not yet in production mode).
     * @param initialGovernance the governance address used until switch to production mode
     */
    event GovernanceInitialised(address initialGovernance);

    /**
     * The governed contract has switched to production mode
     * Timelocks are now enabled and the governance address is `governanceSettings.getGovernanceAddress()`.
     * @param governanceSettings the system contract holding governance address, timelock and executors settings
     */
    event GovernedProductionModeEntered(address governanceSettings);

    /**
     * @notice Execute the timelocked governance calls once the timelock period expires.
     * @dev Only executor can call this method.
     * @param _encodedCall ABI encoded call data (signature and parameters).
     *      You should use `encodedCall` parameter from `GovernanceCallTimelocked` event.
     */
    function executeGovernanceCall(bytes calldata _encodedCall) external;

    /**
     * Cancel a timelocked governance call before it has been executed.
     * @dev Only governance can call this method.
     * @param _encodedCall ABI encoded call data (signature and parameters).
     *      You should use `encodedCall` parameter from `GovernanceCallTimelocked` event.
     */
    function cancelGovernanceCall(bytes calldata _encodedCall) external;

    /**
     * Enter the production mode after all the initial governance settings have been set.
     * This enables timelocks and the governance is afterwards obtained by calling
     * `governanceSettings.getGovernanceAddress()`.
     */
    function switchToProductionMode() external;

    /**
     * Returns the governance settings contract address.
     */
    function governanceSettings() external view returns (IGovernanceSettings);

    /**
     * True after switching to production mode (see `switchToProductionMode()`).
     */
    function productionMode() external view returns (bool);

    /**
     * Returns the current effective governance address.
     * Before switching to production, the effective governance is `initialGovernance`,
     * and afterwards it is `governanceSettings.getGovernanceAddress()`.
     */
    function governance() external view returns (address);

    /**
     * Check if an address is one of the executors defined in `governanceSettings`.
     */
    function isExecutor(address _address) external view returns (bool);
}
