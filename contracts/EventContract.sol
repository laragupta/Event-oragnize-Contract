pragma solidity >= 0.5.0 < 0.9.0;
contract EventContract{
    struct Event{
        address organizer;
        string Name;
        uint date;
        uint ticketCount;
        uint ticketRemain;
        uint price;
        
    }
    mapping (uint=>Event) public Events;
    mapping (address=>mapping (uint=>uint)) public tickets;
    uint public nextId;
    function CreateEvent( string calldata Name,uint date, uint price, uint ticketCount) external {
        require(date> block.timestamp,"Organize event in future");
        require(ticketCount>0,"allow others also in the Event");
        Events[nextId]=Event(msg.sender,Name,date,ticketCount,ticketCount,price);
        nextId++;



    }
    function BuyTicket (uint id, uint quantity) external payable {
        require(Events[id].date>=block.timestamp);
        require(msg.value==(Events[id].price*quantity),"Require more Ether to buy");
        require(Events[id].ticketRemain>0,"No Tickets are left");
        require(Events[id].ticketRemain>quantity,"less ticket are available than required");
        Events[id].ticketCount-=quantity;
        tickets[msg.sender][id]+=quantity;
        
    }
    function TransferTicket(uint id , uint quantity, address to) external {
        require(Events[id].date>=block.timestamp);
        require(tickets[msg.sender][id]>=quantity,"you do not have suifficient tickets");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;



    }





}
