import 'package:flutter/material.dart';
import 'package:my_app/pages/home.dart';
import 'package:my_app/providers/qrcode.dart';
import 'package:my_app/providers/wallet.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QRCode()),
        ChangeNotifierProvider(create: (_)=> MyWallet())
      ],
      child: Consumer<MyWallet>(
        builder: (context, counter, _) {
          return MaterialApp(
            supportedLocales: const [Locale('en')],
            localizationsDelegates: [
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            home: MyHomePage(),
          );
        },
      ),
    );
  }
}