import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/providers/notifications.dart';
import 'package:my_app/providers/wallet.dart';
import 'package:my_app/service/jwt_service.dart';
import 'package:provider/provider.dart';

class UserConsentAccept extends StatelessWidget {
  const UserConsentAccept({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var notifications = Provider.of<Notifications>(context);
    JWT jwt = notifications.last();

    return 
    (jwt!=null)?
    
    Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Accept Credentails'
        ),
        SizedBox(height: 10,),
        Text(
          '${jwt.claims}',
        ),
        SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            FloatingActionButton(
              onPressed: () {
                var wallet = Provider.of<MyWallet>(context, listen: false);
                wallet.add(notifications.pop());
              },
              heroTag: "Accept",              
              tooltip: 'Accept',
              child: Icon(
                Icons.add
              ),
            ),
            SizedBox(width:10),
            FloatingActionButton(
              onPressed: () {
                notifications.pop();
              },
              heroTag: "Ignore",              
              tooltip: 'Ignore',
              child: Icon(
                Icons.not_interested
              )
            ),
          ]
        )
      ],
    )

    :

    Text('--no notificaitons--');
  }
}
