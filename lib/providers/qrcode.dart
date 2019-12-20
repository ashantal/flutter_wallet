import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:flutter/foundation.dart';
enum RequestType{
  ShareRequest,
  CredentialRequest
}

class QRCode with ChangeNotifier{
  int _attempt = 0;
  String _code;
  RequestType _request;
  String get code => _code;
  RequestType get request=> _request;
  void clear(){
    _attempt=0;
    _code = null;
    notifyListeners();
  }
  void scan(RequestType request) async{
      
      var qc = new QRCodeReader()
          .setAutoFocusIntervalInMs(200)
          .setForceAutoFocus(true)
          .setTorchEnabled(true)
          .setHandlePermissions(true)
          .setExecuteAfterPermissionGranted(true);
      _code = await qc.scan();
      _request = request;
      
      if(_code==null && _attempt++ > 0){
        _code="$_attempt (iPhone only)";
      }
      
      notifyListeners();
  }
}