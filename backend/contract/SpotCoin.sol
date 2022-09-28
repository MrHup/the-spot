// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SpotCoin {
    int spot_pool = 50000000;
    address owner;

    constructor() {
        owner = msg.sender;
        User memory newUser = User("0xf1", 0, 0, 0);
        users.push(newUser);
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    struct User {
        string private_key;
        int public_key;
        int balance;
        uint index;
    }
    
    User[] users;
    mapping(string => uint) private pv_users_map;
    mapping(int => uint) private pb_users_map;

    // user-related functions
    function checkUserExists(string memory private_key) private view returns (bool){
        if (pv_users_map[private_key] != 0)
            return true;
        else return false;
    }

    function getUserByPublicKey(int public_key) private view returns (User memory) {
        return users[pb_users_map[public_key]];
    }

    function getUserByPrivateKey(string memory private_key) private view returns (User memory) {
        return users[pv_users_map[private_key]];
    }

    function getUser(string memory private_key) public view returns (User memory) {
        User memory user = getUserByPrivateKey(private_key);

        if (checkUserExists(private_key))
            return user;
        else revert ("User does not exist");
    }

    function addNewUser(string memory private_key, int public_key) public {
        if (!checkUserExists(private_key)) {
            uint index = users.length;

            User memory newUser = User(private_key, public_key, 0, index);

            pv_users_map[private_key] = index;
            pb_users_map[public_key] = index;

            users.push(newUser);
        } 
        else revert ("User already exists");
    }

    // spot pool-related functions
    function getBalance(int public_key) onlyOwner public view returns (int) {
        User memory user = getUserByPublicKey(public_key);

        if (checkUserExists(user.private_key))
            return user.balance;
        else revert ("User does not exist");
    }

    function getSpotAmount() public view returns (int, uint) {
        return (spot_pool, users.length - 1);
    }
}