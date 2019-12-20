import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
class ShareButton extends StatelessWidget {
  const ShareButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        //Provider.of<QRCode>(context, listen: false).scan(RequestType.ShareRequest);
         Navigator.pop(context);
      },
      tooltip: 'Home',
      child: const Icon(Icons.home),
    );
  }
}
