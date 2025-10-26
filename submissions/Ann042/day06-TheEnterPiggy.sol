//day06-一个数字存钱罐
/*它不对外开放，只是属于你们自己的小圈子。
每个人都应该可以：
- 加入小组（需获得批准）
- 存钱
- 查看余额
- 甚至在需要时提取资金
最终，这个存钱罐将能够接受真实的以太坊。没错——真正的，被安全地存储在链上的以太币。
*/

// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.20;

// 建立一个小猪储钱罐。神奇，猪和储还是音形相似
contract TheEnteerPiggy{
    // 小🐖储钱罐就是一个mini私人银行系统
    // 银行要有银行经理来干管理的活
    address public bankManager;

    // 私人银行的服务对象呢就是一个社交俱乐部。
    // 俱乐部都得有一个会员系统，注册了的人才是会员
    address[] members;

    mapping(address => bool) public registeredMembers;

    // 银行最重要的就是账本，记账
    mapping(address => uint256) balances;

    constructor(){
        bankManager = msg.sender; // 部署者成为管理员，也就是银行经理
        members.push(msg.sender); // 银行经理就是咱猪猪俱乐部的创始会员
    }

    // 猪猪银行接下来要制定规章制度：划分经理的权责范围；存钱取钱的权限
    // 银行经理的权限：决定谁有资格成为会员
    modifier onlyManager(){
        require(msg.sender == bankManager,"Only bank manager can perform this action");
        _;
    }

    modifier onlyRegisterManager(){
        require(registeredMembers[msg.sender],"Only register member can perform this action");
        _;
    }

    // 猪猪俱乐部得壮大起来，招新！
    // 制定会员制度:加新规则
    function addMembers(address _member) public onlyManager {
        require(_member != address(0),"Invalid address");
        require(_member != bankManager,"Bank manager is already a member");
        require(!registeredMembers[_member], "Member alrady registered");
        registeredMembers[_member] = true;
        members.push(_member);

    }

    // 会员肯定得有个花名册吧：
    function getMembers() public view returns(address[] memory){
        return members;
    }

    function deposit(uint256 _amount) public onlyRegisterManager{
        require(_amount > 0,"Invalid amount");
        balances[msg.sender] += _amount;

    }

    function withdraw(uint256 _amount) public onlyRegisterManager(){
        require(_amount > 0,"Invalid amount");
        require(_amount <= balances[msg.sender],"You don't have enough money");
        balances[msg.sender] -= _amount;
    }

    // payable means this function is allowed to receive Ether.
    // Without it, any ETH sent would be rejected.
    function depositAmountEther() public payable onlyRegisterManager{
        require(msg.value > 0,"Invalid amount");
        balances[msg.sender] += msg.value;
    }


    function withdrawAmountEther() public payable onlyRegisterManager{
        require(msg.value > 0,"Invalid amount");
        require(msg.value <= balances[msg.sender],"You don't have enough money");
        balances[msg.sender] -= msg.value;
    }

}