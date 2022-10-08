// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SpotCoin {
    int spot_pool = 50000000;
    address owner;

    constructor() {
        owner = msg.sender;
        uint[] memory empty_array;
        User memory newUser = User(0, "0xf1", "0xf2", 0, empty_array, empty_array);
        users.push(newUser);
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    //----------------------------------------------------------------------------------------------------------------//
    struct User {
        uint index;
        string private_key;
        string public_key;
        int balance;
        uint[] owned_spots;
        uint[] created_spots;
    }

    struct Spot {
        uint index;
        string current_owner;
        string[] owners_chain;
        int base_price;
        int current_price;
        int decay_rate;
        uint last_reset;
        string image_uri;
    }
    //----------------------------------------------------------------------------------------------------------------//
    User[] users;
    mapping(string => uint) private pv_users_map;
    mapping(string => uint) private pb_users_map;

    // owner_of_the_spot => spot_index
    mapping(uint => Spot) private spots;
    //================================================================================================================//
    /**
                                        USER-RELATED FUNCTIONS
    */
    //----------------------------------------------------------------------------------------------------------------//
    /**
     * Used to check if a user exists by using the private key.
     */
    function check_user_exists_pv(string memory private_key) private view returns (bool){
        if (pv_users_map[private_key] != 0)
            return true;
        else return false;
    }
    //----------------------------------------------------------------------------------------------------------------//
    /**
     * Used to check if a user exists by using the public key.
     */
    function check_user_exists_pb(string memory public_key) private view returns (bool){
        if (pb_users_map[public_key] != 0)
            return true;
        else return false;
    }
    //----------------------------------------------------------------------------------------------------------------//
    /**
     * Used only for the creation of a new user to check if both private and public keys are unique.
     */
    function check_user_unique(string memory private_key, string memory public_key) private view returns (bool){
        if (pv_users_map[private_key] != 0 || pb_users_map[public_key] != 0)
            return true;
        else return false;
    }
    //----------------------------------------------------------------------------------------------------------------//
    function get_user_by_public_key(string memory public_key) private view returns (User memory) {
        if (check_user_exists_pb(public_key))
            return users[pb_users_map[public_key]];
        else revert ("User does not exist");
    }
    //----------------------------------------------------------------------------------------------------------------//
    // login
    function get_user_by_private_key(string memory private_key) private view returns (User memory) {
        if (check_user_exists_pv(private_key))
            return users[pv_users_map[private_key]];
        else revert ("User does not exist");
    }
    //----------------------------------------------------------------------------------------------------------------//
    /**
     * Get user balance by private key.
     */
    function get_balance(string memory private_key) onlyOwner public view returns (int) {
        if (check_user_exists_pv(private_key)) {
            User memory user = get_user_by_private_key(private_key);
            return user.balance;
        }
        else revert ("User does not exist");
    }
    //----------------------------------------------------------------------------------------------------------------//
    /**
     * Create a new user.
     */
    function add_new_user(string memory private_key, string memory public_key) public {
        if (!check_user_unique(private_key, public_key)) {
            uint index = users.length;
            uint[] memory empty_array;

            User memory new_user = User(index, private_key, public_key, 0, empty_array, empty_array);

            pv_users_map[private_key] = index;
            pb_users_map[public_key] = index;

            users.push(new_user);
        } 
        else revert ("User already exists");
    }
    //----------------------------------------------------------------------------------------------------------------//
    /**
     * Add money into account
     */
    function add_money(string memory private_key, int amount) public {
        if (check_user_exists_pv(private_key))
        {
            User memory user = get_user_by_private_key(private_key);
            user.balance += amount;
            users[pv_users_map[private_key]] = user;
        }
    }
    //----------------------------------------------------------------------------------------------------------------//
    /**
     * Transfer money from one user to another
     */
    function transfer_money(string memory sender_pub, string memory receiver_pub, int amount) public {
        User memory sender = get_user_by_public_key(sender_pub);
        User memory receiver = get_user_by_public_key(receiver_pub);

        sender.balance -= amount;
        receiver.balance += amount;

        users[pb_users_map[sender_pub]] = sender;
        users[pb_users_map[receiver_pub]] = receiver;
    }  
    //================================================================================================================//
    /**
     *                                           SPOT-RELATED FUNCTION
     */
    //----------------------------------------------------------------------------------------------------------------//
    /**
     * Create a new spot
     */
    function create_spot(uint index, string memory public_key, int base_price, string memory image_uri) private {
        if (spots[index].index == 0)
        { // spot doesn't exist
            Spot storage new_spot = spots[index];
            new_spot.index = index;
            new_spot.current_owner = public_key;
            new_spot.owners_chain.push(public_key);
            new_spot.base_price = base_price;
            new_spot.current_price = base_price;
            new_spot.decay_rate = 10;
            new_spot.last_reset = block.timestamp;
            new_spot.image_uri = image_uri;
        }
    }
    //----------------------------------------------------------------------------------------------------------------//
    // spot pool-related functions
    function get_spot_amount() public view returns (int, uint) {
        return (spot_pool, users.length - 1);
    }
    //================================================================================================================//
}