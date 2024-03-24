// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract SrDegenDrink is ERC1155,Ownable, ERC1155Supply {
    
    ERC20 private _token;


    struct Drink {
        uint256 vault;
         address creator;
    }

    mapping(uint256 => string) private _tokenCIDs;
    mapping(uint256 => Drink) private _creators;


    constructor(ERC20 token ) ERC1155("https://ipfs.io/ipfs/") Ownable(msg.sender)  {

        _token = token;

    }

    function mint(address account, uint256 id, uint256 amount, string memory CID)
        public
    {
        uint256 price = calculatePrice(super.totalSupply(id), amount);
        _tokenCIDs[id] = CID;

        require(_token.transferFrom(account,_creators[id].creator ,price), "SrDegenDrink: transfer failed");
        _mint(account, id, amount, "");
    }

    function mint(address account, uint256 id, uint256 amount)
        public
    {
        uint256 price = calculatePrice(super.totalSupply(id), amount);
        require(super.totalSupply(id) > 0, "SrDegenDrink: token not exist");
        require(_token.transferFrom(account,_creators[id].creator ,price), "SrDegenDrink: transfer failed");
        _mint(account, id, amount, "");
    }

    function withdraw(uint256 id) external{
        require(_creators[id].creator == msg.sender, "SrDegenDrink: only creator can withdraw");
        uint256 amount = _creators[id].vault;
        _token.transfer(msg.sender, amount);

    }

     function calculatePrice(uint256 supply, uint256 amount)
        public
        pure
        returns (uint256)
    {
         require(amount <= 10, "The max mint per transaction are 10");

    uint256 basePrice = 1 ether; // Precio base por token
    uint256 increment = 1 ether; // Incremento fijo del precio por cada token adicional en el supply total

    uint256 totalPrice = 0;

    for (uint256 i = 0; i < amount; i++) {
        uint256 currentPrice = basePrice + (increment * (supply + i));

        // Suma el precio del token actual al totalPrice
        totalPrice += currentPrice;
    }

    return totalPrice;
    }

    function updateERC20(ERC20 token) external onlyOwner {
        _token = token;
    }


    function getTokenUri(uint256 tokenId) public view  returns (string memory) {
        require(bytes(_tokenCIDs[tokenId]).length > 0, "MyERC1155Token: CID not set for token ID");
        return  _tokenCIDs[tokenId];
    }

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }
}