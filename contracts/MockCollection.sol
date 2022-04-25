pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Mock721Collection is ERC721URIStorage {
    uint256 public tokenCounter;

    constructor () public ERC721 ("EthereumMock", "ETHM"){
        tokenCounter = 0;
    }

    function createCollectible(string memory tokenURI) public returns (uint256) {
        uint256 newItemId = tokenCounter;

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        tokenCounter = tokenCounter + 1;

        return newItemId;
    }

}