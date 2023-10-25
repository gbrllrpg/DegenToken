# ETH-AVAX-ERC20-TOKEN

This Solidity program is a simple token contract that demonstrates the functionality of the Solidity programming language. The purpose of this program is to serve as a starting point for those who are new to Solidity and want to get a feel for how it works.

## Description

This is an ERC20 token that is deployed on the Avalanche network for Degen Gaming
The smart contract have the following functionality:
1. Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
2. Transferring tokens: Players should be able to transfer their tokens to others.
3. Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
4. Checking token balance: Players should be able to check their token balance at any time.
5. Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.

## Getting Started

### Executing program

To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at https://remix.ethereum.org/.

Once you are on the Remix website, create a new file by clicking on the "+" icon in the left-hand sidebar. Save the file with a .sol extension (e.g., DegenToken.sol). Copy and paste the following code into the file:

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    constructor() ERC20("Degen", "DGN") {
        // Items
        items[1] = Item("Ape Armor", 3);
        items[2] = Item("Shark Wand", 6);
        items[3] = Item("Dragon Wings", 1);
        items[4] = Item("Zombie Axe", 2);
        items[5] = Item("Alien Crossbow", 1);
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
    
    function burnTokens(address _player, uint256 _value) public {
        require(balanceOf(_player) >= _value, "Insufficient Degen Tokens");
        _burn(_player, _value);
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

    function redeem(address _player, uint256 itemId) public returns (string memory) {
        require(balanceOf(_player) > 0, "Insufficient Degen Tokens");
        require(items[itemId].cost > 0, "Invalid Item ID");
        require(balanceOf(_player) >= items[itemId].cost, "Not enough tokens to redeem this item");

        string memory itemName = items[itemId].name;

        _burn(_player, items[itemId].cost);

        console.log("Item redeemed by:", _player);
        console.log("Item name:", itemName);

        return itemName;
    }

}
```

To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to "0.8.22" (or another compatible version), and then click on the "Compile DegenToken.sol" button.

Once the code is compiled, you can deploy the contract by changing the environment to Injected Provider - Metamask. Make sure that the metamask account is unlocked. Select the "DgenToken" contract from the dropdown menu, and then click on the "Deploy" button.

1. Mint to any user address using the owner's address by going to the mint function button.
2. Burn using anyone's player by going to the burn function button.
3. Transfer using player's address by going tto the transfer function button.
4. Redeem Tokens using the player's address. the palyer should have enouigh balance to redeem an item og their choice.
5. Check the player's balance by putting in their address.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details
