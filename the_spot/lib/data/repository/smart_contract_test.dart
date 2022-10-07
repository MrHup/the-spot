import 'dart:io';

import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

const String rpcUrl = 'https://testnet-rpc.coinex.net';

final EthereumAddress contractAddr =
    EthereumAddress.fromHex('0xe9B6cee5102017a1A9450ABaF170ae95D24009b7');
final File abiFile = File('assets/abi.json');

void get_balance_total() async {
  final client = Web3Client(rpcUrl, Client());
  final abiCode = await abiFile.readAsString();
  final contract =
      DeployedContract(ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

  final balanceFunction = contract.function('getSpotAmount');

  final dev = await client
      .call(contract: contract, function: balanceFunction, params: []);
  print(dev);
}

void create_user() async {
  var bigInt = BigInt.from(10);
  final client = Web3Client(rpcUrl, Client());
  final abiCode = await abiFile.readAsString();
  final contract =
      DeployedContract(ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

  final createUserFunction = contract.function('addNewUser');

  final dev = await client.call(
      contract: contract,
      function: createUserFunction,
      params: [
        "85d2242ae1b7759934d4b0d4f0d62d666cf7d73e21dbd09d73c7de266b72a25a",
        bigInt
      ]);
  print(dev);
}

void get_user() async {
  final client = Web3Client(rpcUrl, Client());
  final abiCode = await abiFile.readAsString();
  final contract =
      DeployedContract(ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

  final getUserFunction = contract.function('getUser');

  final dev = await client
      .call(contract: contract, function: getUserFunction, params: ["aaa"]);
  print(dev);
}
