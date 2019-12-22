import 'package:flutter/material.dart';
import 'package:my_app/widgets/mywallet.dart';
class MyCredentialsPage extends StatelessWidget {
  MyCredentialsPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('My Credentials'),
      ),
      body: new Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Center(child: WalletLabel()),
              ],
            )
      )
    );
  }
}