// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Deployed at 0x7Dc547804347aE97A5f460BE4aE8347012bCBaA7

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    // library for converting integers to String at ease
    using Strings for uint256;

    struct CharactersAssets {
        uint256 level;
        uint256 speed;
        uint256 strength;
        uint256 life;
    }

    // For having token ids
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    mapping(uint256 => CharactersAssets) public tokenIdtoAssets;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function generateCharacter(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 currentLevel = tokenIdtoAssets[tokenId].level;
        uint256 currentSpeed = tokenIdtoAssets[tokenId].speed;
        uint256 currentStrength = tokenIdtoAssets[tokenId].strength;
        uint256 currentLife = tokenIdtoAssets[tokenId].life;

        // abi.encodePacked() function that takes one or more variables and encodes them into abi.
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Levels: ",
            currentLevel.toString(),
            "</text>",
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Speed: ",
            currentSpeed.toString(),
            "</text>",
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Strength: ",
            currentStrength.toString(),
            "</text>",
            '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Life: ",
            currentLife.toString(),
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

    function getAssets(uint256 tokenId)
        public
        view
        returns (CharactersAssets memory)
    {
        CharactersAssets memory assets = tokenIdtoAssets[tokenId];
        return assets;
    }

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

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        CharactersAssets memory assets = CharactersAssets(0, 0, 0, 0);
        tokenIdtoAssets[newItemId] = assets;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function _generateRandomNumber(uint256 rangeNum) private returns (uint256) {
        uint256 number = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.difficulty, msg.sender)
            )
        ) % rangeNum;
        return number;
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use the token ID which exist");
        require(
            ownerOf(tokenId) == msg.sender,
            "You are not the owner of this token Id"
        );

        uint256 currentLevel = tokenIdtoAssets[tokenId].level;
        uint256 currentSpeed = tokenIdtoAssets[tokenId].speed;
        uint256 currentStrength = tokenIdtoAssets[tokenId].strength;
        uint256 currentLife = tokenIdtoAssets[tokenId].life;

        CharactersAssets memory assets = CharactersAssets(
            currentLevel + 1,
            currentSpeed + _generateRandomNumber(5),
            currentStrength + _generateRandomNumber(10),
            currentLife + _generateRandomNumber(4)
        );
        tokenIdtoAssets[tokenId] = assets;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
