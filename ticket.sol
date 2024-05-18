// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;
contract EventTicket{
    address manager;
    address User;
    uint NumberOfTicket;
    uint ticketPrice;
    uint ticketRemaining;
    uint startAt;
    uint endAt;
    uint quantity;

   modifier theManager {
    require(manager == msg.sender,"You are not the manager");
    _;
   }
   constructor() {
        manager = msg.sender; // Set the deployer as the manager
    }


   function set(uint _numberOfTicket, uint _ticketPrice ,uint _startAt, uint _endAt ) public theManager {
    NumberOfTicket = _numberOfTicket;
    ticketPrice = _ticketPrice;
    
    startAt = _startAt;
    endAt = _endAt;


   }
   function buyticket (uint _quantity , uint date) public  payable {
    quantity=_quantity;
    date = block.timestamp;
    require(NumberOfTicket !=0,"Not enough ticket");
    require(date>=startAt && date <= endAt,"Sale ends");
    require(msg.value == _quantity * ticketPrice,"less ether to buy ticket");
    require(_quantity <= NumberOfTicket,"ticket are not that much");
   NumberOfTicket -=quantity;

   }
   function ticketReamain() public view returns(uint){
    return NumberOfTicket;
     
   }
   function toatalbalance() public view theManager returns(uint){
    return address(this).balance;
   }
   

   function withdraw(uint amount) external theManager{
    require(amount<=address(this).balance,"insufficient Balance");
    payable(manager).transfer(amount);

   }

   }

