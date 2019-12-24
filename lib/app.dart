import 'package:flutter/material.dart';
import 'package:my_app/pages/credentials.dart';
import 'package:my_app/pages/home.dart';
import 'package:my_app/pages/scan.dart';
import 'package:my_app/providers/notifications.dart';
import 'package:my_app/providers/qrcode.dart';
import 'package:my_app/providers/wallet.dart';
import 'package:my_app/providers/monitor.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Events()),
        ChangeNotifierProvider(create: (_) => Notifications()),
        ChangeNotifierProvider(create: (_) => QRCode()),
        ChangeNotifierProvider(create: (_)=> MyWallet())
      ],
      child: Consumer<Events>(
        builder: (context, counter, _) {
          Provider.of<Events>(context,listen: false).init();

          return MaterialApp(
            supportedLocales: const [Locale('en')],
            localizationsDelegates: [
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            initialRoute: '/',
            routes: {
              // When navigating to the "/" route, build the FirstScreen widget.
              '/': (context) => MyHomePage(),
              // When navigating to the "/second" route, build the SecondScreen widget.
              '/scan': (context) => QRScanPage(),
              '/credentials': (context) => MyCredentialsPage(),
            }            
          );
        },
      ),
    );
  }
}