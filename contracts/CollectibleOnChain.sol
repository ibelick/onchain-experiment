// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./CollectibleGenerator.sol";

contract CollectibleOnChain is ERC721URIStorage, Ownable {
    /// @dev Price for one collectible (at the beggining)
    uint256 internal _price; // = 0.002 ether;
    /// @dev Reserved collectible
    uint256 internal _reserved; // = 200;
    /// @dev The beneficiary of the contract
    address payable beneficiary;

    uint256 public MAX_SUPPLY; // = 10000;
    uint256 public MAX_TOKENS_PER_MINT; // = 20;
    bool public publicMintActive = false;
    bool private _saleStarted;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    modifier whenSaleStarted() {
        require(_saleStarted, "Sale not started");
        _;
    }

    modifier publicMintIsActive() {
        require(publicMintActive, "Public mint not active yet");
        _;
    }

    modifier publicMintIsNotActive() {
        require(!publicMintActive, "Public mint is already active");
        _;
    }

    event CollectibleMinted(address sender, uint256 tokenId);

    constructor(uint256 _startPrice, uint256 _maxSupply)
        ERC721("CollectibleOnChain", "COC")
    {
        _price = _startPrice;
        MAX_SUPPLY = _maxSupply;
    }

    // function createSvg(uint256) internal view returns (string memory) {
    //     string memory finalSvg = string(abi.encodePacked());

    //     return finalSvg;
    // }

    // ============ OWNER INTERFACE ============

    function setPublicMintActive() external onlyOwner publicMintIsNotActive {
        require(beneficiary != address(0), "Beneficiary not set");

        publicMintActive = true;
    }

    function setBeneficiary(address payable _beneficiary)
        public
        virtual
        onlyOwner
    {
        beneficiary = _beneficiary;
    }

    function withdraw() public virtual onlyOwner {
        require(beneficiary != address(0), "Beneficiary not set");

        uint256 _balance = address(this).balance;

        require(payable(beneficiary).send(_balance));
    }

    // ============ PUBLIC VIEW FUNCTIONS ============

    /// @notice Get the current price of one Collectible
    function getUnitPrice() public view virtual returns (uint256) {
        return _price;
    }

    /// @notice Get if the sale started
    function saleStarted() public view returns (bool) {
        return _saleStarted;
    }

    // ============ PUBLIC INTERFACE ============

    function mint(string calldata name)
        public
        payable
        virtual
        publicMintIsActive
    {
        require(msg.value <= _price, "Ether sent is not correct");
        require(bytes(name).length > 0, "Empty string.");
        require(bytes(name).length < 17, "Name too long.");
        uint256 newItemId = _tokenIds.current();
        string memory newTokenURI = CollectibleGenerator.tokenURI(name);

        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, newTokenURI);
        _tokenIds.increment();

        emit CollectibleMinted(msg.sender, newItemId);
    }

    /// WILL BE IN ANOTHER CONTRACTS ///
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
