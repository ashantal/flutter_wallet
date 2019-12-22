import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/providers/notifications.dart';
import 'package:my_app/providers/wallet.dart';
import 'package:provider/provider.dart';
import 'package:my_app/providers/qrcode.dart';

class UserConsentShare extends StatelessWidget {
  const UserConsentShare({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var wallet = Provider.of<MyWallet>(context, listen: false);
    final qr = Provider.of<QRCode>(context);
    return 
    (qr.code!=null)?
    Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Share Credentials'),
        SizedBox(height: 10,),
        Text(
          '${wallet.parseJwt(qr.code).claims}',
        ),
        SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            FloatingActionButton(
              onPressed: () async {
                var jwt = await wallet.shareCredentials(qr.code);

                var notifications = Provider.of<Notifications>(context, listen: false);
                notifications.push(jwt);

                Navigator.pop(context);
              },
              heroTag: "Share",              
              tooltip: 'Share',
              child: Icon(Icons.screen_share),
            ),
            SizedBox(width:10),
            FloatingActionButton(
              onPressed: () {
                qr.clear();
                Navigator.pop(context);
              },
              heroTag: "Cancel",              
              tooltip: 'Cancel',
              child: Icon(Icons.not_interested)
            ),
          ]
        )
      ],
    )

    :

    Text('--scan a qrcode--');
  }
}
