// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract Lottery{
    //entities -manager,player, wand winner

    address public manager;
    address payable[] public player;
    address payable public winner;

    constructor(){
        manager =msg.sender;
    }

    function participate() public payable{
        require(msg.value==10 wei,"Please pay 1 ether only");
        player.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(manager==msg.sender,"you are not the manager");
        return address(this).balance;
    }

    function random() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,player.length)));
    }
    function picwinner() public{
        require(manager==msg.sender,"You are not manager");
        require(player.length>=3,"players are less than 3");

        uint r=random();
        uint index =r%player.length;
        winner=player[index];
        winner.transfer(getBalance());
        player= new address payable[](0);
    }
}
