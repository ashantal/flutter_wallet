import 'package:flutter/material.dart';
import 'package:my_app/actions/credentials.dart';
import 'package:my_app/store/credentials.dart';
import 'package:my_app/widgets/counter.dart';
import 'package:my_app/widgets/mywallet.dart';
import 'package:my_app/widgets/qrcode.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final _bloc = CounterBloc();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('QR Code Reader'),
      ),
      body: new Center(
          child: StreamBuilder(
          stream: _bloc.counter,
          initialData: 0,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${snapshot.data}',
                  style: Theme.of(context).textTheme.display1,
                ),
                const Center(child: CounterLabel()),
                const Center(child: QRCodeLabel()),
                const Center(child: WalletLabel())
              ],
            );
          },
        ),
      ),      
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () => _bloc.counterEventSink.add(IncrementEvent()),
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => _bloc.counterEventSink.add(DecrementEvent()),
            tooltip: 'Decrement',
            child: Icon(Icons.remove),
          ),
                   
          SizedBox(width: 10),
          const IncrementCounterButton(),

          SizedBox(width: 10),
          const QRCodeScanButton(),
        ],
      ),                           
    );
  }
  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }  
}