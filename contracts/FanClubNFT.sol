//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

// import libraries for NFT implementation
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract FanClubNFT is ERC721URIStorage {
    struct ArtistAttributes {
        uint256 artistId;
        string artistName;
        string imageURI;
        string artCategory;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // A mapping of tokenIds to token attributes
    mapping(uint256 => ArtistAttributes) public tokenIdToTokenAttributes;

    ArtistAttributes[] artists;

    // A mapping to store the address of the owner  of the NFT
    mapping(address => uint256) public FanClubNFTOwners;

    event FanClubNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("FanClubNFT", "FAN") {
        console.log("This is Fan Club NFT contract. Heck yeahh !! ");
        _tokenIds.increment();
    }

    function mintFanClubNFT(uint256 _artistId) public {
        uint256 newTokenId = _tokenIds.current();

        _safeMint(msg.sender, newTokenId);
        tokenIdToTokenAttributes[newTokenId] = ArtistAttributes({
            artistId: artists[_artistId].artistId,
            artistName: artists[_artistId].artistName,
            imageURI: artists[_artistId].imageURI,
            artCategory: artists[_artistId].artCategory
        });
    }

    function getAllArtists() public view returns (ArtistAttributes[] memory) {
        return artists;
    }

    /**
    This function is supposed to be called when any artist registers themselves
     */
    function addArtist(
        string memory _artistName,
        string memory _imageURI,
        string memory _artCategory
    ) public {
        artists.push(
            ArtistAttributes({
                artistId: artists.length + 1,
                artistName: _artistName,
                imageURI: _imageURI,
                artCategory: _artCategory
            })
        );

        console.log("Artist added");
    }

    function createNFT() public{
        
    }
}
