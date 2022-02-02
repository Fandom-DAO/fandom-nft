//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

// import libraries for NFT implementation
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract FanClubNFT is ERC1155, Ownable {
    // To set up the Name of the collection and Symbol of the Token
    string public name;
    string public symbol;
    
    // Counter for all the NFT Ids
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct TokenInfo {
        uint tokenId;
        uint32 totalCount;
        uint256 tokenPrice;
    }

    
    constructor() ERC1155("") {
        console.log("This is Fan Club NFT contract. Heck yeahh !! ");
    }
    

    function launchNFT(
        uint32 _amount,
        uint256 _tokenPrice,
        string memory _tokenURI
    ) public returns (TokenInfo memory) {
        
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();

        setTokenURI(tokenId, _tokenURI);

        // Minting the NFT
        _mint(msg.sender, tokenId, _amount, "");

        TokenInfo memory newToken = TokenInfo(
            tokenId,
            _amount,
            _tokenPrice
        );

        return newToken;
    }
    

    function setTokenURI(uint tokenId, string memory _newURI) public onlyOwner {

    }

}
