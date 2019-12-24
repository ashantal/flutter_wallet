import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';
class Events with ChangeNotifier{
  Events():super();

  var _events = new List<String>();
  String last() => _events.length>0?_events.last:null;
  IO.Socket _socket;
  
  void init(){
    print('init');
    _socket = IO.io('http://monitor.rbi.events', <String, dynamic> {
    'path': '/socket.io',
    'transports': ['websocket'],
  });
      _socket.on('connect', (_) {
        print('connect');
        _socket.emit( 'sync');
      });
      _socket.on('disconnect', (_) => print('disconnect'));
      _socket.on('fromServer', (_) => print(_));    
     _socket.on('event', (data) {
        print(data);
      });
      _socket.on('event1', (data) {
        print(data);
        //_events.add(data);
        //notifyListeners();
      });
  }
}