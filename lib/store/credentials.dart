import 'dart:async';

import 'package:my_app/actions/credentials.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class CounterBloc {
  int _counter = 0;

  final _counterStateController = StreamController<int>();
  StreamSink<int> get _inCounter => _counterStateController.sink;
  // For state, exposing only a stream which outputs data
  Stream<int> get counter => _counterStateController.stream;

  final _counterEventController = StreamController<CounterEvent>();
  // For events, exposing only a sink which is an input
  Sink<CounterEvent> get counterEventSink => _counterEventController.sink;

  CounterBloc() {
    // Whenever there is a new event, we want to map it to a new state
    _counterEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(CounterEvent event) async{
    if (event is IncrementEvent)
      _counter++;
    else if(event is ScanEvent){
              var qc = new QRCodeReader()
                  .setAutoFocusIntervalInMs(200)
                  .setForceAutoFocus(true)
                  .setTorchEnabled(true)
                  .setHandlePermissions(true)
                  .setExecuteAfterPermissionGranted(true);
              var _code = await qc.scan();
              print(_code);
    }
    else
      _counter--;

    _inCounter.add(_counter);
  }

  void dispose() {
    _counterStateController.close();
    _counterEventController.close();
  }
}