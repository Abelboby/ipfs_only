import 'package:flutter/foundation.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletService extends ChangeNotifier {
  bool _isConnected = false;
  String? _address;

  bool get isConnected => _isConnected;
  String? get address => _address;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _address = prefs.getString('wallet_address');
    _isConnected = _address != null;
    notifyListeners();
  }

  Future<void> connect() async {
    if (Ethereum.isSupported) {
      try {
        final accs = await ethereum!.requestAccount();
        if (accs.isNotEmpty) {
          _address = accs.first;
          _isConnected = true;
          
          // Save the address
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('wallet_address', _address!);
          
          notifyListeners();
        }
      } catch (e) {
        print('Error connecting to MetaMask: $e');
      }
    } else {
      print('Ethereum is not supported on this device');
    }
  }

  Future<void> disconnect() async {
    _isConnected = false;
    _address = null;
    
    // Clear the saved address
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('wallet_address');
    
    notifyListeners();
  }
}