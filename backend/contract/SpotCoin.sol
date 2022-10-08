// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SpotCoin {
    int spot_pool = 50000000;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    //----------------------------------------------------------------------------------------------------------------//
    enum TransactionType { exchange, received, sent, spot_creation }
    
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
        uint[] transaction_ids;
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
    mapping(uint => Transaction) global_transactions;
    mapping(uint => Spot) private global_spots;
    //================================================================================================================//
    /**
                                        USER-RELATED FUNCTIONS
    */

    /**
     * Used to check if a user exists by using the private key.
     */
    function check_user_exists_pv(string memory private_key) private view returns (bool){
        if (pv_users_map[private_key] != 0)
            return true;
        else return false;
    }

    /**
     * Used to check if a user exists by using the public key.
     */
    function check_user_exists_pb(string memory public_key) private view returns (bool){
        if (pb_users_map[public_key] != 0)
            return true;
        else return false;
    }

    /**
     * Used only for the creation of a new user to check if both private and public keys are unique.
     */
    function check_user_unique(string memory private_key, string memory public_key) private view returns (bool){
        return check_user_exists_pv(private_key) && check_user_exists_pb(public_key);
    }
    
    function get_user_by_public_key(string memory public_key) public view returns (User memory) {
        if (check_user_exists_pb(public_key))
        {
            return users[pb_users_map[public_key]];
        }
        else revert ("User does not exist");
    }

    function get_user_by_private_key(string memory private_key) private view returns (User memory) {
        if (check_user_exists_pv(private_key))
            return users[pv_users_map[private_key]];
        else revert ("User does not exist");
    }
    /**
     * Get user balance by private key.
     */
    function get_balance(string memory public_key) public view returns (int) {
        if (check_user_exists_pv(public_key)) {
            User memory user = get_user_by_public_key(public_key);
            return user.balance;
        }
        else revert ("User does not exist");
    }

    /**
     * Create a new user.
     */
    function add_new_user(string memory private_key, string memory public_key) public {
        if (!check_user_unique(private_key, public_key)) {
            uint index = users.length;

            User memory new_user = User(index, private_key, public_key, 0, new uint[](0), new uint[](0), new uint[](0));

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
            // verify if there are enough coins in pool
            if (spot_pool > amount)
            {
                users[pv_users_map[private_key]].balance += amount;
                spot_pool -= amount;
                Transaction memory transaction = Transaction(block.timestamp, "the SPOT Topup Helper", users[pv_users_map[private_key]].public_key, amount, 
                                                             TransactionType.exchange);
                global_transactions[users[pv_users_map[private_key]].transaction_ids.length] = transaction;
                users[pv_users_map[private_key]].transaction_ids.push(users[pv_users_map[private_key]].transaction_ids.length);
            }
            else revert ("Not enough coins in pool");
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

            // add the transaction to both users
            Transaction memory transaction = Transaction(block.timestamp, sender.public_key, receiver.public_key, amount, TransactionType.sent);
            global_transactions[sender.transaction_ids.length] = transaction;
            sender.transaction_ids.push(sender.transaction_ids.length);

            transaction = Transaction(block.timestamp, sender.public_key, receiver.public_key, amount, TransactionType.received);
            global_transactions[receiver.transaction_ids.length] = transaction;
            receiver.transaction_ids.push(receiver.transaction_ids.length);

            // store the modified objects
            users[pb_users_map[sender_pub]] = sender;
            users[pb_users_map[receiver_pub]] = receiver;

        }
        else revert ("Not enough money in account");
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
        if (global_spots[index].index == 0)
        { // spot doesn't exist
            User memory user = get_user_by_private_key(private_key);
            if (user.balance > base_price)
            { // and the user has enough funds in the account
                
                // create spot and populate object
                Spot storage new_spot = global_spots[index];
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
                // add y=transaction to user
                Transaction memory transaction = Transaction(block.timestamp, user.public_key, "the SPOT Creator", base_price, TransactionType.spot_creation);
                global_transactions[user.transaction_ids.length] = transaction;
                user.transaction_ids.push(user.transaction_ids.length);

                // store the modified objects
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