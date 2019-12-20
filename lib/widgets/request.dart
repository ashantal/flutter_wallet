import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/providers/qrcode.dart';

class RequestButton extends StatelessWidget {
  const RequestButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // `listen: false` is specified here because otherwise that would make
        // `IncrementCounterButton` rebuild when the counter updates.
         Provider.of<QRCode>(context, listen: false).scan(RequestType.CredentialRequest);
         Navigator.pushNamed(context, '/scan');
      },
      tooltip: 'Share Credentials',
      child: const Icon(Icons.select_all),
    );
  }
}