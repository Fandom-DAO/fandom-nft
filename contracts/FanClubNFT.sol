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

contract FanClubNFT is ERC1155, Ownable {
    // artistId = address of the artist
    struct ArtistAttributes {
        address artistId;
        string artistName;
        string artistImageURI;
        string artCategory;
    }

    // An array to store all artists onboarded
    /* Q. How to check if an artist is already present in this array of not ?? */
    ArtistAttributes[] private artists;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct TokenInfo {
        string tokenURI;
        uint32 count;
        uint32 totalCount;
        uint256 tokenPrice;
    }

    // A mapping of tokenIds to tokenInfo 
    mapping(uint256 => TokenInfo) private tokenIdToTokenInfo;

    // A mapping of artistId to tokenID
    mapping(address => uint256[]) public artistIdToTokenId;

    // A mapping of artistId to arrayIndex in artists
    mapping(address => uint256) private addressToIndex;


    /* Q. Is this necessary ??
     Because there is no need of tokenId on frontend */
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
        Checks:
        -   Return if the Artist is already present
        -   Set the AddressToIndex mapping
    **/
    function addArtist(
        address _artistAddress,
        string memory _artistName,
        string memory _imageURI,
        string memory _artCategory
    ) public {
        require(addressToIndex[_artistAddress] == 0, "Artist Already Registered");

        artists.push(
            ArtistAttributes({
                artistId: _artistAddress,
                artistName: _artistName,
                artistImageURI: _imageURI,
                artCategory: _artCategory
            })
        );

        // Every Index would be greater than equal to 1
        addressToIndex[_artistAddress] = artists.length;

        console.log("Artist added");
    }
    
    /**
        This function mints an NFT and update the state mappings
        Checks:
        -   Allow minting if the artist is a registered Artist
    **/
    function launchNFT(
        uint32 _amount,
        uint256 _price,
        string memory _tokenURI
    ) public {
        // Checking Artist is registered or not
        require(addressToIndex[msg.sender] > 0 , "This Artist-Address is not Registered");

        uint tokenId = _tokenIds.current();

        // Setting mapping artistId to tokenID
        artistIdToTokenId[msg.sender].push(tokenId);

        // Setting mapping tokenId to tokenInfo
        tokenIdToTokenInfo[tokenId] = TokenInfo({
            tokenURI: _tokenURI,
            count: 0,
            totalCount: _amount,
            tokenPrice: _price
        });

        // Minting the NFT
        _mint(msg.sender, tokenId, _amount, "");

        // Increment the _tokenIds
        _tokenIds.increment();
    }

    // Q. What to do here? 😅️
    function uri(uint256 _tokenId) override public view returns(string memory){
        
    }

    function setTokenURI(uint tokenId, string memory _newURI) public onlyOwner {

    }

    // Returns info of an specific artist
    function getArtistInfo(address _artistAddress) public view returns(ArtistAttributes memory){
        return artists[addressToIndex[_artistAddress] - 1];
    }

    // Getting all NFTs minted by a specific Artist
    function getNFTsOfArtist(address _artistAddress) public view returns(TokenInfo[] memory){
        uint tokenId = 0;
        uint256 arrayLength = artistIdToTokenId[_artistAddress].length;

        TokenInfo[] memory artistAllNFTs = new TokenInfo[](arrayLength);
        
        for(uint32 i = 0; i < arrayLength; i++) {
            // Getting each tokenId related to this Artist
            tokenId = artistIdToTokenId[_artistAddress][i];

            // Getting tokenInfo related to each tokenId
            artistAllNFTs[i] = tokenIdToTokenInfo[tokenId];
        }

        return artistAllNFTs;
    }

}
