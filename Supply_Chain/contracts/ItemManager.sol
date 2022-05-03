pragma solidity ^0.6.0;

import "./Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable
{
    
    enum SupplyChainState{Created, Paid, Delivered}

    struct S_Item
    {
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }

    mapping(uint => S_Item) public items;
    uint itemIndex;

    event SupplyChainStatus(uint _itemIndex, uint _status, address _itemAdress);

    function createItem(string memory _identifier, uint _itemPrice) public onlyOwner
    {
        Item item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStatus(itemIndex, uint(items[itemIndex]._state), address(item));
        itemIndex++;
    }

    function Payment(uint _itemIndex) public payable
    {
        require(items[_itemIndex]._itemPrice == msg.value, "Only full payments accepted");
        require(items[_itemIndex]._state == SupplyChainState.Created, "Item is further in supply chain");
        items[_itemIndex]._state = SupplyChainState.Paid;
        emit SupplyChainStatus(itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }

    function Delivery(uint _itemIndex) public onlyOwner
    {
        require(items[_itemIndex]._state == SupplyChainState.Paid, "Item is further in supply chain");
        items[_itemIndex]._state = SupplyChainState.Delivered;
        emit SupplyChainStatus(itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }
}