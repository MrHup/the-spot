import 'dart:io';

import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

// setup stuff
const String rpcUrl = 'https://testnet-rpc.coinex.net';
final EthereumAddress contractAddr =
    EthereumAddress.fromHex('0x905d38BE581D1FAf9C241A861719B4B1738f95F2');
const String privateKey =
    "0x0503d85eaf557849e40c4a7e6895aa2f6764c26af04fd02a36f5d0f3fa3954fc";
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

  final credentials = await client.credentialsFromPrivateKey(privateKey);
  final ownAddress = await credentials.extractAddress();

  final abiCode = await abiFile.readAsString();
  final contract =
      DeployedContract(ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

  final createUserFunction = contract.function('addNewUser');

  final dev = await client.call(
      contract: contract,
      function: createUserFunction,
      params: [
        "85d2242ae1b7759934d4b0d4f0d62d666cf7d73e21dbd09dd3c7de266b72a25a",
        "abcd"
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

void create_user_for_real() async {
  final client = Web3Client(rpcUrl, Client());

  final credentials = await client.credentialsFromPrivateKey(privateKey);
  print(credentials.address);
  print(credentials);
  final ownAddress = await credentials.extractAddress();

  final abiCode = await abiFile.readAsString();
  final contract =
      DeployedContract(ContractAbi.fromJson(abiCode, 'SpotCoin'), contractAddr);

  final createUserFunction = contract.function('addNewUser');

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
