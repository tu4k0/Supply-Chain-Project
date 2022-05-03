pragma solidity ^0.6.0;

import "./ItemManager.sol";

contract Item
{
    uint public priceinWei;
    uint public pricePaid;
    uint public index;

    ItemManager parentContract;

    constructor(ItemManager _parentContract, uint _priceinWei, uint _index) public
    {
        priceinWei = _priceinWei;
        index = _index;
        parentContract = _parentContract;
    }

    receive() external payable
    {
        require(pricePaid == 0, "Item is paid already");
        require(priceinWei == msg.value, "Only full payments allowed");
        pricePaid = msg.value;
        (bool success, ) =address (parentContract).call.value(msg.value)(abi.encodeWithSignature("Payment(uint256)", index));
        require(success, "The transaction wasn`t successful, cancelling");
    }

    fallback() external
    {

    }
}