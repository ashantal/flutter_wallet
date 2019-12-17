import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:flutter/foundation.dart';
class QRCode with ChangeNotifier{
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
      
      if(_code==null){
        _code="iPhone only";
      }
      notifyListeners();
  }
}