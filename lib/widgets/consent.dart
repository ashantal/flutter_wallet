import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/providers/wallet.dart';
import 'package:provider/provider.dart';
import 'package:my_app/providers/qrcode.dart';

class UserConsent extends StatelessWidget {
  const UserConsent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qr = Provider.of<QRCode>(context);
    return 
    (qr.code!=null)?
    
    Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          (qr.request==RequestType.CredentialRequest?'Accept Credentails':'Share Credentials'),
        ),
        SizedBox(height: 10,),
        Text(
          '${qr.code}',
          style: Theme.of(context).textTheme.display1,
        ),
        SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            FloatingActionButton(
              onPressed: () {
                var wallet = Provider.of<MyWallet>(context, listen: false);
                if(qr.request==RequestType.CredentialRequest){
                    wallet.initCredentials(qr.code);
                }else{
                    wallet.shareCredentials(qr.code);
                }
              },
              tooltip: 'Consent',
              child: Icon(
                (qr.request==RequestType.CredentialRequest?Icons.add:Icons.screen_share)
              ),
            ),
            SizedBox(width:10),
            FloatingActionButton(
              onPressed: () {
                qr.clear();
              },
              tooltip: 'Consent',
              child: Icon(
                Icons.not_interested
              )
            ),
          ]
        )
      ],
    )

    :

    Text('--scan a qrcode--');
  }
}
