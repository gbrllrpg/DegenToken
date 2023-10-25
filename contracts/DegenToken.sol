/*
Your task is to create a ERC20 token and deploy it on the Avalanche network for Degen Gaming. The smart contract should have the following functionality:

Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
Transferring tokens: Players should be able to transfer their tokens to others.
Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
Checking token balance: Players should be able to check their token balance at any time.
Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    constructor() ERC20("Degen", "DGN") {
        // Items
        items[1] = Item("Ape Armor", 3);
        items[2] = Item("Shark Wand", 6);
        items[3] = Item("Dragon Wings", 9);
        items[4] = Item("Zombie Axe", 12);
        items[5] = Item("Alien Crossbow", 15);
    }

    struct Item {
        string name;
        uint256 cost;
    }

    mapping(uint256 => Item) public items;

    function mint(address owner, address to, uint256 amount) public onlyOwner {
        require(msg.sender == owner, "Only the owner can mint tokens.");
        _mint(to, amount);
    }

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function transferTokens(address _receiver, uint256 _value) public {
        require(balanceOf(msg.sender) >= _value, "Insufficient Degen Tokens");
        approve(msg.sender, _value);
        transferFrom(msg.sender, _receiver, _value);
    }

    function burnTokens(uint256 _value) public {
        require(balanceOf(msg.sender) >= _value, "Insufficient Degen Tokens");
        _burn(msg.sender, _value);
    }

    function listAvailableItems() external view returns (ItemInfo[] memory) {
        ItemInfo[] memory availableItems = new ItemInfo[](5);
        uint256 itemCount = 0;

        for (uint256 i = 1; i <= 5; i++) {
            if (items[i].cost > 0) {
                availableItems[itemCount] = ItemInfo(i, items[i].name, items[i].cost);
                itemCount++;
            }
        }

        return availableItems;
    }

    struct ItemInfo {
        uint256 id;
        string name;
        uint256 cost;
    }

    function redeem(uint256 itemId) public returns (string memory) {
        require(balanceOf(msg.sender) > 0, "Insufficient Degen Tokens");
        require(items[itemId].cost > 0, "Invalid Item ID");
        require(balanceOf(msg.sender) >= items[itemId].cost, "Not enough tokens to redeem this item");

        string memory itemName = items[itemId].name;

        _burn(msg.sender, items[itemId].cost);

        emit RedemptionSuccessful(msg.sender, itemId, itemName);

        return itemName;
    }

    event RedemptionSuccessful(address indexed user, uint256 indexed itemId, string itemName);
}
