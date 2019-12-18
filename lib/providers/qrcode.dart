import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:flutter/foundation.dart';
class QRCode with ChangeNotifier{
  int attempt = 0;
  String _code;
  String get code => _code;

  void scan() async{
      var qc = new QRCodeReader()
          .setAutoFocusIntervalInMs(200)
          .setForceAutoFocus(true)
          .setTorchEnabled(true)
          .setHandlePermissions(true)
          .setExecuteAfterPermissionGranted(true);
      _code = await qc.scan();
      
      if(_code==null && attempt++ > 1){
        _code="$attempt (iPhone only)";
      }
      
      notifyListeners();
  }
}