//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "hardhat/console.sol";

library CollectibleGenerator {
    function test() public pure returns (string memory) {
        return "hello";
    }

    function tokenURI(string calldata name)
        internal
        pure
        returns (string memory)
    {
        string
            memory svg = "<svg width='120' height='240' version='1.1' xmlns='http://www.w3.org/2000/svg'><defs><linearGradient id='Gradient1' x1='0' x2='0' y1='0' y2='1'><stop offset='0%' stop-color='red'/><stop offset='50%' stop-color='black' stop-opacity='0'/><stop offset='100%' stop-color='blue'/></linearGradient><linearGradient id='Gradient2'><stop class='stop1' offset='0%'/><stop class='stop2' offset='50%'/><stop class='stop3' offset='100%'/></linearGradient><style type='text/css'><![CDATA[#rect1 { fill: url(#Gradient2); }.stop1 { stop-color: red; }.stop2 { stop-color: black; stop-opacity: 0; }.stop3 { stop-color: blue; }]]></style></defs><rect x='0' y='0' rx='0' ry='0' width='100%' height='100%' fill='url(#Gradient1)'/></svg>";
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
