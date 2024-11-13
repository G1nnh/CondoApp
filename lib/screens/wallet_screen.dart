import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late Web3Client _web3client;
  String currentAddress = "";
  bool isConnected = false;
  final String rpcUrl =
      "https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID"; // Replace with your Infura Project ID

  @override
  void initState() {
    super.initState();
    _web3client = Web3Client(rpcUrl, Client());
  }

  Future<void> connectWallet() async {
    // For demonstration purposes, we're just displaying a sample address.
    // Actual connection with MetaMask will involve using WalletConnect or a browser extension.
    setState(() {
      currentAddress = "0x1234567890abcdef1234567890abcdef12345678";
      isConnected = true;
    });
  }

  void disconnectWallet() {
    setState(() {
      currentAddress = "";
      isConnected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MetaMask Integration')),
      body: Center(
        child: isConnected
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Connected Address: $currentAddress'),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: disconnectWallet,
                    child: Text('Disconnect Wallet'),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: connectWallet,
                child: Text('Connect to MetaMask'),
              ),
      ),
    );
  }
}
