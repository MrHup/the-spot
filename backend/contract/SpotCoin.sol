// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
/**
 * @title SpotCoin
 */
contract SpotCoin {
    int spot_pool = 50000000;
    address owner;
    
    constructor() {
        owner = msg.sender;
        User memory user = User(users.length, "pv", "pb", 0, new uint[](0), new uint[](0), new uint[](0));
        users.push(user);
        
    }
    //----------------------------------------------------------------------------------------------------------------//
    // 1. SpotCoin
    enum TransactionType { exchange, received, sent, spot_creation, spot_sale, transfer }
    
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
        string name;
        string image_uri;
        string current_owner;
        string[] owners_chain;
        int base_price;
        int current_price;
        int decay_rate;
        uint last_reset_time;
    }

    struct SimpleSpot {
        uint index;
        string name;
        string image_uri;
        string current_owner;
        int current_price;
    }
    //----------------------------------------------------------------------------------------------------------------//
    // Mapping
    User[] users;
    mapping(string => uint) private pv_users_map;
    mapping(string => uint) private pb_users_map;
    mapping(uint => Transaction) global_transactions;
    mapping(uint => Spot) private global_spots;

    uint last_id_transaction = 0;
    uint last_id_spot = 0;
    //================================================================================================================//
    /**
     *                                      SPOT-POOL FUNCTIONS
     */ 
    //----------------------------------------------------------------------------------------------------------------//
    /**
     * @dev Get the current spot pool balance
     */
    function get_spot_amount() public view returns (int, uint) {
        return (spot_pool, users.length-1);
    }
    //================================================================================================================//
    /**
                                        USER-RELATED FUNCTIONS
    */
    //----------------------------------------------------------------------------------------------------------------//
    /**
     * Login a user with his private key
     */
    function login_user_by_pv(string memory private_key) public view returns (string memory, string memory, 
                              int, uint[] memory, uint[] memory, uint[] memory) {
        if (check_user_exists_pv(private_key))
        {
            uint user_id = pv_users_map[private_key];
            User memory user = users[user_id];
            return (user.private_key, user.public_key, user.balance, user.owned_spots, user.created_spots, user.transaction_ids);
        }
        else revert ("User does not exist");
    }
    //----------------------------------------------------------------------------------------------------------------//
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
    //----------------------------------------------------------------------------------------------------------------//
    /**
     * Used to create a new user.
     */
    // #TODO: covert to private
    function get_user_by_public_key(string memory public_key) public view returns (User memory) {
        // check if usr exists and  return user
        if (check_user_exists_pb(public_key))
            return users[pb_users_map[public_key]];
        else revert("User does not exist");
    }
    /**
     * Used to create a new user.
     */
    function get_user_by_private_key(string memory private_key) public view returns (User memory) {
        if (check_user_exists_pv(private_key))
            return users[pv_users_map[private_key]];
        else revert ("User does not exist");
    }
    /**
     * Get user balance by public key.
     */
    function get_balance(string memory public_key) public view returns (int) {
        // get user balance by public key
        if (check_user_exists_pb(public_key))
            return get_user_by_public_key(public_key).balance;
        else revert ("User does not exist");
    }
    /**
     * Get user transactions by private key.
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
    //----------------------------------------------------------------------------------------------------------------//
    // // debug functions
    // // #TODO: covert to private
    // function get_users_length() public view returns (uint) {
    //     return users.length;
    // }
    // function get_user_by_index(uint index) public view returns (User memory) {
    //     return users[index];
    // }  
    // function get_last_transaction() public view returns (Transaction memory) {
    //     if (last_id_transaction == 0)
    //         revert("No transactions yet");

    //     return global_transactions[last_id_transaction-1];
    // }
    //----------------------------------------------------------------------------------------------------------------//
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
    //----------------------------------------------------------------------------------------------------------------//
    function log_transaction(string memory sender, string memory receiver, int amount, 
                             TransactionType transaction_type) private {
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
                users[pv_users_map[private_key]].transaction_ids.push(last_id_transaction);
                log_transaction("the SPOT Topup Helper", users[pv_users_map[private_key]].public_key, amount, 
                                TransactionType.exchange);
                }
            else revert ("Not enough coins in pool");
        }
    }
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
            log_transaction(users[user_sender_id].public_key, users[user_receiver_id].public_key, amount, 
                            TransactionType.transfer);
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
    function create_new_spot(string memory spot_name, string memory spot_image, string memory owner_pv, 
                             int spot_price) public {
        if (check_user_exists_pv(owner_pv))
        {
            string[] memory owners_chain = new string[](1);
            owners_chain[0] = users[pv_users_map[owner_pv]].public_key;
            // create a new spot
            Spot memory spot = Spot(last_id_spot, spot_name, spot_image, users[pv_users_map[owner_pv]].public_key, 
                                    owners_chain, spot_price, spot_price, 10, block.timestamp);
            global_spots[last_id_spot] = spot;

            // add the spot to the owner
            users[pv_users_map[owner_pv]].balance -= spot_price;
            spot_pool += spot_price;
            users[pv_users_map[owner_pv]].created_spots.push(last_id_spot);
            users[pv_users_map[owner_pv]].owned_spots.push(last_id_spot);
            last_id_spot++;
            
            // log this transaction
            users[pv_users_map[owner_pv]].transaction_ids.push(last_id_transaction);
            log_transaction(users[pv_users_map[owner_pv]].public_key, "the SPOT Creator", spot_price, 
                            TransactionType.spot_creation);            
        }
        else revert ("User does not exist");
    }
    //----------------------------------------------------------------------------------------------------------------//
    /**
     * Convert a Spot to a SimpleSpot
     */
    function convert_spot_to_simple_spot(Spot memory spot) private pure returns (SimpleSpot memory) {
        return SimpleSpot(spot.index, spot.name, spot.image_uri, spot.current_owner, spot.current_price);
    }
    /**
     * Get a spot by index
     */    
    function get_spot_by_index(uint index) public view returns (SimpleSpot memory) {
        return convert_spot_to_simple_spot(global_spots[index]);
    }    
    /**
     * Get all spots
     */
    function get_all_spots() public view returns (SimpleSpot[] memory) {
        SimpleSpot[] memory spots = new SimpleSpot[](last_id_spot);
        for (uint i = 0; i < last_id_spot; i++) {
            spots[i] = convert_spot_to_simple_spot(global_spots[i]);
        }
        return spots;
    }
    /**
     * Get all the spots owned by a user
     */
    function get_all_spots_owned_by_user(string memory private_key) public view returns (SimpleSpot[] memory) {
        User memory user = get_user_by_private_key(private_key);
        SimpleSpot[] memory spots = new SimpleSpot[](user.owned_spots.length);
        for (uint i = 0; i < user.owned_spots.length; i++) {
            spots[i] = convert_spot_to_simple_spot(global_spots[user.owned_spots[i]]);
        }
        return spots;
    }
    /**
     * Get all the spots created by a user
     */
    function get_all_spots_created_by_user(string memory private_key) public view returns (SimpleSpot[] memory) {
        User memory user = get_user_by_private_key(private_key);
        SimpleSpot[] memory spots = new SimpleSpot[](user.created_spots.length);
        for (uint i = 0; i < user.created_spots.length; i++) {
            spots[i] = convert_spot_to_simple_spot(global_spots[user.created_spots[i]]);
        }
        return spots;
    }
    //----------------------------------------------------------------------------------------------------------------//
    /**
     * Check if a spot exists
     */
    function check_spot_exists(uint spot_id) private view returns (bool) {
        if (spot_id < last_id_spot)
            return true;
        else return false;
    }
    function calcualate_hotness_factor(int chain_length, int spot_base_price) private pure returns (int) {
        int hotness_factor = 0;
        for (int i = 1; i <= chain_length; i++) {
            hotness_factor += spot_base_price * 10 * (i - 1) / 100;
        }
        return hotness_factor;
    }
    // #TODO: covert to private
    // function get_spot_chain_lenght(uint spot_id) private view returns (int) {
    //     return int(global_spots[spot_id].owners_chain.length);
    // }
    // function DEBUG_create_users() public {
    //     // create 3 users
    //     add_new_user("pv1", "pb1");
    //     add_new_user("pv2", "pb2");
    //     add_new_user("pv3", "pb3");
    //     add_new_user("pv4", "pb4");

    //     // add money to the debug users
    //     add_money("pv1", 1000);
    //     add_money("pv2", 1000);
    //     add_money("pv3", 1000);
    //     add_money("pv4", 1000);

    //     // create 1 spot
    //     create_new_spot("spot1", "img1", "pv1", 100);
    // }

    // function DEBUG_get_current_price() public view returns (int) {
    //     Spot memory spot = get_spot(0);
    //     return int(spot.current_price);
    // }

    // function DEBUG_get_spot_owner() public view returns (string memory) {
    //     Spot memory spot = get_spot(0);
    //     return spot.current_owner;
    // }

    // function DEBUG_get_spot_owners_chain() public view returns (string[] memory) {
    //     Spot memory spot = get_spot(0);
    //     return spot.owners_chain;
    // }

    // function DEBUG_get_pv1_balance() public view returns (int) {
    //     User memory user = get_user_by_private_key("pv1");
    //     return user.balance;
    // }
    // // get pv2 balance
    // function DEBUG_get_pv2_balance() public view returns (int) {
    //     User memory user = get_user_by_private_key("pv2");
    //     return user.balance;
    // }
    // // get pv3 balance
    // function DEBUG_get_pv3_balance() public view returns (int) {
    //     User memory user = get_user_by_private_key("pv3");
    //     return user.balance;
    // }
    // // get pv4 balance
    // function DEBUG_get_pv4_balance() public view returns (int) {
    //     User memory user = get_user_by_private_key("pv4");
    //     return user.balance;
    // }

    // function DEBUG_buy_spot() public {
    //     buy_spot("pv2", 0);
    //     buy_spot("pv3", 0);
    //     buy_spot("pv4", 0);
    // }
    /**
     * Buy a spot
     */
    function buy_spot(string memory buyer_pv, uint spot_id) public {
        if (check_user_exists_pv(buyer_pv))
        { // if the user exists
            if (check_spot_exists(spot_id))
            { // if the spot exists
                if (users[pv_users_map[buyer_pv]].balance > global_spots[spot_id].current_price)
                { // if the user has enough money

                    // adjust the balance of the buyer
                    users[pv_users_map[buyer_pv]].balance -= global_spots[spot_id].current_price;
                    // add the transaction id to the buyer
                    users[pv_users_map[buyer_pv]].transaction_ids.push(last_id_transaction);
                    // log the transaction via the log_transaction function
                    log_transaction(users[pv_users_map[buyer_pv]].public_key, "Owners chain", 
                                    global_spots[spot_id].current_price, TransactionType.spot_sale);


                    // transfer 20%*base_price to the first owner in the chain
                    users[pb_users_map[global_spots[spot_id].owners_chain[0]]].balance += global_spots[spot_id].base_price * 20 / 100;
                    // add the transaction id to the first owner in the chain
                    users[pb_users_map[global_spots[spot_id].owners_chain[0]]].transaction_ids.push(last_id_transaction);
                    // log the transaction via the log_transaction function
                    log_transaction("Owners chain", users[pb_users_map[global_spots[spot_id].owners_chain[0]]].public_key, 
                                    global_spots[spot_id].base_price * 20 / 100, TransactionType.spot_sale);


                    // transfer 80$*base_price to the last owner in chain
                    users[pb_users_map[global_spots[spot_id].owners_chain[global_spots[spot_id].owners_chain.length - 1]]].balance 
                            += global_spots[spot_id].base_price * 80 / 100;
                    // add the transaction id to the last owner in the chain
                    users[pb_users_map[global_spots[spot_id].owners_chain[global_spots[spot_id].owners_chain.length - 1]]].transaction_ids.push(last_id_transaction);
                    // log the transaction via the log_transaction function
                    log_transaction("Owners chain", users[pb_users_map[global_spots[spot_id].owners_chain[global_spots[spot_id].owners_chain.length - 1]]].public_key, 
                                    global_spots[spot_id].base_price * 80 / 100, TransactionType.spot_sale);

                    // distribute the commisions to the owners chain
                    uint chain_length = global_spots[spot_id].owners_chain.length;
                    for (uint i = 0; i < chain_length; i++) 
                    {
                        int commission = global_spots[spot_id].base_price * 10 * (int(chain_length) - (int(i) + 1)) / 100;
                        users[pb_users_map[global_spots[spot_id].owners_chain[i]]].balance += commission;

                        // add the transaction id to the current owner in the chain
                        users[pb_users_map[global_spots[spot_id].owners_chain[i]]].transaction_ids.push(last_id_transaction);
                        // log the transaction via the log_transaction function
                        log_transaction("Owners chain", users[pb_users_map[global_spots[spot_id].owners_chain[i]]].public_key, 
                                        commission, TransactionType.spot_sale);
                    }

                    // change the current owner to the buyer
                    global_spots[spot_id].current_owner = users[pv_users_map[buyer_pv]].public_key;
                    // add the buyer to the owners chain
                    global_spots[spot_id].owners_chain.push(users[pv_users_map[buyer_pv]].public_key);

                    // update the current price of the spot to be the last price + hotness factor returned by function
                    global_spots[spot_id].current_price += 
                        calcualate_hotness_factor(int(global_spots[spot_id].owners_chain.length), global_spots[spot_id].base_price);



                }
                else revert ("Not enough money in account");
            }
            else revert ("Spot does not exist");
        }
        else revert ("User does not exist");
    }
    /**
     * Update the image of a spot
     */
    function update_spot_image(uint spot_id, string memory image_uri, string memory owner_pv) public {
        if (check_spot_exists(spot_id))
        {
            if (check_user_exists_pv(owner_pv))
            {
                
                // compare two strings
                if (keccak256(abi.encodePacked(global_spots[spot_id].current_owner)) == 
                    keccak256(abi.encodePacked(users[pv_users_map[owner_pv]].public_key)))
                {
                    global_spots[spot_id].image_uri = image_uri;
                }
                else revert ("You are not the owner of this spot");
            }
            else revert ("User does not exist");
        }
        else revert ("Spot does not exist");
    }
    //================================================================================================================//
}