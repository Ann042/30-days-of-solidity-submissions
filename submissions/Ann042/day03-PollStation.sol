// day03-learn about arrays and mapping
// PollStation

// 说明许可证标识符
// SPDX-License-Identifier: MIT

// set the version of solidity
pragma solidity ^0.8.20;

contract PollStation{

    // 数组 – 存储候选人列表
    string[] public candidateNames;
    // 映射 – 存储投票计数, 有点像python的字典，存储键值对
    mapping(string => uint256) voteCount;

    // 构建一个添加候选人的函数
    function addCandidateNames(string memory _candidateNames) public {
        candidateNames.push(_candidateNames);
         voteCount[_candidateNames] = 0;
    }

    // 检索候选人列表
    function getCandidateNames() public view returns(string[] memory){
        return candidateNames;
    }

    // 投票的函数
    function vote(string memory _candidateName) public{
        voteCount[_candidateName] += 1;
    }

    // 函数-检查候选人票数
    function getVote(string memory _candidateName) public view returns(uint256){
        return voteCount[_candidateName];

    }


}