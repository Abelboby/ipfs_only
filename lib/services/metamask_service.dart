import 'package:flutter/cupertino.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'dart:js' as js;

class MetaMaskProvider extends ChangeNotifier {
  static const operatingChain = 1;

  String currentAddress = '';
  int currentChain = -1;
  Web3Client? _web3client;

  bool get isEnabled => js.context.hasProperty('ethereum');
  bool get isInOperatingChain => currentChain == operatingChain;
  bool get isConnected => isEnabled && currentAddress.isNotEmpty;

  Future<void> connect() async {
    if (isEnabled) {
      try {
        final accounts = await js.context['ethereum'].callMethod('request', [
          {'method': 'eth_requestAccounts'}
        ]) as List<dynamic>;
        
        if (accounts.isNotEmpty) {
          currentAddress = accounts.first as String;
        }

        currentChain = int.parse(await js.context['ethereum']
            .callMethod('request', [
          {'method': 'eth_chainId'}
        ]) as String);

        _initWeb3Client();
        notifyListeners();
      } catch (e) {
        print('Error connecting to MetaMask: $e');
      }
    }
  }

  void _initWeb3Client() {
    final client = Client();
    _web3client = Web3Client('https://mainnet.infura.io/v3/YOUR-PROJECT-ID', client);
  }

  clear() {
    currentAddress = '';
    currentChain = -1;
    _web3client = null;
    notifyListeners();
  }

  init() {
    if (isEnabled) {
      js.context['ethereum'].callMethod('on', [
        'accountsChanged',
        (accounts) {
          clear();
        }
      ]);
      js.context['ethereum'].callMethod('on', [
        'chainChanged',
        (chainId) {
          clear();
        }
      ]);
    }
  }

  Future<String> getBalance() async {
    if (_web3client != null && currentAddress.isNotEmpty) {
      final address = EthereumAddress.fromHex(currentAddress);
      final balance = await _web3client!.getBalance(address);
      return balance.getValueInUnit(EtherUnit.ether).toString();
    }
    return '0';
  }
}