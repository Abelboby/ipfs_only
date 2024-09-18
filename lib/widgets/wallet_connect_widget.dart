import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/wallet_service.dart';

class WalletConnectWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final walletService = Provider.of<WalletService>(context);

    return Column(
      children: [
        ElevatedButton(
          onPressed: walletService.isConnected
              ? walletService.disconnect
              : walletService.connect,
          child: Text(
            walletService.isConnected ? 'Disconnect Wallet' : 'Connect MetaMask',
          ),
        ),
        if (walletService.isConnected)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Connected Address: ${walletService.address}',
              style: TextStyle(fontSize: 12),
            ),
          ),
      ],
    );
  }
}