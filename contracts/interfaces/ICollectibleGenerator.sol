// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICollectibleGenerator {
    function tokenURI(string calldata name)
        external
        pure
        returns (string memory);
}
