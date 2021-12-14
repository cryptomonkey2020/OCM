// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import 1155 token contract from Openzeppelin
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

// Example contract to be deployed via https://remix.ethereum.org/ for testing purposes.

contract NFTContract is ERC1155, Ownable {
    using SafeMath for uint256;
    uint256[] graves = [50, 100, 200]; //can mint 50 of grave 1, 100 of grave 2, 200 of grave 3 .. for unlimited amount .. -1
    uint256[] minted = [0, 0, 0];
    uint256[] rates = [0.05 ether, 0.1 ether, 0.025 ether]; //Prices, ofcourse it can be non payable function without a price for minting


    constructor()
        ERC1155(
            "https://ipfs.moralis.io:2053/ipfs/QmVsvJ7bUhETUsLbefqiKk5ShBykLsuzcGaho5zdSFPyr4/metadata/{id}.json" // Moralis server instance.
                                                                                                                 // Json metadata file craeted using https://github.com/ashbeech/moralis-mutants-nft-engine
        )
    {
        // account, token_id, number
        //_mint(msg.sender, 1, 1, "");
    }

    function mint(uint256 id, uint256 amount) public payable  {

        require(id <= graves.length, "Token doesn't exist");
        require(id > 0, "Token doesn't exist");
        uint256 index = id -1;
        require(minted[index] + amount <= graves[index] , "Not enough supply"); 
        require( msg.value >= amount * rates[index], "Not enough supply");
        _mint(msg.sender, id, amount, "Grave");
        minted[index] += amount;

    }
    function withdraw() public onlyOwner{
        require(address(this).balance > 0, " balance is 0");
        payable(owner()).transfer(address(this).balance);
    
    }

}
