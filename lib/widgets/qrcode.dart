import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/providers/wallet.dart';
import 'package:provider/provider.dart';
import 'package:my_app/providers/qrcode.dart';


class QRCodeScanButton extends StatelessWidget {
  const QRCodeScanButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // `listen: false` is specified here because otherwise that would make
        // `IncrementCounterButton` rebuild when the counter updates.
        Provider.of<QRCode>(context, listen: false).scan();
      },
      tooltip: 'Scan',
      child: const Icon(Icons.check_box_outline_blank),
    );
  }
}


class QRCodeLabel extends StatelessWidget {
  const QRCodeLabel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qr = Provider.of<QRCode>(context);

    if(qr.code!=null){
      Provider.of<MyWallet>(context,listen:false).initCredentials(qr.code);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Scanned Code:',
        ),
        Text(
          '${qr.code}',
          style: Theme.of(context).textTheme.display1,
        ),
      ],
    );
  }
}