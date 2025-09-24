// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract BuyMeACoffee {
    uint256 private counter;

    // 获取 counter 的值
    function get() public view returns (uint256) {
        return counter;
    }

    // 给 counter 加上 x
    function add(uint256 x) public {
        counter += x;
    }
}