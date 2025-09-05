// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Test} from "forge-std/Test.sol";
import {CollateralPool} from "../../../contracts/collateralPool/implementation/CollateralPool.sol";
import {FAsset} from "../../../contracts/fassetToken/implementation/FAsset.sol";
import {FAssetProxy} from "../../../contracts/fassetToken/implementation/FAssetProxy.sol";
import {CollateralPoolToken} from "../../../contracts/collateralPool/implementation/CollateralPoolToken.sol";
import {CollateralPoolHandler} from "./CollateralPoolHandler.t.sol";
import {AssetManagerMock} from "../../../contracts/assetManager/mock/AssetManagerMock.sol";
import {WNatMock} from "../../../contracts/flareSmartContracts/mock/WNatMock.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {SafePct} from "../../../contracts/utils/library/SafePct.sol";
import {MathUtils} from "../../../contracts/utils/library/MathUtils.sol";

// solhint-disable func-name-mixedcase
contract CollateralPoolTest is Test {
    using SafeCast for uint256;
    using SafeCast for int256;
    using SafePct for uint256;

    CollateralPool private collateralPool;
    FAsset private fAsset;
    FAssetProxy private fAssetProxy;
    FAsset private fAssetImpl;
    CollateralPoolToken private collateralPoolToken;
    CollateralPoolHandler private handler;

    address private governance;
    address private agentVault;
    AssetManagerMock private assetManagerMock;
    WNatMock private wNat;

    uint32 private exitCR = 12000;
    address[] private accounts;

    bytes4[] private selectors;

    function setUp() public {
        governance = makeAddr("governance");
        wNat = new WNatMock(makeAddr("governance"), "wNative", "wNat");
        assetManagerMock = new AssetManagerMock(wNat);
        agentVault = makeAddr("agentVault");

        fAssetImpl = new FAsset();
        fAssetProxy = new FAssetProxy(address(fAssetImpl), "fBitcoin", "fBTC", "Bitcoin", "BTC", 18);
        fAsset = FAsset(address(fAssetProxy));
        fAsset.setAssetManager(address(assetManagerMock));

        collateralPool = new CollateralPool(agentVault, address(assetManagerMock), address(fAsset), exitCR);

        collateralPoolToken =
            new CollateralPoolToken(address(collateralPool), "FAsset Collateral Pool Token BTC-AG1", "FCPT-BTC-AG1");

        vm.prank(address(assetManagerMock));
        collateralPool.setPoolToken(address(collateralPoolToken));

        handler = new CollateralPoolHandler(collateralPool, fAsset);
        accounts = handler.getAccounts();

        assetManagerMock.setCheckForValidAgentVaultAddress(false);
        assetManagerMock.registerFAssetForCollateralPool(fAsset);
        assetManagerMock.setAssetPriceNatWei(handler.mul(), handler.div());

        targetContract(address(handler));
        selectors.push(handler.enter.selector);
        selectors.push(handler.exit.selector);
        selectors.push(handler.selfCloseExit.selector);
        selectors.push(handler.withdrawFees.selector);
        selectors.push(handler.mint.selector);
        selectors.push(handler.depositNat.selector);
        selectors.push(handler.payout.selector);
        selectors.push(handler.fAssetFeeDeposited.selector);
        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
    }



function test_exitAndselfExitDoNotWithdrawFAssetFeesToLP() public payable  {
    address attacker = makeAddr("attacker");
    vm.deal(attacker, 100e18);
    vm.startPrank(attacker);
    collateralPool.enter{value: 100e18}(); // enter with 100e18 NAT
    assertEq(collateralPoolToken.balanceOf(attacker),100e18) ;
    vm.stopPrank();

    address agent = makeAddr("agent");
    vm.startPrank(agent);
    //fAsset.mint(address(collateralPool), 10){ from: assetManagerMock };
    vm.stopPrank();
}



}
