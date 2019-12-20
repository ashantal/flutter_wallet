import 'package:flutter/material.dart';
import 'package:my_app/widgets/consent.dart';
import 'package:my_app/widgets/share.dart';

class QRScanPage extends StatelessWidget {
  QRScanPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Scan'),
      ),
      body: new Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Center(child: UserConsent()),
              ],
            )
      ),      
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(width: 10),
          const ShareButton(),
        ],
      ),                           
    );
  }
}