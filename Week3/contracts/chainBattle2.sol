// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// Deployed to Mumbai Poygon Testnet at
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles2 is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Define the track for the character
    struct Track {
        uint256 id;
        uint256 level;
        uint256 speed;
        uint256 strength;
        uint256 life;
    }
    // The mapping will link the NFT-Id to the stats of the NFT character.
    mapping(uint256 => Track) public tokenIdToTrack;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    // Define the generateCharacter function to generate the SVG image of our dynamic NFT
    // representing a character in a game.
    function generateCharacter(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            "<text x='50%' y='30%' class='base' dominant-baseline='middle' text-anchor='middle'>Warrior</text>",
            "<text x='50%' y='40%' class='base' dominant-baseline='middle' text-anchor='middle'>Id:",
            getId(tokenId),
            "</text>",
            "<text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>Level:",
            getLevel(tokenId),
            "</text>",
            "<text x='50%' y='60%' class='base' dominant-baseline='middle' text-anchor='middle'>Speed:",
            getSpeed(tokenId),
            "</text>",
            "<text x='50%' y='70%' class='base' dominant-baseline='middle' text-anchor='middle'>Strength:",
            getStrength(tokenId),
            "</text>",
            "<text x='50%' y='80%' class='base' dominant-baseline='middle' text-anchor='middle'>Life:",
            getLife(tokenId),
            "</text>",
            "</svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    // Create the getId Function to retrieve the NFT Id
    function getId(uint256 tokenId) public view returns (string memory) {
        uint256 id = tokenIdToTrack[tokenId].id;
        return id.toString();
    }

    // Create the getLevel Function to retrieve the NFT Level
    function getLevel(uint256 tokenId) public view returns (string memory) {
        uint256 level = tokenIdToTrack[tokenId].level;
        return level.toString();
    }

    // Create the getSpeed Function to retrieve the NFT Speed
    function getSpeed(uint256 tokenId) public view returns (string memory) {
        uint256 speed = tokenIdToTrack[tokenId].speed;
        return speed.toString();
    }

    // Create the getStrength Function to retrieve the NFT Strenght
    function getStrength(uint256 tokenId) public view returns (string memory) {
        uint256 strength = tokenIdToTrack[tokenId].strength;
        return strength.toString();
    }

    // Create the getLife Function to retrieve the NFT Life
    function getLife(uint256 tokenId) public view returns (string memory) {
        uint256 life = tokenIdToTrack[tokenId].life;
        return life.toString();
    }

    // Create the getTokenURI Function to generate the tokenURI
    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    // Create the Mint Function to create the NFT with on-chain metadata with 3 goals:
    // create a new NFT - inizialize the stats values - set the token URI.
    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToTrack[newItemId].id = 1;
        tokenIdToTrack[newItemId].level = 2;
        tokenIdToTrack[newItemId].speed = 4;
        tokenIdToTrack[newItemId].strength = 3;
        tokenIdToTrack[newItemId].life = 6;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    // Create the Train Function to raise your NFT stats
    function train(uint256 tokenId) public {
        require(_exists(tokenId));
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this NFT to train it!"
        );
        uint256 currentId = tokenIdToTrack[tokenId].id;
        tokenIdToTrack[tokenId].id = currentId + 1;
        uint256 currentLevel = tokenIdToTrack[tokenId].level;
        tokenIdToTrack[tokenId].level = currentLevel + random(currentLevel);
        uint256 currentSpeed = tokenIdToTrack[tokenId].speed;
        tokenIdToTrack[tokenId].speed = currentSpeed + random(currentSpeed);
        uint256 currentStrength = tokenIdToTrack[tokenId].strength;
        tokenIdToTrack[tokenId].strength =
            currentStrength +
            random(currentStrength);
        uint256 currentLife = tokenIdToTrack[tokenId].life;
        tokenIdToTrack[tokenId].life = currentLife + random(currentLife);

        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    function random(uint256 number) public view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.difficulty,
                        msg.sender
                    )
                )
            ) % number;
    }
}
