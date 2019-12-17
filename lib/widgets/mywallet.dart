import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/providers/wallet.dart';
import 'package:provider/provider.dart';

class WalletLabel extends StatelessWidget {
  const WalletLabel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wallet = Provider.of<MyWallet>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Claims:',
        ),
        Text(
          '${wallet.claims['name']}',
          style: Theme.of(context).textTheme.display1,
        ),
      ],
    );
  }
}
