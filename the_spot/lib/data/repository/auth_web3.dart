import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/data/models/static_user.dart';
import 'package:the_spot/data/repository/generate_key.dart';
import 'package:the_spot/data/repository/popups.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

const String rpcUrl = 'https://testnet-rpc.coinex.net';
final EthereumAddress contractAddr =
    EthereumAddress.fromHex('0xec8D81dbc887E37EcE65D1b45f4358618d5D1bAF');
const String _privateKey =
    "0x0503d85eaf557849e40c4a7e6895aa2f6764c26af04fd02a36f5d0f3fa3954fc";

Future<String> registerUser(String privateKey, String publicKey) async {
  try {
    final client = Web3Client(rpcUrl, Client());
    final abiCode = await rootBundle.loadString('assets/abi.json');

    final credentials = await client.credentialsFromPrivateKey(_privateKey);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

    final createUserFunction = contract.function('add_new_user');

    await client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: createUserFunction,
          parameters: [privateKey, publicKey],
        ),
        chainId: 53);

    await client.dispose();
    showSimpleToast("Registered succesfully");
    return privateKey;
  } catch (e) {
    print("<<<flavius_debug>>> Error on registerUser");
    print(e);
    showSimpleToast("Error while registering");
    return "";
  }
}

void attemptRegister(
    BuildContext context, String privateKey, String publicKey) async {
  blockUser(context);

  String? pv = await registerUser(privateKey, publicKey);
  Navigator.pop(context);

  if (pv != null && pv != "") {
    GlobalVals.currentUser.privateKey = pv;
    // save hash to persistent storage
    var persistentStorage = await Hive.openBox('userData');
    persistentStorage.put("privateKey", privateKey);
    Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
  }
}

Future<CurrentUser> loginUser(String privateKey) async {
  try {
    final client = Web3Client(rpcUrl, Client());
    final abiCode = await rootBundle.loadString('assets/abi.json');

    final credentials = await client.credentialsFromPrivateKey(_privateKey);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);
    final createUserFunction = contract.function('login_user_by_pv');

    final userData = await client.call(
        contract: contract, function: createUserFunction, params: [privateKey]);
    print(userData);
    print("<<<flavius_ddebug>>> first character in data is ${userData[0]}");

    final myUser = CurrentUser(
        privateKey: privateKey,
        publicKey: userData[1],
        balance: userData[2],
        owned_spots: userData[3],
        created_spots: userData[4],
        transaction_ids: userData[5]);
    // print("<<<flavius_debug>>> my user private key is ${myUser.privateKey}");

    await client.dispose();
    showSimpleToast("Login succesfully");
    return myUser;
  } catch (e) {
    showSimpleToast("Error on login");
    print("<<<flavius_debug>>> Error on login");
    print(e);
    return CurrentUser.returnEmptyUser();
  }
}

void attemptLogin(BuildContext context, String rawPrivateKey) async {
  blockUser(context);

  final privateKey = getB64(rawPrivateKey);
  CurrentUser? user = await loginUser(privateKey);
  Navigator.pop(context);

  if (user != null && user.privateKey != "") {
    print("<<<flavius_debug>>> User logged in with privatekey: $privateKey");
    GlobalVals.currentUser = user;
    print(
        "<<<flavius_debug>>> global pv is now: ${GlobalVals.currentUser.privateKey}");
    // save hash to persistent storage
    var persistentStorage = await Hive.openBox('userData');
    persistentStorage.put("privateKey", privateKey);
    Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
  }
}

Future<CurrentUser> getUserByPublicKey(String publicKey) async {
  final client = Web3Client(rpcUrl, Client());
  final abiCode = await rootBundle.loadString('assets/abi.json');
  final contract =
      DeployedContract(ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

  final getUserFunction = contract.function('get_user_by_public_key');

  final dev = await client
      .call(contract: contract, function: getUserFunction, params: [publicKey]);
  print(dev);

  // get user data from blockchain
  final balance = dev[0];
  final owned_spots = dev[1];
  final created_spots = dev[2];
  final transaction_ids = dev[3];

  // return user data
  return CurrentUser(
      privateKey: "",
      publicKey: publicKey,
      balance: balance,
      owned_spots: owned_spots,
      created_spots: created_spots,
      transaction_ids: transaction_ids);
}

Future<bool> addMoneyToUser(String privateKey, int amount) async {
  try {
    final client = Web3Client(rpcUrl, Client());
    final abiCode = await rootBundle.loadString('assets/abi.json');
    final credentials = await client.credentialsFromPrivateKey(_privateKey);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

    final addMoneyFunction = contract.function('add_money');

    print("Sending topup request with amount: $amount for user: $privateKey");
    BigInt amountBigInt = BigInt.from(amount);
    await client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: addMoneyFunction,
          parameters: [privateKey, amountBigInt],
        ),
        chainId: 53);

    await client.dispose();
    showSimpleToast("Topup success");
    return true;
  } catch (e) {
    showSimpleToast("Error on topup");
    print("<<<flavius_debug>>> Error on topup");
    print(e);
    return false;
  }
}

void attemptAddMoney(
    BuildContext context, String privateKey, int amount) async {
  // blockUser(context);

  final bool status = await addMoneyToUser(privateKey, amount);
  print("So ducky the status is $status");
}

// Future<CurrentUser> getUserByPrivateKey(String privateKey) async {
//   final client = Web3Client(rpcUrl, Client());
//   final abiCode = await rootBundle.loadString('assets/abi.json');
//   final contract =
//       DeployedContract(ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

//   final getUserFunction = contract.function('get_user_by_private_key');

//   final dev = await client.call(
//       contract: contract, function: getUserFunction, params: [privateKey]);
//   print(dev);

//   // get user data from blockchain
//   final publicKey = dev[0];
//   final balance = dev[1];
//   final owned_spots = dev[2];
//   final created_spots = dev[3];
//   final transaction_ids = dev[4];

//   // return user data
//   return CurrentUser(
//       privateKey: privateKey,
//       publicKey: publicKey,
//       balance: balance,
//       owned_spots: owned_spots,
//       created_spots: created_spots,
//       transaction_ids: transaction_ids);
// }
