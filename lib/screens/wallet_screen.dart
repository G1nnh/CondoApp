import 'package:flutter/material.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:http/http.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _formKey = GlobalKey<FormState>();
  late WalletConnect connector;
  String currentAddress = "";
  bool isConnected = false;
  String nickname = "";

  @override
  void initState() {
    super.initState();
    connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: PeerMeta(
        name: 'Flutter App',
        description: 'A MetaMask Flutter integration',
        url: 'https://flutter.dev',
        icons: ['https://flutter.dev/favicon.ico'],
      ),
    );
  }

  void connectWallet() async {
    if (!connector.connected) {
      try {
        final session = await connector.connect(
          chainId: 1,
          onDisplayUri: (uri) => print(uri),
        );
        setState(() {
          currentAddress = session.accounts[0];
          isConnected = true;
        });
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void disconnectWallet() {
    connector.killSession();
    setState(() {
      currentAddress = "";
      isConnected = false;
    });
  }

  void saveWalletInfo() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Nickname: $nickname');
      // Save nickname and other info to a database or local storage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WalletConnect Integration')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isConnected
                ? Column(
                    children: [
                      Text('Connected Address: $currentAddress'),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: disconnectWallet,
                        child: Text('Disconnect Wallet'),
                      ),
                      SizedBox(height: 20.0),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(labelText: 'Nickname'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a nickname';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  nickname = value ?? "";
                                },
                              ),
                              SizedBox(height: 20.0),
                              ElevatedButton(
                                onPressed: saveWalletInfo,
                                child: Text('Save Wallet Info'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: connectWallet,
                    child: Text('Connect to MetaMask'),
                  ),
          ],
        ),
      ),
    );
  }
}