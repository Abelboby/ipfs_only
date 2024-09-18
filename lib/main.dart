import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/metamask_service.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pinata IPFS Uploader',
      theme: ThemeData.dark(),
      home: ChangeNotifierProvider(
        create: (context) => MetaMaskProvider()..init(),
        child: const HomeScreen(),
      ),
    );
  }
}