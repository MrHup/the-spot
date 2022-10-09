import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/data/repository/popups.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

const String rpcUrl = 'https://testnet-rpc.coinex.net';
final EthereumAddress contractAddr =
    EthereumAddress.fromHex('0xde411250a13b4B0391bcF8A355613Ca348721805');
const String _privateKey =
    "0x0503d85eaf557849e40c4a7e6895aa2f6764c26af04fd02a36f5d0f3fa3954fc";

Future<String> registerUser(String privateKey, String publicKey) async {
  final client = Web3Client(rpcUrl, Client());
  final abiCode = await rootBundle.loadString('assets/abi.json');

  final credentials = await client.credentialsFromPrivateKey(_privateKey);
  final contract =
      DeployedContract(ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

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
}

// Future<String> loginUser(String privateKey) async {
//   final client = Web3Client(rpcUrl, Client());
//   final abiCode = await rootBundle.loadString('assets/abi.json');

//   final credentials = await client.credentialsFromPrivateKey(_privateKey);
//   final contract =
//       DeployedContract(ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

//   final createUserFunction = contract.function('add_new_user');

//   await client.sendTransaction(
//       credentials,
//       Transaction.callContract(
//         contract: contract,
//         function: createUserFunction,
//         parameters: [privateKey],
//       ),
//       chainId: 53);

//   await client.dispose();
//   showSimpleToast("Registered succesfully");
//   return privateKey;
// }

void attemptRegister(
    BuildContext context, String privateKey, String publicKey) async {
  blockUser(context);

  String? pv = await registerUser(privateKey, publicKey);
  Navigator.pop(context);

  if (pv != null) {
    // save hash to persistent storage
    var persistentStorage = await Hive.openBox('userData');
    persistentStorage.put("privateKey", privateKey);
    Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
  } else {
    showSimpleToast("Something went wrong with the registration");
  }
}
