// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarketplace is Ownable, ReentrancyGuard {
    // Counter for tokenIds
    // using Counters for Counters.Counter;
    // Counters.Counter private _tokenIds;

    // Constructor of ERC-1155 sets up the URI to fetch the metadata from that uri
    constructor() {
        console.log("This is the NFT Marketplace Contract ^_^");
    }

    // artistId = address of the artist
    struct ArtistAttributes {
        address artistId;
        string artistName;
        string artistImageURI;
        string artCategory;
    }

    // All the information needed for the token
    // Here we don't need the Description and Type because that is stored in the metadata on IPFS
    struct TokenInfo {
        uint256 tokenId;
        uint256 tokenPrice;
        uint32 soldCount;
        uint32 totalCount;
        address payable currentOwner;
        address payable creator;
    }

    // Emits the event that the NFT is minted and listed
    event FanClubNFTMinted(
        uint256 indexed tokenId,
        address indexed nftContract
    );

    // An array to store all artists onboarded
    ArtistAttributes[] private artists;

    // Array to store all NFTs
    TokenInfo[] private nfts;

    // A mapping of tokenIds to tokenInfo
    // Don't need because we are getting the tokenID from the NFT contract
    mapping(uint256 => TokenInfo) private tokenIdToTokenInfo;

    // A mapping of artistId to tokenID
    mapping(address => uint256[]) private artistIdToTokenId;

    // A mapping of artistId to arrayIndex in artists
    mapping(address => uint256) private addressToIndex;

    // Return all the registered Artists
    function getAllArtists() public view returns (ArtistAttributes[] memory) {
        return artists;
    }

    // Adding New artist to the artists array
    // Cost of Adding Artist == Gas Price
    function addArtist(
        address _artistAddress,
        string memory _artistName,
        string memory _imageURI,
        string memory _artCategory
    ) public {
        require(
            addressToIndex[_artistAddress] == 0,
            "Artist Already Registered"
        );

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

    // Listing the NFT
    function listNFT(
        address nftContract,
        address payable artistAddress,
        uint256 _tokenId,
        uint32 _amount,
        uint256 _tokenPrice
    ) public nonReentrant {
        // Checking if the artist is registered or not
        require(addressToIndex[artistAddress] > 0, "No such Artist Registered");

        // Adding the nft for the specific Artist
        artistIdToTokenId[artistAddress].push(_tokenId);

        // Adding tokenId mapping to tokenInfo
        TokenInfo memory newTokenInfo = TokenInfo({
            tokenId: _tokenId,
            soldCount: 0,
            totalCount: _amount,
            tokenPrice: _tokenPrice,
            currentOwner: payable(address(this)),
            creator: artistAddress
        });

        tokenIdToTokenInfo[_tokenId] = newTokenInfo;

        nfts.push(newTokenInfo);

        IERC1155(nftContract).safeTransferFrom(
            msg.sender,
            address(this),
            _tokenId,
            _amount,
            ""
        );
    }
    // Buy NFTs
    function buyNFTs(address nftContract, uint256 tokenId)
        public
        payable
        nonReentrant
    {
        uint256 price = tokenIdToTokenInfo[tokenId].tokenPrice;
        require(
            msg.value == price,
            "Please submit the asking price in order to complete the purchase"
        );
        tokenIdToTokenInfo[tokenId].creator.transfer(msg.value);
        IERC1155(nftContract).safeTransferFrom(
            address(this),
            msg.sender,
            tokenId,
            1,
            ""
        );
        tokenIdToTokenInfo[tokenId].currentOwner = payable(msg.sender);
        tokenIdToTokenInfo[tokenId].soldCount += 1;
    }

    // Returns info of an specific artist
    function getArtistInfo(address _artistAddress)
        public
        view
        returns (ArtistAttributes memory)
    {
        return artists[addressToIndex[_artistAddress] - 1];
    }

    // Getting all NFTs minted by a specific Artist
    function getNFTsOfArtist(address _artistAddress)
        public
        view
        returns (TokenInfo[] memory)
    {
        uint256 tokenId = 0;
        uint256 arrayLength = artistIdToTokenId[_artistAddress].length;

        TokenInfo[] memory artistAllNFTs = new TokenInfo[](arrayLength);

        for (uint32 i = 0; i < arrayLength; i++) {
            // Getting each tokenId related to this Artist
            tokenId = artistIdToTokenId[_artistAddress][i];

            // Getting tokenInfo related to each tokenId
            artistAllNFTs[i] = tokenIdToTokenInfo[tokenId];
        }

        return artistAllNFTs;
    }

    function getAllNFTs() public view returns (TokenInfo[] memory) {
        return nfts;
    }
}
