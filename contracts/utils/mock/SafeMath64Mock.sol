// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {SafeMath64} from "../library/SafeMath64.sol";

/**
 * @title SafeMath64 mock contract
 * @notice A contract to expose the SafeMath64 library for unit testing.
 *
 */
contract SafeMath64Mock {
    function toUint64(int256 a) public pure returns (uint64) {
        return SafeMath64.toUint64(a);
    }

    function toInt64(uint256 a) public pure returns (int64) {
        return SafeMath64.toInt64(a);
    }
}
