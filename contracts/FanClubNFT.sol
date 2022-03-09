//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

// import libraries for NFT implementation
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract FanClubNFT is ERC1155 {
    // To set up the Name of the collection and Symbol of the Token
    string public name;
    string public symbol;
    address contractAddress;

    // Counter for all the NFT Ids
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => string) private _uris;

    struct TokenInfo {
        uint256 tokenId;
        uint32 totalCount;
        uint256 tokenPrice;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        address marketplaceAddress
    ) ERC1155("") {
        setName(_name, _symbol);
        contractAddress = marketplaceAddress;
    }

    function setName(string memory _name, string memory _symbol) private {
        name = _name;
        symbol = _symbol;
    }

    function launchNFT(uint32 _amount, string memory _tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();

        // Minting the NFT
        _mint(msg.sender, tokenId, _amount, "");
        setTokenURI(tokenId, _tokenURI);
        setApprovalForAll(contractAddress, true);

        // TokenInfo memory newToken = TokenInfo(tokenId, _amount, _tokenPrice);

        return tokenId;
    }

    function setTokenURI(uint256 tokenId, string memory _newURI) public {
        require(bytes(_uris[tokenId]).length == 0, "Cannot set uri twice");
        _uris[tokenId] = _newURI;
    }

    function uri(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        return _uris[_tokenId];
    }
}
