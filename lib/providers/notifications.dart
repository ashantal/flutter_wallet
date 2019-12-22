import 'package:flutter/foundation.dart';
import 'package:my_app/service/jwt_service.dart';

class Notifications with ChangeNotifier{
  var _notifications = new List<JWT>();

  JWT last() => _notifications.length>0?_notifications.last:null;

  JWT pop(){
    var jwt = _notifications.length>0? _notifications.removeLast():null;
    notifyListeners();
    return jwt;
  }

  void push(JWT jwt) async{
    _notifications.add(jwt);
    notifyListeners();
  }

}