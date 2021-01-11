pragma solidity ^0.6.6;

contract SavingAccount{
    
    struct client{
        int id_client;
        address address_client;
        uint balance_client;
    }
    
    client[] clients_arr;
    int counter;
    
    address payable manager;
    
    mapping(address => uint) public lastDate;
    
    constructor() public{
        counter = 0;
    }
    
    modifier onlyManager(){
        require(msg.sender == manager, "Only manager can run this method");
        _;
    }
    
    modifier onlyClient(){
        bool isClient;
        for(uint i = 0; i < clients_arr.length; i++){
            if(clients_arr[i].address_client == msg.sender){
                isClient = true;
                break;
            }
        }
        require(isClient, "Only clients can run this method");
        _;
    }
    
    receive() external payable{}
    
    function setManager(address managerAddress) public returns(string memory){
        manager = payable(managerAddress);
        return "success";
    }
    
    function joinClient() public payable returns(string memory){
        lastDate[msg.sender] = now;
        
        clients_arr.push(client(counter++, msg.sender, address(msg.sender).balance));
        
        return "success";
    }
    
    function deposit() public payable onlyClient{
        payable(address(this)).transfer(msg.value);
    }
    
    function withdraw(uint total) public payable onlyClient{
        msg.sender.transfer(total * 1 ether);
    }
    
    function sendInterest() public payable onlyManager{
        for(uint i = 0; i < clients_arr.length; i++){
            address initialAdress = clients_arr[i].address_client;
            uint date = lastDate[initialAdress];
            
            if(now < date + 15 seconds){
                revert("Wait 15 seconds");
            }
            
            payable(initialAdress).transfer(1 ether);
            lastDate[initialAdress] = now;
        }
    }
    
    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
    
}
