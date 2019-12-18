import 'package:flutter/material.dart';
import 'package:my_app/widgets/mywallet.dart';
import 'package:my_app/widgets/qrcode.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                const Center(child: QRCodeLabel()),
              ],
            )
      ),      
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(width: 10),
          const QRCodeScanButton(),
          SizedBox(width: 10),
        ],
      ),                           
    );
  }
  @override
  void dispose() {
    super.dispose();
  }  
}