// SPDX-License-Identifier: MIT
// solhint-disable gas-custom-errors

pragma solidity ^0.8.27;

import {Governed} from "../implementation/Governed.sol";
import {IGovernanceSettings} from "@flarenetwork/flare-periphery-contracts/flare/IGovernanceSettings.sol";

contract GovernedWithTimelockMock is Governed {
    uint256 public a;
    uint256 public b;

    constructor(IGovernanceSettings _governanceSettings, address _initialGovernance)
        Governed(_governanceSettings, _initialGovernance)
    {}

    function changeA(uint256 _value) external onlyGovernance {
        a = _value;
    }

    function increaseA(uint256 _increment) external onlyGovernance {
        a += _increment;
    }

    function changeWithRevert(uint256 _value) external onlyGovernance {
        a = _value;
        revert("this is revert");
    }

    function changeB(uint256 _value) external onlyImmediateGovernance {
        b = _value;
    }
}
