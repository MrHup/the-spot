import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/data/models/spot.dart';
import 'package:the_spot/data/models/static_user.dart';
import 'package:the_spot/data/models/transactionw3.dart';
import 'package:the_spot/data/repository/generate_key.dart';
import 'package:the_spot/data/repository/popups.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

const String rpcUrl = 'https://testnet-rpc.coinex.net';
final EthereumAddress contractAddr =
    EthereumAddress.fromHex('0xd03B6Aaa9E832E99E6245110040Ba707dD1AE816');
const String _privateKey =
    "0x0503d85eaf557849e40c4a7e6895aa2f6764c26af04fd02a36f5d0f3fa3954fc";

Future<CurrentUser> registerUser(String privateKey, String publicKey) async {
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
    CurrentUser myUser = CurrentUser.returnEmptyUser();
    myUser.privateKey = privateKey;
    myUser.publicKey = publicKey;
    await Future.delayed(Duration(seconds: 5));
    showSimpleToast("Registered succesfully");
    return myUser;
  } catch (e) {
    print("<<<flavius_debug>>> Error on registerUser");
    print(e);
    showSimpleToast("Error while registering");
    return CurrentUser.returnEmptyUser();
  }
}

void attemptRegister(
    BuildContext context, String privateKey, String publicKey) async {
  blockUser(context);

  CurrentUser? user = await registerUser(privateKey, publicKey);
  Navigator.pop(context);

  if (user != null && user.privateKey != "") {
    print(
        "<<<flavius_debug>>> User registered in with privatekey: $privateKey");
    GlobalVals.currentUser = user;
    // save hash to persistent storage
    var persistentStorage = await Hive.openBox('userData');
    persistentStorage.put("privateKey", privateKey);
    Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
  }
}

Future<CurrentUser> loginUser(String privateKey) async {
  try {
    print("!!!!!<<<flavius>>> login user with pv: $privateKey");
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
  blockUser(context);
  final bool status = await addMoneyToUser(privateKey, amount);
  Navigator.of(context, rootNavigator: true).pop();
  Navigator.pop(context);
  updateUserBalance(privateKey);
}

void updateUserBalance(String privateKey) async {
  final client = Web3Client(rpcUrl, Client());
  final abiCode = await rootBundle.loadString('assets/abi.json');
  final contract =
      DeployedContract(ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

  final getUserFunction = contract.function('get_user_balance');

  final dev = await client.call(
      contract: contract, function: getUserFunction, params: [privateKey]);
  print(dev);

  // get user data from blockchain
  final balance = dev[0];

  // return user data
  GlobalVals.currentUser.balance = balance;
}

Future<List<TransactionW3>> getTransactionsForUser(String privateKey) async {
  try {
    print("<<<flavius_Debug>>> Getting transactions for user: $privateKey");
    final client = Web3Client(rpcUrl, Client());
    print("<<<flavius_Debug>>> Client created");
    final abiCode = await rootBundle.loadString('assets/abi.json');
    print("<<<flavius_Debug>>> abi loaded");
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);
    print("<<<flavius_Debug>>> contract created");

    final getTransactionsForUser =
        contract.function('get_transactions_for_user');
    print("<<<flavius_Debug>>> function created");

    final dev = await client.call(
        contract: contract,
        function: getTransactionsForUser,
        params: [privateKey]);

    print("<<<flavius_debug>>> dev is $dev");
    List<TransactionW3> transactions = [];
    for (var transaction in dev[0]) {
      print(transaction);
      var dt = DateTime.fromMillisecondsSinceEpoch(transaction[0].toInt());
      print("this is reached 1");
      var d24 = DateFormat('dd/MM/yyyy, HH:mm').format(dt); // 31/12/2000, 22:00
      print("this is reached 2");
      // final int typeIndex = transaction[4];

      // print("This is reached :) $typeIndex");

      final String sender = transaction[1];
      print("received sender: $sender");
      final String receiver = transaction[2];
      print("received receiver: $receiver");
      final int amount = transaction[3].toInt();
      print("received amount: $amount");
      final String date = d24;
      print("received date: $date");
      final int typeNr = transaction[4].toInt();
      print("received typeNr: $typeNr");
      final String type = GlobalVals.operationTypesEnum[typeNr] ?? "Unknown";
      print("received type: $type");

      transactions.add(TransactionW3(
        date: date,
        sender: sender,
        receiver: receiver,
        amount: amount,
        type: type,
      ));
    }
    return transactions;
  } catch (e) {
    print("<<<flavius_debug>>> Error on getTransactionsForUser");
    print(e);
    return [];
  }
}

Future<CurrentUser> getUserByPrivateKey(String privateKey) async {
  final client = Web3Client(rpcUrl, Client());
  final abiCode = await rootBundle.loadString('assets/abi.json');
  final contract =
      DeployedContract(ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

  final getUserFunction = contract.function('get_user_by_private_key');

  final dev = await client.call(
      contract: contract, function: getUserFunction, params: [privateKey]);
  print(dev);

  // get user data from blockchain
  final publicKey = dev[0];
  final balance = dev[1];
  final owned_spots = dev[2];
  final created_spots = dev[3];
  final transaction_ids = dev[4];

  // return user data
  return CurrentUser(
      privateKey: privateKey,
      publicKey: publicKey,
      balance: balance,
      owned_spots: owned_spots,
      created_spots: created_spots,
      transaction_ids: transaction_ids);
}

Future<bool> createNewSpot(final String name, final String imageUri,
    final String privateKey, final BigInt basePrice) async {
  print(
      "<<<flavius_debug>>> Creating new spot with name: $name, imageUri: $imageUri, privateKey: $privateKey");
  try {
    final client = Web3Client(rpcUrl, Client());
    final abiCode = await rootBundle.loadString('assets/abi.json');

    final credentials = await client.credentialsFromPrivateKey(_privateKey);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

    final createUserFunction = contract.function('create_new_spot');

    await client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: createUserFunction,
          parameters: [name, imageUri, privateKey, basePrice],
        ),
        chainId: 53);
    await client.dispose();

    showSimpleToast("Spot created succesfully");
    return true;
  } catch (e) {
    print("<<<flavius_debug>>> Error on registerUser");
    print(e);
    showSimpleToast("Error while spot creation");
    return false;
  }
}

void attemptCreateNewSpot(
    BuildContext context,
    final String name,
    final String imageUri,
    final String privateKey,
    final BigInt basePrice) async {
  blockUser(context);
  final bool status =
      await createNewSpot(name, imageUri, privateKey, basePrice);
  Navigator.of(context, rootNavigator: true).pop();
  Navigator.pop(context);
}

void transferMoney(String sender, String receiver, BigInt amount) async {
  try {
    final client = Web3Client(rpcUrl, Client());
    final abiCode = await rootBundle.loadString('assets/abi.json');

    final credentials = await client.credentialsFromPrivateKey(_privateKey);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

    final transferFunction = contract.function('transfer_money');

    await client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: transferFunction,
          parameters: [sender, receiver, amount],
        ),
        chainId: 53);
    await client.dispose();

    showSimpleToast("Transfered succesfully");
  } catch (e) {
    print("<<<flavius_debug>>> Error on transfering");
    print(e);
    showSimpleToast("Error while transfering");
  }
}

Future<List<Spot>> getAllSpotsCreatedByUser(String privateKey) async {
  try {
    print("<<<flavius_Debug>>> Getting spots for user: $privateKey");
    final client = Web3Client(rpcUrl, Client());
    print("<<<flavius_Debug>>> Client created");
    final abiCode = await rootBundle.loadString('assets/abi.json');
    print("<<<flavius_Debug>>> abi loaded");
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);
    print("<<<flavius_Debug>>> contract created");

    final getSpotsForUser = contract.function('get_all_spots_created_by_user');
    print("<<<flavius_Debug>>> function created");

    final dev = await client.call(
        contract: contract, function: getSpotsForUser, params: [privateKey]);

    print("<<<flavius_debug>>> dev is $dev");
    List<Spot> spots = [];
    for (var spot in dev[0]) {
      print(spot);
      final int id = spot[0].toInt();
      print("received id: $id");
      final String name = spot[1];
      print("received name: $name");
      final String imageUri = spot[2];
      print("received imageUri: $imageUri");
      final String owner = spot[3];
      print("received owner: $owner");
      final int currentPrice = spot[4].toInt();
      print("received currentPrice: $currentPrice");

      spots.add(Spot(
        index: id,
        name: name,
        image_uri: imageUri,
        current_owner: owner,
        current_price: currentPrice,
      ));
    }

    return spots;
  } catch (e) {
    print("<<<flavius_debug>>> Error on getTransactionsForUser");
    print(e);
    return [];
  }
}

Future<List<Spot>> getAllSpotsOwnedByUser(String privateKey) async {
  try {
    print("<<<flavius_Debug>>> Getting spots for user: $privateKey");
    final client = Web3Client(rpcUrl, Client());
    print("<<<flavius_Debug>>> Client created");
    final abiCode = await rootBundle.loadString('assets/abi.json');
    print("<<<flavius_Debug>>> abi loaded");
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);
    print("<<<flavius_Debug>>> contract created");

    final getSpotsForUser = contract.function('get_all_spots_owned_by_user');
    print("<<<flavius_Debug>>> function created");

    final dev = await client.call(
        contract: contract, function: getSpotsForUser, params: [privateKey]);

    print("<<<flavius_debug>>> dev is $dev");
    List<Spot> spots = [];
    for (var spot in dev[0]) {
      print(spot);
      final int id = spot[0].toInt();
      print("received id: $id");
      final String name = spot[1];
      print("received name: $name");
      final String imageUri = spot[2];
      print("received imageUri: $imageUri");
      final String owner = spot[3];
      print("received owner: $owner");
      final int currentPrice = spot[4].toInt();
      print("received currentPrice: $currentPrice");

      spots.add(Spot(
        index: id,
        name: name,
        image_uri: imageUri,
        current_owner: owner,
        current_price: currentPrice,
      ));
    }

    return spots;
  } catch (e) {
    print("<<<flavius_debug>>> Error on getTransactionsForUser");
    print(e);
    return [];
  }
}
