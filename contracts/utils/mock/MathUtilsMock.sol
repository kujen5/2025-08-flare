// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {MathUtils} from "../library/MathUtils.sol";

/**
 * @title MathUtils mock contract
 * @notice A contract to expose the MathUtils library for unit testing.
 *
 */
contract MathUtilsMock {
    function roundUp(uint256 x, uint256 rounding) external pure returns (uint256) {
        return MathUtils.roundUp(x, rounding);
    }

    function subOrZero(uint256 _a, uint256 _b) external pure returns (uint256) {
        return MathUtils.subOrZero(_a, _b);
    }

    function positivePart(int256 _x) external pure returns (uint256) {
        return MathUtils.positivePart(_x);
    }

    // solhint-disable-next-line func-name-mixedcase
    function mixedLTE_ui(uint256 _a, int256 _b) external pure returns (bool) {
        return MathUtils.mixedLTE(_a, _b);
    }

    // solhint-disable-next-line func-name-mixedcase
    function mixedLTE_iu(int256 _a, uint256 _b) external pure returns (bool) {
        return MathUtils.mixedLTE(_a, _b);
    }
}
