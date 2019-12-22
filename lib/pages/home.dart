import 'package:flutter/material.dart';
import 'package:my_app/widgets/mywallet.dart';
import 'package:my_app/widgets/consent_accept.dart';
import 'package:my_app/widgets/scan_qrcode.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('My Wallet'),
      ),
      body: new Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Center(child: WalletLabel()),
                const Center(child: UserConsentAccept()),
              ],
            )
      ),      
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const ScanButton(),
        ],
      ),                           
    );
  }
}