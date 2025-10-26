/* day07-SimpleIOU` 是链上群账。
    - Track debts,
    - Store ETH in their own in-app balance,
    - And settle up easily, without doing math or spreadsheets.
*/

// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.20;

// 创建一个私密记账小组，或者说，公共账本？
contract SimpleIOU{
    // 每个合约都值得拥有一个管理员
    address public owner;

    // 检查入组权限，得是能一起吃喝玩乐的朋友才能组局
    mapping(address => bool) public registeredFriends;
    address[] public friendList;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) public debts;

    // 构造组局吃饭的规则，来玩的人都得遵守记账规则
    constructor(){
        owner = msg.sender;
        registeredFriends[msg.sender] = true;
        friendList.push(msg.sender);
    }

    // Only owner and register deposit ETH,record debts,pay debts,send ETH,withdraw
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier onlyRegistered() {
        require(registeredFriends[msg.sender], "You are not registered");
        _;
    }

    function addFriends(address _friend) public onlyOwner{
        require(_friend != address(0), "Invalid address");
        require(!registeredFriends[_friend], "Friend already registered");
        registeredFriends[_friend] = true;
        friendList.push(_friend);

    }

     
    function checkBalance() public view onlyRegistered returns (uint256) {
        return balances[msg.sender];
    }



    function depositIntoWallet() public payable onlyRegistered{
        require(msg.value > 0,"Invalid amount");
        balances[msg.sender] = msg.value;

    }

    function withdraw(uint256 _amount) public onlyRegistered {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;        

        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Withdrawal failed");
    }


    // 欠钱记录，只是记录协议，不移动钱
    function recordDebt(address _debtor, uint256 _amount) public onlyRegistered{
        require(_debtor != address(0), "Invalid address");
        require(registeredFriends[_debtor], "Address not registered");
        require(_amount > 0, "Invalid Amount");
        debts[_debtor][msg.sender] += _amount;

    }

    // 还钱操作，所有的ETH都是在合约内部用户间流动
    function payFromWallet(address _creditor,uint256 _amount) public onlyRegistered{
        require(_creditor != address(0), "Invalid address");
        require(registeredFriends[_creditor], "Creditor not registered");
        require(_amount > 0, "Invalid Amount");
        require(debts[msg.sender][_creditor] >= _amount, "Debt amount incorrect");
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        balances[msg.sender] -= _amount;
        balances[_creditor] += _amount;
        debts[msg.sender][_creditor] -= _amount;

    }

    // transfer() 是一种内置的 Solidity 方法，用于将 ETH 从合约发送到外部地址。
    function transferEtherViaCall(address payable _to, uint256 _amount) public onlyRegistered {
        require(_to != address(0), "Invalid address");
        require(registeredFriends[_to], "Recipient not registered");
        require(balances[msg.sender] >= _amount, "Insufficient balance");
    
        balances[msg.sender] -= _amount;
    
        (bool success, ) = _to.call{value: _amount}("");
        balances[_to] += _amount;
        require(success, "Transfer failed");
    }

}