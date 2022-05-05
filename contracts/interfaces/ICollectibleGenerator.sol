//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface ICollectibleGenerator {
    function test() external pure returns (string memory);

    function tokenURI(string calldata name)
        external
        pure
        returns (string memory);
}
