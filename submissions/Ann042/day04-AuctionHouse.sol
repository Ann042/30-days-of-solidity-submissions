// day04-整合所有内容、构建一个完整、真实的合约
// 构建一个拍卖系统:一个在线竞价平台，用户可以对物品进行出价，最终出价最高者获胜。

// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.20;

// 我们的拍卖系统合约
contract AuctionHouse{

    // 1 谁创建了拍卖？追踪负责操作的人——即部署合约的人。
    address public owner;

    // 2 我们在拍卖什么？拍卖创建者描述即将被竞拍的东西。
    // 这可以是任何东西——在部署合同时，我们将让所有者提供物品名称。
    string public item;
    
    // 3 拍卖何时结束？
    // 我们不想让拍卖永远持续下去。因此，我们将定义它的持续时间——并使用时间戳跟踪拍卖结束的时间。
    uint public auctionEndTime;

    // 4 目前谁在领先？
    // 存储：迄今为止的最高出价;以及出价人的地址
    // 我们将这些标记为private ，这样没有人可以直接访问它们并欺骗系统。
    // 但我们仍然会让人看到它们——只是拍卖结束后 。
    address private highestBidder;

    uint private highestBid;

    // 5 拍卖已经结束了吗？
    // 我们需要一个标志来标记拍卖是否完成——以确保它不会被结束两次，或者有人过早地查看获胜者。
    bool public ended;

    // 6 谁出价了，出价多少？
    // 记录每个用户的出价。确保人们不会再次出相同金额的价，并且知道谁参与了竞标。
    mapping(address => uint) public bids;

    address[] public bidders;

    constructor(string memory _item,uint _biddingTime){
        owner = msg.sender;
        item = _item;
        auctionEndTime = block.timestamp + _biddingTime;

    }


    function bid(uint amount) public {
        require(block.timestamp < auctionEndTime, "This action already ended" );
        // check bit amount > 0; send the notice
        require(amount > 0, "Bid amount must be greater than zero");
        require(amount > bids[msg.sender] , "The new bid must be greater than your previous bid");

        // 如果这是用户的首次出价 ，我们将他们添加到bidders数组中。这样，我们就能得到一个完整的参与人员名单。
        if(bids[msg.sender] == 0){
            bidders.push(msg.sender);
        }

        // save the bid amount
        bids[msg.sender] = amount;

        // check the highest bid
        if(amount > highestBid){
            highestBid = amount;
            highestBidder = msg.sender;
        }

    }

    // define the end of auction
    function endAction() public {
        require(block.timestamp >= auctionEndTime, "This action already ended" );
        require(!ended, "Auction end already called.");
        ended = true;

    }

    // 拍卖结束后出示：最高价及其出价者
    function getWiner() external view returns(address,uint){
        require(ended,"Action hasn't not ended yet" );
        return (highestBidder,highestBid);

    }

    function getAllBiders() external view returns(address[] memory){
        return bidders;
    }


}