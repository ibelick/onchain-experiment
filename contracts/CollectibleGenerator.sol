//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "hardhat/console.sol";

library CollectibleGenerator {
    function tokenURI(string calldata name)
        external
        pure
        returns (string memory)
    {
        string
            memory svg = "<svg version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' x='0px' y='0px' width='299px' height='289px' viewBox='0 0 299 289' enable-background='new 0 0 299 289' xml:space='preserve'><path fill='url(#skyGradient)' d='M293.468,275.282c0,1.617-1.311,2.928-2.928,2.928H8.46c-1.617,0-2.928-1.311-2.928-2.928V13.718c0-1.617,1.311-2.928,2.928-2.928h282.08c1.617,0,2.928,1.311,2.928,2.928V275.282z'></path><defs><linearGradient id='skyGradient' x1='100%' y1='100%'><stop offset='0%' stop-color='lightblue' stop-opacity='.5'><animate attributeName='stop-color' values='lightblue;blue;red;red;black;red;red;purple;lightblue' dur='14s' repeatCount='indefinite'></animate></stop><stop offset='100%' stop-color='lightblue' stop-opacity='.5'><animate attributeName='stop-color' values='lightblue;orange;purple;purple;black;purple;purple;blue;lightblue' dur='14s' repeatCount='indefinite'></animate><animate attributeName='offset' values='.95;.80;.60;.40;.20;0;.20;.40;.60;.80;.95' dur='14s' repeatCount='indefinite'></animate></stop></linearGradient></defs></svg>";

        string memory finalSvg = Base64.encode(bytes(svg));
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        name,
                        '", "description": "Your collectible to enter the world of web3.", "image": "data:image/svg+xml;base64,',
                        finalSvg,
                        '"}'
                    )
                )
            )
        );

        return string(abi.encodePacked("data:application/json;base64,", json));
    }
}
