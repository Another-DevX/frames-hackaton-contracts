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

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
    {
        uint256 price = calculatePrice(super.totalSupply(id));
        _tokenCIDs[id] = string(data);

        require(_token.transferFrom(account,_creators[id].creator ,price), "SrDegenDrink: transfer failed");
        _mint(account, id, amount, "");
    }

    function mint(address account, uint256 id, uint256 amount)
        public
    {
        uint256 price = calculatePrice(super.totalSupply(id));
        require(super.totalSupply(id) > 0, "SrDegenDrink: token not exist");
        require(_token.transferFrom(account,_creators[id].creator ,price), "SrDegenDrink: transfer failed");
        _mint(account, id, amount, "");
    }

    function withdraw(uint256 id) external{
        require(_creators[id].creator == msg.sender, "SrDegenDrink: only creator can withdraw");
        uint256 amount = _creators[id].vault;
        _token.transfer(msg.sender, amount);

    }


    /// @notice Calculates a price based on an input, applying an exponential factor of 1.1.
    /// @dev This function uses a square-and-multiply algorithm for computing 1.1 ** input,
    /// adjusted to work with an ERC20 token that has 16 decimals.
    /// The square-and-multiply algorithm is efficient and reduces gas costs compared with
    /// direct exponentiation, especially for large 'input' values.
    /// @param input The exponent used to calculate the price, where the price is (1.1 ** input).
    /// @return result The calculated price, adjusted to account for 16 decimals,
    /// following the ERC20 token decimals convention.
    function calculatePrice(uint256 input) public pure returns (uint256) {
        uint256 DECIMALS = 10**18;
        uint256 base = 11 * DECIMALS / 10; 
        uint256 result = DECIMALS; 

        while (input != 0) {
            if (input % 2 != 0) {
                result = (result * base) / DECIMALS;
            }
            base = (base * base) / DECIMALS;
            input /= 2;
        }

        return result;
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