// 第一行是许可证标识符
// SPDX-License-Identifier: MIT

// 设置Solidity版本
pragma solidity ^0.8.0;

// Define the Contract
// "Contract" = "Class"
contract ClickCounter {
    // 定义合约内容

    // 声明状态变量，状态变量永久存储
    uint256 public counter;

    // public表示所有人可调用此函数
    // 修改状态变量需要gas fee
    function click() public {
        counter++;
    }
}