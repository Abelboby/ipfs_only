import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/metamask_service.dart';
import '../widgets/image_picker_widget.dart';
import '../widgets/upload_button_widget.dart';
import '../widgets/upload_history_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _imagePath;

  void _setImagePath(String path) {
    setState(() {
      _imagePath = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: Stack(
        children: [
          Center(
            child: Consumer<MetaMaskProvider>(
              builder: (context, provider, child) {
                if (provider.isConnected && provider.isInOperatingChain) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Connected: ${provider.currentAddress}'),
                      SizedBox(height: 10),
                      FutureBuilder<String>(
                        future: provider.getBalance(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          return Text('Balance: ${snapshot.data ?? "0"} ETH');
                        },
                      ),
                      SizedBox(height: 20),
                      ImagePickerWidget(
                        onImagePicked: _setImagePath,
                      ),
                      SizedBox(height: 20),
                      UploadButtonWidget(
                        imagePath: _imagePath,
                        onUpload: () async {
                          // Implement upload logic here
                        },
                      ),
                      SizedBox(height: 20),
                      UploadHistoryWidget(),
                    ],
                  );
                } else if (provider.isConnected && !provider.isInOperatingChain) {
                  return Text(
                    'Wrong chain. Please connect to ${MetaMaskProvider.operatingChain}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  );
                } else if (provider.isEnabled) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Click the button to connect...'),
                      const SizedBox(height: 8),
                      CupertinoButton(
                        onPressed: () => context.read<MetaMaskProvider>().connect(),
                        color: Colors.white,
                        padding: const EdgeInsets.all(0),
                        child: Image.network(
                          'https://i0.wp.com/kindalame.com/wp-content/uploads/2021/05/metamask-fox-wordmark-horizontal.png?fit=1549%2C480&ssl=1',
                          width: 300,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Text(
                    'Please use a Web3 supported browser.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  );
                }
              },
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTicLAkhCzpJeu9OV-4GOO-BOon5aPGsj_wy9ETkR4g-BdAc8U2-TooYoiMcPcmcT48H7Y&usqp=CAU',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.025),
              ),
            ),
          ),
        ],
      ),
    );
  }
}