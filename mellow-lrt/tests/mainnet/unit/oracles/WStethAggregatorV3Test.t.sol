// SPDX-License-Identifier: BSL-1.1
pragma solidity 0.8.25;

import "../../Constants.sol";

contract Unit is Test {
    using SafeERC20 for IERC20;

    function testConstructorConstantAggregatorV3() external {
        WStethRatiosAggregatorV3 oracle = new WStethRatiosAggregatorV3(
            Constants.WSTETH
        );
        assertEq(oracle.wsteth(), Constants.WSTETH);
        assertEq(oracle.decimals(), 18);
    }

    function testGetAnswer() external {
        WStethRatiosAggregatorV3 oracle = new WStethRatiosAggregatorV3(
            address(0)
        );
        vm.expectRevert();
        oracle.getAnswer();
        oracle = new WStethRatiosAggregatorV3(Constants.WSTETH);
        int256 price = oracle.getAnswer();
        assertTrue(price > 1 ether && price < 1.3 ether);
    }

    function testLatestRoundData() external {
        WStethRatiosAggregatorV3 oracle = new WStethRatiosAggregatorV3(
            address(0)
        );
        vm.expectRevert();
        oracle.latestRoundData();
        oracle = new WStethRatiosAggregatorV3(Constants.WSTETH);
        (, int256 price, , , ) = oracle.latestRoundData();
        assertTrue(price > 1 ether && price < 1.3 ether);
    }
}
