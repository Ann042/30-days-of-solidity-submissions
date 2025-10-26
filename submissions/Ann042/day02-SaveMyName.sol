// day02-学习存储文本数据
// 存储姓名与简介系统

// 第一行说明许可证标识符
// SPDX-License-Identifier: MIT

// set the version of solidity
pragma solidity ^0.8.20;

contract SaveMyName{

    // 声明两个状态变量
    string name;
    string bio;

    // add函数存储数据：允许用户存储他们的姓名和简介
    // Storage (存储）:永久存储; Memory（内存）:临时存储
    function add(string memory _name,string memory _bio) public {
        require(bytes(_name).length != 0,"please enter again");
        require(bytes(_bio).length != 0,"please enter again");
        
        // name是状态变量
        // _name是函数参数，也就是个占位符
        name = _name;
        bio = _bio;
    }

    // retrive()检索函数，从区块链获取数据
    // 与 add()不同，add()只是更新数据，retrieve()会向调用它的任何人返回数据。
    function retrieve()  public view returns(string memory ,string memory ){
        return (name,bio);
    }

    // more efficient, more gas
    function saveAndRetrieve(string memory _name,string memory _bio) public
     returns(string memory ,string memory ){
        require(bytes(_name).length != 0,"please enter again");
        require(bytes(_bio).length != 0,"please enter again");
        name = _name;
        bio = _bio;
        return (name,bio);
    }

}