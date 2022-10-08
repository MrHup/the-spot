import 'dart:io';

import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

// setup stuff
const String rpcUrl = 'https://testnet-rpc.coinex.net';
final EthereumAddress contractAddr =
    EthereumAddress.fromHex('0xde411250a13b4B0391bcF8A355613Ca348721805');
const String privateKey =
    "0x0503d85eaf557849e40c4a7e6895aa2f6764c26af04fd02a36f5d0f3fa3954fc";
// final File abiFile = File('assets/abi.json');

void get_balance_total() async {
  final client = Web3Client(rpcUrl, Client());
  final abiCode = await rootBundle.loadString('assets/abi.json');
  final contract =
      DeployedContract(ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

  final balanceFunction = contract.function('get_spot_amount');

  final dev = await client
      .call(contract: contract, function: balanceFunction, params: []);
  print(dev);
}

void get_user() async {
  final client = Web3Client(rpcUrl, Client());
  final abiCode = await rootBundle.loadString('assets/abi.json');
  final contract =
      DeployedContract(ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

  final getUserFunction = contract.function('get_user_by_public_key');

  final dev = await client
      .call(contract: contract, function: getUserFunction, params: ["pb2"]);
  print(dev);
}

void create_user_for_real() async {
  final client = Web3Client(rpcUrl, Client());

  final credentials = await client.credentialsFromPrivateKey(privateKey);
  print(credentials.address);
  print(credentials);
  final ownAddress = await credentials.extractAddress();

  final abiCode = await rootBundle.loadString('assets/abi.json');
  final contract =
      DeployedContract(ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

  final createUserFunction = contract.function('add_new_user');

  print("right before the call");
  await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: createUserFunction,
        parameters: ["aaabcd", "pelkan"],
      ),
      chainId: 53);

  await client.dispose();
}
