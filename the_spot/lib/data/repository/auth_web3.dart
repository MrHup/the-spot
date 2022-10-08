import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'dart:convert';

const String rpcUrl = 'https://testnet-rpc.coinex.net';
final EthereumAddress contractAddr =
    EthereumAddress.fromHex('0xde411250a13b4B0391bcF8A355613Ca348721805');
const String privateKey =
    "0x0503d85eaf557849e40c4a7e6895aa2f6764c26af04fd02a36f5d0f3fa3954fc";

void registerUser(String privateKey, String publicKey) async {
  final client = Web3Client(rpcUrl, Client());
  final abiCode = await rootBundle.loadString('assets/abi.json');

  final credentials = await client.credentialsFromPrivateKey(privateKey);
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
}
