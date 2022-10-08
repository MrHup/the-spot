// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SpotCoin {
    int spot_pool = 50000000;
    address owner;
    string owner_address;

    constructor() {
        owner = msg.sender;
        owner_address = "0xA80Ae73E9408496AB1230EEdD72440e4d35C79fD";
        uint[] memory empty_array;
        Transaction[] memory empty_history;
        User memory newUser = User(0, "0xf1", "0xf2", 0, empty_array, empty_array, empty_history, 0);
        users.push(newUser);
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    //----------------------------------------------------------------------------------------------------------------//
    enum TransactionType { exchange, received, sent }
    
    struct Transaction {
        uint timestamp;
        string sender;
        string receiver;
        int amount;
        TransactionType transaction_type;
    }
    
    struct User {
        uint index;
        string private_key;
        string public_key;
        int balance;
        uint[] owned_spots;
        uint[] created_spots;
        Transaction[] transaction_history;
        uint transaction_index;
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
            Transaction[] memory transaction_history;

            User memory new_user = User(index, private_key, public_key, 0, empty_array, empty_array, 
                                        transaction_history, 0);
            users.push(new_user);

            pv_users_map[private_key] = index;
            pb_users_map[public_key] = index;

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
            // verify if there are enough coins in pool
            if (spot_pool > amount)
            {
                user.balance += amount;
                spot_pool -= amount;
                Transaction memory transaction = Transaction(block.timestamp, owner_address, user.public_key, amount, 
                                                             TransactionType.exchange);
                // insert transaction at current index
                user.transaction_history[user.transaction_index] = transaction;
                // increment current index
                user.transaction_index++;
                users[pv_users_map[private_key]] = user;
            }
            else revert ("Not enough TSPOT coins in pool!");
        }
    }
    //----------------------------------------------------------------------------------------------------------------//
    /**
     * Transfer money from one user to another
     */
    function transfer_money(string memory sender_pub, string memory receiver_pub, int amount) public {
        User memory sender = get_user_by_public_key(sender_pub);
        User memory receiver = get_user_by_public_key(receiver_pub);

        if (sender.balance > amount)
        {
            // adjust the balance of both users
            sender.balance -= amount;
            receiver.balance += amount;


            // save sender transaction
            Transaction memory sender_transaction = Transaction(block.timestamp, sender_pub, receiver_pub, amount, 
                                                            TransactionType.sent);
            // insert transaction at current index
            sender.transaction_history[sender.transaction_index] = sender_transaction;
            // increment current index
            sender.transaction_index++;


            // save receiver transaction
            Transaction memory receiver_transaction = Transaction(block.timestamp, sender_pub, receiver_pub, amount, 
                                                TransactionType.received);
            // insert transaction at current index
            receiver.transaction_history[receiver.transaction_index] = receiver_transaction;
            // increment current index
            receiver.transaction_index++;


            // store the modified objects
            users[pb_users_map[sender_pub]] = sender;
            users[pb_users_map[receiver_pub]] = receiver;
        }
        else
        {
            return revert ("Not enough funds!");
        }
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
            User memory user = get_user_by_public_key(public_key);
            if (user.balance > base_price)
            { // and the user has enough funds in the account
                
                // create spot and populate object
                Spot storage new_spot = spots[index];
                new_spot.index = index;
                new_spot.current_owner = public_key;
                new_spot.owners_chain.push(public_key);
                new_spot.base_price = base_price;
                new_spot.current_price = base_price;
                new_spot.decay_rate = 10;
                new_spot.last_reset = block.timestamp;
                new_spot.image_uri = image_uri;

                // adjust user balance
                user.balance -= base_price;
                // update map
                users[pb_users_map[public_key]] = user;
            }
            else revert ("Not enough funds");            
        }
        else revert ("Spot already exists");
    }
    //----------------------------------------------------------------------------------------------------------------//
    // spot pool-related functions
    function get_spot_amount() public view returns (int, uint) {
        return (spot_pool, users.length - 1);
    }
    //================================================================================================================//
}