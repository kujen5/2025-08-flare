// SPDX-License-Identifier: MIT
pragma solidity >=0.7.6 <0.9;
pragma abicoder v2;

import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import {ICollateralPoolToken} from "../../userInterfaces/ICollateralPoolToken.sol";

interface IICollateralPoolToken is ICollateralPoolToken, IERC165 {
    function mint(address _account, uint256 _amount) external returns (uint256 _timelockExpiresAt);
    function burn(address _account, uint256 _amount, bool _ignoreTimelocked) external;
}
