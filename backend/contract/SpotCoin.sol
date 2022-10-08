// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SpotCoin {
    int spot_pool = 50000000;
    address owner;
    
    constructor() {
        owner = msg.sender;
        User memory user = User(users.length, "pv", "pb", 0, new uint[](0), new uint[](0), new uint[](0));
        users.push(user);
        
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    //----------------------------------------------------------------------------------------------------------------//
    // 1. SpotCoin
    enum TransactionType { exchange, received, sent, spot_creation, spot_purchase, spot_sale, transfer }
    
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
    // Mapping
    User[] users;
    mapping(string => uint) private pv_users_map;
    mapping(string => uint) private pb_users_map;
    mapping(uint => Transaction) global_transactions;
    mapping(uint => Spot) private global_spots;

    uint last_id_transaction = 0;
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
    /**
     * Used to create a new user.
     */
    function get_user_by_public_key(string memory public_key) public view returns (User memory) {
        // check if usr exists and  return user
        if (check_user_exists_pb(public_key))
            return users[pb_users_map[public_key]];
        else revert("User does not exist");
    }
    /**
     * Used to create a new user.
     */
    function get_user_by_private_key(string memory private_key) private view returns (User memory) {
        if (check_user_exists_pv(private_key))
            return users[pv_users_map[private_key]];
        else revert ("User does not exist");
    }
    /**
     * Get user balance by private key.
     */
    function get_balance(string memory public_key) public view returns (int) {
        // get user balance by public key
        if (check_user_exists_pb(public_key))
            return get_user_by_public_key(public_key).balance;
        else revert ("User does not exist");
    }
    /**
     * Get user balance by private key.
     */
    function get_transactions_for_user(string memory private_key) public view returns (Transaction[] memory) {
        // get all the transactions for the user by private key
        if (check_user_exists_pv(private_key)) {
            User memory user = get_user_by_private_key(private_key);
            Transaction[] memory transactions = new Transaction[](user.transaction_ids.length);
            for (uint i = 0; i < user.transaction_ids.length; i++) {
                transactions[i] = global_transactions[user.transaction_ids[i]];
            }
            return transactions;
        }
        else revert ("User does not exist");
    }
    /**
     * Create a new user.
     */
    function add_new_user(string memory private_key, string memory public_key) public {
        if (!check_user_unique(private_key, public_key)) {
            User memory user = User(users.length, private_key, public_key, 0, new uint[](0), new uint[](0), new uint[](0));
            pv_users_map[private_key] = users.length;
            pb_users_map[public_key] = users.length;

            users.push(user);
        } 
        else revert ("User already exists");
    }

    // debug functions
    function get_users_length() public view returns (uint) {
        return users.length;
    }

    function get_last_transaction() public view returns (Transaction memory) {
        if (last_id_transaction == 0)
            revert("No transactions yet");

        return global_transactions[last_id_transaction-1];
    }
    //----------------------------------------------------------------------------------------------------------------//
    function log_transaction(string memory sender, string memory receiver, int amount, TransactionType transaction_type) private {
        Transaction memory transaction = Transaction(block.timestamp, sender, receiver, amount, transaction_type);
        global_transactions[last_id_transaction] = transaction;
        last_id_transaction++;
    }
    
    /**
     * Add money into account
     */
    function add_money(string memory private_key, int amount) public {
        if (check_user_exists_pv(private_key))
        {
            // verify if there are enough coins in pool
            if (spot_pool >= amount)
            {
                users[pv_users_map[private_key]].balance += amount;
                spot_pool -= amount;
                Transaction memory transaction = Transaction(block.timestamp, "the SPOT Topup Helper", users[pv_users_map[private_key]].public_key, amount, 
                                                             TransactionType.exchange);

                users[pv_users_map[private_key]].transaction_ids.push(last_id_transaction);
                global_transactions[last_id_transaction] = transaction;
                last_id_transaction++;
                
                }
            else revert ("Not enough coins in pool");
        }
    }
    //----------------------------------------------------------------------------------------------------------------//
    /**
     * Transfer money from one user to another
     */
    function transfer_money(string memory sender_pv, string memory receiver_pb, int amount) public {
        uint user_sender_id = pv_users_map[sender_pv];
        uint user_receiver_id = pb_users_map[receiver_pb];

        if (users[user_sender_id].balance > amount)
        {
            // adjust the balance of both users
            users[user_sender_id].balance -= amount;
            users[user_receiver_id].balance += amount;

            // add the transaction to both users
            users[user_sender_id].transaction_ids.push(last_id_transaction);
            users[user_receiver_id].transaction_ids.push(last_id_transaction);
            Transaction memory transaction = Transaction(block.timestamp, users[user_sender_id].public_key, users[user_receiver_id].public_key, amount, 
                                                         TransactionType.transfer);
            global_transactions[last_id_transaction] = transaction;
            last_id_transaction++;
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
    // function create_spot(uint index, string memory private_key, int base_price, string memory image_uri) public {
    //     if (global_spots[index].index == 0)
    //     { // spot doesn't exist
    //         User memory user = get_user_by_private_key(private_key);
    //         if (user.balance > base_price)
    //         { // and the user has enough funds in the account
                
    //             // create spot and populate object
    //             Spot storage new_spot = global_spots[index];
    //             new_spot.index = index;
    //             new_spot.current_owner = user.public_key;
    //             new_spot.owners_chain.push(user.public_key);
    //             new_spot.base_price = base_price;
    //             new_spot.current_price = base_price;
    //             new_spot.decay_rate = 10;
    //             new_spot.last_reset = block.timestamp;
    //             new_spot.image_uri = image_uri;

    //             // adjust user balance
    //             user.balance -= base_price;
    //             // add y=transaction to user
    //             Transaction memory transaction = Transaction(block.timestamp, user.public_key, "the SPOT Creator", base_price, TransactionType.spot_creation);
    //             global_transactions[user.transaction_ids.length] = transaction;
    //             user.transaction_ids[user.transaction_ids.length] = user.transaction_ids.length;

    //             // store the modified objects
    //             users[pv_users_map[private_key]] = user;
    //         }
    //         else revert ("Not enough funds");  
    //     }
    //     else revert ("Spot already exists");
    // }
    // //----------------------------------------------------------------------------------------------------------------//
    // /**
    //  * Get all the spots for a user
    //  */
    // function get_all_spots_owned_by_user(string memory private_key) public view returns (Spot[] memory) {
    //     User memory user = get_user_by_private_key(private_key);
    //     Spot[] memory spots = new Spot[](user.owned_spots.length);
    //     for (uint i = 0; i < user.owned_spots.length; i++) {
    //         spots[i] = global_spots[user.owned_spots[i]];
    //     }
    //     return spots;
    // }
    // //----------------------------------------------------------------------------------------------------------------//
    // /**
    //  * Get a spot by index
    //  */
    // function get_spot(uint index) public view returns (Spot memory) {
    //     return global_spots[index];
    // }
    // //----------------------------------------------------------------------------------------------------------------//
    // function buy_spot(uint index, string memory private_key) public {
    //     User memory user = get_user_by_private_key(private_key);
    //     Spot storage spot = global_spots[index];
    //     if (user.balance > spot.current_price)
    //     {
    //         // adjust the balance of both users
    //         user.balance -= spot.current_price;
    //         User memory old_owner = get_user_by_public_key(spot.current_owner);
    //         old_owner.balance += spot.current_price;

    //         // add the transaction to both users
    //         Transaction memory transaction = Transaction(block.timestamp, user.public_key, old_owner.public_key, spot.current_price, TransactionType.spot_purchase);
    //         global_transactions[user.transaction_ids.length] = transaction;
    //         user.transaction_ids[user.transaction_ids.length] = user.transaction_ids.length;

    //         transaction = Transaction(block.timestamp, user.public_key, old_owner.public_key, spot.current_price, TransactionType.spot_sale);
    //         global_transactions[old_owner.transaction_ids.length] = transaction;
    //         old_owner.transaction_ids[old_owner.transaction_ids.length] = old_owner.transaction_ids.length;

    //         // store the modified objects
    //         users[pv_users_map[private_key]] = user;
    //         users[pb_users_map[spot.current_owner]] = old_owner;

    //         // adjust the spot
    //         spot.current_owner = user.public_key;
    //         spot.owners_chain.push(user.public_key);
    //         spot.current_price = spot.base_price;
    //         spot.last_reset = block.timestamp;

    //         // store the modified spot
    //         global_spots[index] = spot;
    //     }
    //     else revert ("Not enough money in account");
    // }
    //----------------------------------------------------------------------------------------------------------------//
    //----------------------------------------------------------------------------------------------------------------//
    // spot pool-related functions
    function get_spot_amount() public view returns (int, uint) {
        return (spot_pool, users.length-1);
    }
    //================================================================================================================//
}