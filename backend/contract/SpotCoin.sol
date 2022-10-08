// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./Strings.sol";

contract SpotCoin {
    int spot_pool = 50000000;
    address owner;

    constructor() {
        owner = msg.sender;
        uint[] memory empty_array;
        string[] memory empty_str;
        // User memory newUser = User(0, "0xf1", "0xf2", 0, empty_array, empty_array, 0, empty_str, );
        // users.push(newUser);
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
        uint transaction_index;
        string[] transaction_keys;
        Transaction[] test_trans;
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
    //
    User[] users;
    //
    mapping(string => uint) private pv_users_map;
    //
    mapping(string => uint) private pb_users_map;
    // public key + _ + index for user to transaction list
    mapping(string => Transaction) transactions;

    // index of user => user obj
    // mapping(uint => User) private users;

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
    function get_user_by_public_key(string memory public_key) public view returns (User memory) {
        if (check_user_exists_pb(public_key))
            {
                User memory user = users[pb_users_map[public_key]];
                user.private_key = "*****";
                return users[pb_users_map[public_key]];
            }

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
     * Get only the current user's history
     */
    function get_user_history(string memory private_key) public view returns (Transaction[] memory) {
        Transaction[] memory user_transactions;
        User memory user = get_user_by_private_key(private_key);
        for (uint index = 0; index < uint(user.transaction_keys.length); index++)
        {
            // user_transactions.push(transactions[user.transaction_keys[index]]);
            user_transactions[index] = transactions[user.transaction_keys[index]];
        }
        return user_transactions;
    }
    //----------------------------------------------------------------------------------------------------------------//
    /**
     * Create a new user.
     */
    function add_new_user(string memory private_key, string memory public_key) public {
        if (!check_user_unique(private_key, public_key)) {
            uint index = users.length;
            // uint[] memory empty_array;
            // string[] memory empty_str;
            // Transaction[] memory temp_trans;

            // User memory new_user = User(index, private_key, public_key, 0, empty_array, empty_array, 0, empty_str, temp_trans);
            User memory new_user;
            new_user.index = index;
            new_user.private_key = private_key;
            new_user.public_key = public_key;

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
            // verify if there are enough coins in pool
            if (spot_pool > amount)
            {
                users[pv_users_map[private_key]].balance += amount;
                spot_pool -= amount;
                Transaction memory transaction = Transaction(block.timestamp, "the SPOT Topup Helper", users[pv_users_map[private_key]].public_key, amount, 
                                                             TransactionType.exchange);


                // string memory user_index_str = string.concat(users[pv_users_map[private_key]].public_key, "_");
                // user_index_str = string.concat(user_index_str, Strings.toString(users[pv_users_map[private_key]].transaction_index));
                // transactions[user_index_str] = transaction;
                // // push the key into the user's list
                // users[pv_users_map[private_key]].transaction_keys[users[pv_users_map[private_key]].transaction_index] = user_index_str;
                users[pv_users_map[private_key]].test_trans.push(transaction);


                // increment current index
                users[pv_users_map[private_key]].transaction_index++;
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
            // format index
            // string memory sender_index_str = (sender_pub + "_" + Strings.toString(sender.transaction_index));
            string memory sender_index_str = string.concat(sender.public_key, "_");
            sender_index_str = string.concat(sender_index_str, Strings.toString(sender.transaction_index));
            // insert transaction at current index
            transactions[sender_index_str] = sender_transaction;
            // push the key into the user's list
            sender.transaction_keys[sender.transaction_index] = sender_index_str;
            // increment current index
            sender.transaction_index++;


            // save receiver transaction
            Transaction memory receiver_transaction = Transaction(block.timestamp, sender_pub, receiver_pub, amount, 
                                                TransactionType.received);
            // format index
            string memory receiver_index_str = string.concat(receiver.public_key, "_");
            receiver_index_str = string.concat(receiver_index_str, Strings.toString(receiver.transaction_index));
            // insert transaction at current index
            transactions[receiver_index_str] = receiver_transaction;
            // push the key into the user's list
            receiver.transaction_keys[receiver.transaction_index] = receiver_index_str;
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
    function create_spot(uint index, string memory private_key, int base_price, string memory image_uri) public {
        if (spots[index].index == 0)
        { // spot doesn't exist
            User memory user = get_user_by_private_key(private_key);
            if (user.balance > base_price)
            { // and the user has enough funds in the account
                
                // create spot and populate object
                Spot storage new_spot = spots[index];
                new_spot.index = index;
                new_spot.current_owner = user.public_key;
                new_spot.owners_chain.push(user.public_key);
                new_spot.base_price = base_price;
                new_spot.current_price = base_price;
                new_spot.decay_rate = 10;
                new_spot.last_reset = block.timestamp;
                new_spot.image_uri = image_uri;

                // adjust user balance
                user.balance -= base_price;
                // update map
                users[pv_users_map[private_key]] = user;
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