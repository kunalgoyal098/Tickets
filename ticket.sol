// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract EventTicket {
    address public manager;
    uint public numberOfTickets;
    uint public ticketPrice;
    uint public startAt;
    uint public endAt;
    bool public saleActive;
    uint public maxPurchaseLimit;
    
    mapping(address => uint) public ticketBalances;

    modifier onlyManager {
        require(manager == msg.sender, "You are not the manager");
        _;
    }

    modifier saleIsActive {
        require(saleActive, "Ticket sale is not active");
        require(block.timestamp >= startAt && block.timestamp <= endAt, "Sale period is not active");
        _;
    }

    constructor() {
        manager = msg.sender; // Set the deployer as the manager
    }

    function set(uint _numberOfTickets, uint _ticketPrice, uint _startAt, uint _endAt, uint _maxPurchaseLimit) public onlyManager {
        numberOfTickets = _numberOfTickets;
        ticketPrice = _ticketPrice;
        startAt = _startAt;
        endAt = _endAt;
        maxPurchaseLimit = _maxPurchaseLimit;
        saleActive = true;
    }

    function buyTicket(uint _quantity) public payable saleIsActive {
        require(_quantity <= numberOfTickets, "Not enough tickets available");
        require(_quantity + ticketBalances[msg.sender] <= maxPurchaseLimit, "Exceeds maximum purchase limit");
        require(msg.value == _quantity * ticketPrice, "Incorrect amount of ether sent");

        ticketBalances[msg.sender] += _quantity;
        numberOfTickets -= _quantity;
    }

    function getTicketBalance(address user) public view returns (uint) {
        return ticketBalances[user];
    }

    function setSaleActive(bool _saleActive) public onlyManager {
        saleActive = _saleActive;
    }

    function remainingTickets() public view returns (uint) {
        return numberOfTickets;
    }

    function totalBalance() public view onlyManager returns (uint) {
        return address(this).balance;
    }

    function withdraw(uint amount) external onlyManager {
        require(amount <= address(this).balance, "Insufficient balance");
        payable(manager).transfer(amount);
    }

    function refundTickets(uint _quantity) public {
        require(ticketBalances[msg.sender] >= _quantity, "Not enough tickets to refund");

        uint refundAmount = _quantity * ticketPrice;
        ticketBalances[msg.sender] -= _quantity;
        numberOfTickets += _quantity;

        payable(msg.sender).transfer(refundAmount);
    }

    function transferTickets(address _to, uint _quantity) public {
        require(ticketBalances[msg.sender] >= _quantity, "Not enough tickets to transfer");

        ticketBalances[msg.sender] -= _quantity;
        ticketBalances[_to] += _quantity;
    }

    function getEventDetails() public view returns (uint, uint, uint, uint, bool, uint) {
        return (numberOfTickets, ticketPrice, startAt, endAt, saleActive, maxPurchaseLimit);
    }
}


