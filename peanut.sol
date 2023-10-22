// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Peanut {
    
    struct Creator {
        string name;
        string description;
        string githubURL;
        address payable wallet;
    }

    event CreatorLog(string name, string description, string githubURL, address indexed wallet);
    event RewardLog(address indexed donor, address indexed creator, uint256 indexed amount);

    Creator[] private creators;

    function createAccount(string memory _name, string memory _description, string memory _githubURL) public {
        creators.push(Creator(_name, _description, _githubURL, payable(msg.sender)));
        emit CreatorLog(_name, _description, _githubURL, msg.sender);
    }

    function creatorsNumber() public view returns (uint) {
        return creators.length;
    }

    function creatorById(uint _id) public view returns (string memory, string memory, string memory description) {
        return(creators[_id].name, creators[_id].githubURL, creators[_id].description);
    }

    function rewardCreatorById(uint _id) public payable {
        require(msg.value > 0, "ETH amount must be greater then 0");
        require(msg.sender != creators[_id].wallet, "Creator cannot send ETH to itself");
        (bool sent, bytes memory data) = creators[_id].wallet.call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        emit RewardLog(msg.sender, creators[_id].wallet, msg.value);
    }
}