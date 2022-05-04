import { assert } from "console";

const ItemManager = artifacts.require("./ItemManager.sol");

contract("ItemManager", accounts => {
  it("...should be able to add item", async function() {
    const ItemManagerInstance = await ItemManager.deployed();
    const itemId = "test1";
    const itemCost = 500;


    const result = await ItemManagerInstance.createItem(itemId, itemCost, {from: accounts[0]});
    assert.equal(result.logs[0].args._itemIndex, 0, "it`s not the first item");

    const item = await ItemManagerInstance.items(0);
    assert.equal(item._identifier, itemId, "Wrong item!");
  });
});
