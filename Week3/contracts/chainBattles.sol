// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattle is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => NFTfeatures) public tokenIdtoAbilities;

    struct NFTfeatures {
        uint256 levels;
        uint256 speed;
        uint256 strength;
        string life;
    }

    string[5] life = [
        "noob",
        "semi-pro",
        "professional",
        "world class",
        "legendary"
    ];
    uint256 lifeCounter = 0;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function generateCharacter(uint256 tokenId) public returns (string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="30%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Niluk",
            "</text>",
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Levels: ",
            getLevels(tokenId),
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Speed: ",
            getSpeed(tokenId),
            "</text>",
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Strength: ",
            getStrength(tokenId),
            "</text>",
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Life: ",
            getlife(tokenId),
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

    function getLevels(uint256 tokenId) public view returns (string memory) {
        NFTfeatures storage abilities = tokenIdtoAbilities[tokenId];
        return abilities.levels.toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
        NFTfeatures storage abilities = tokenIdtoAbilities[tokenId];
        return abilities.levels.toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        NFTfeatures storage abilities = tokenIdtoAbilities[tokenId];
        return abilities.strength.toString();
    }

    function getlife(uint256 tokenId) public view returns (string memory) {
        NFTfeatures storage abilities = tokenIdtoAbilities[tokenId];
        return abilities.life;
    }

    function getTokenURI(uint256 tokenId) public returns (string memory) {
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

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        NFTfeatures storage abilities = tokenIdtoAbilities[newItemId];
        abilities.levels = 0;
        abilities.speed = 0;
        abilities.strength = 0;
        abilities.life = "Nothing Yet";
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing Token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this token to train it"
        );
        NFTfeatures storage abilities = tokenIdtoAbilities[tokenId];
        abilities.levels = abilities.levels + 1;
        abilities.speed = abilities.speed + 5;
        abilities.strength = abilities.strength + 10;
        lifeCounter += 1;
        abilities.life = life[lifeCounter];
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
