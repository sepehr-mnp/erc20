pragma solidity ^0.8.7;

contract Lottery{
    address public manager;
    address[] public players;
    constructor(){
        manager = msg.sender;
    }

    function enter() public payable{
        require(msg.value>=10000000000000000,"not enough money!!");
        players.push(msg.sender);
    }

    function random() private view returns (uint){
        return (uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players))));
    }
    modifier restricted(){
        require(msg.sender==manager,"you are not the manager!");
        _;
    }

    function pickWinner() public restricted{
        uint index = random()%players.length;
        payable(players[index]).transfer(address(this).balance);
        players =  new address[](0);
    }

    function getPlayers() public view returns(address[] memory){
        return players;
    }


}