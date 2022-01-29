//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

// import libraries for NFT implementation
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract FanClubNFT is ERC1155 {
    // artistId = address of the artist
    struct ArtistAttributes {
        address artistId;
        string artistName;
        string artistImageURI;
        string artCategory;
    }

    // An array to store all artists onboarded
    ArtistAttributes[] artists;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct tokenInfo {
        string tokenURI;
        uint32 count;
        uint32 totalCount;
        uint256 tokenPrice;
    }

    // A mapping of tokenIds to tokenInfo
    mapping(uint256 => tokenInfo) public tokenIdToTokenInfo;

    // A mapping of artistId to tokenID
    mapping(address => uint256[]) public artistIdtoTokenId;

    event FanClubNFTMinted(address sender, uint256 tokenId);

    constructor() ERC1155("") {
        console.log("This is Fan Club NFT contract. Heck yeahh !! ");
        _tokenIds.increment();
    }

    function getAllArtists() public view returns (ArtistAttributes[] memory) {
        return artists;
    }

    /**
    This function is supposed to be called when any artist registers themselves
     */
    function addArtist(
        address _artistAddress,
        string memory _artistName,
        string memory _imageURI,
        string memory _artCategory
    ) public {
        artists.push(
            ArtistAttributes({
                artistId: _artistAddress,
                artistName: _artistName,
                artistImageURI: _imageURI,
                artCategory: _artCategory
            })
        );

        console.log("Artist added");
    }
}
