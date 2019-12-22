import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
class MyCredentialsButton extends StatelessWidget {
  const MyCredentialsButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
         Navigator.pushNamed(context, '/credentials');
      },
      heroTag: 'My Credentials',
      tooltip: 'My Credentials',
      child: const Icon(Icons.description),
    );
  }
}