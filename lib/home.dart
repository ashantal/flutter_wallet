import 'package:flutter/material.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:my_app/service/address_service.dart';
import 'package:my_app/service/ES256Signer.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  String _did = "did:ethr:0x199254bf2a7b5d0c705cdb1648f4165e64364696";
  String _pk = "aef5cf1fb3fbb832384c4ba388a5f4ed232731da8c8e5d4a8841fb93b7552806";
  String _jwt = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NkstUiJ9.eyJpYXQiOjE1NzUxNjIzMDIsImV4cCI6MTU3NTE2MjkwMiwicmVxdWVzdGVkIjpbIm5hbWUiXSwidmVyaWZpZWQiOlsiVXBvcnRsYW5kaWEgQ2l0eSBJRCJdLCJjYWxsYmFjayI6Imh0dHBzOi8vZTJhOTk5ZTEubmdyb2suaW8vY2FsbGJhY2siLCJ0eXBlIjoic2hhcmVSZXEiLCJpc3MiOiJkaWQ6ZXRocjoweGJjM2FlNTliYzc2Zjg5NDgyMjYyMmNkZWY3YTIwMThkYmUzNTM4NDAifQ.al5TOFpdQu-Y_ZlhjsbxfdAswADiPiBKP8Ybf4hHkS5PU2xmo9I2CnmMEbxEEphiB-YGU7n5aqAlkcOpdok2MQA";//me.uport:request/eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NkstUiJ9.eyJpYXQiOjE1NzQ4ODI5NzAsImV4cCI6MTU3NDg4MzA5MCwicmVxdWVzdGVkIjpbIm5hbWUiXSwidmVyaWZpZWQiOlsiVXBvcnRsYW5kaWEgQ2l0eSBJRCJdLCJwZXJtaXNzaW9ucyI6WyJub3RpZmljYXRpb25zIl0sImNhbGxiYWNrIjoiaHR0cHM6Ly9hcGkudXBvcnQubWUvY2hhc3F1aS90b3BpYy9UWXpNVnZEUXoiLCJ2YyI6WyIvaXBmcy9RbWRXbnNnRDlOdVFjQmF1VThlQXJ4Uk1Da2JEUTQycThtaUNoYjZ3b0htUlRSIl0sImFjdCI6Im5vbmUiLCJ0eXBlIjoic2hhcmVSZXEiLCJpc3MiOiJkaWQ6ZXRocjoweGFiMjU4YTE3MjU2Y2NlZGI5MjJkNjgwYTVkZDIwNGJhNmI5ODFmMDkifQ.N72Nfug-YiEXemCtLJfApJlb0mGvX-YXGGv2JQ1zTz6ZOh7xLxEuQ4Itgc7hG7jD4mWrkL-P9kT_mweQRrivBAE";
  Future<String> _barcodeString;
  Map<String, dynamic> _parsedJwt;

  Map<String, dynamic> parseJwt(String token) {
    final request = token.split('/');
    final path = request[request.length-1].split('?');
    final parts = path[0].split('.');
    
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String issueJWT() {
    var builder = new JWTBuilder()
      ..issuer = _did
      ..audience='did:ethr:0xbc3ae59bc76f894822622cdef7a2018dbe353840'
      ..expiresAt = new DateTime.now().add(new Duration(minutes: 3))
      ..setClaim('own', {'name': 'Ash'});
    
    ECPrivateKey key = new ECPrivateKey(d, parameters)

    var signer = new ES256Signer(pair);

    var signedToken = builder.getSignedToken(signer);

    return signedToken.toString();
  }


  bool validateJWT(String stringToken) {
    var isValid=false;
    var decodedToken = new JWT.parse(stringToken);
    //var signer = new JWTHmacSha256Signer('sharedSecret');
    //if(decodedToken.verify(signer)){
      var validator = new JWTValidator() // uses DateTime.now() by default
        ..issuer = 'did:ethr:0xbc3ae59bc76f894822622cdef7a2018dbe353840'; // set claims you wish to validate
      Set<String> errors = validator.validate(decodedToken);
      print(errors); // (empty list)
      isValid=(errors.length==0);
    //} 
    return isValid;
}



void makePostRequest() async {
  // set up POST request arguments
  var jwtResponse = issueJWT();
  String url = _parsedJwt['callback'];
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"access_token": "$jwtResponse"}';
  // make POST request
  Response response = await post(url, headers: headers, body: json);
  // check the status code for the result
  int statusCode = response.statusCode;
  // this API passes back the id of the new item added to the body
  String body = response.body;
  // {
  //   "title": "Hello",
  //   "body": "body text",
  //   "userId": 1,
  //   "id": 101
  // }
}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('QR Code Reader'),
      ),
      body: new Center(
          child: new FutureBuilder<String>(
              future: _barcodeString,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if(snapshot.data != null){
                  _jwt = snapshot.data;
                }
                _parsedJwt = parseJwt(_jwt);
                //makePostRequest();
                return new Text(json.encode(_parsedJwt));
              }),              
              ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
                final addressService = AddressService(null);
                final privateKey = addressService.getPrivateKey(
                  "analyst end eye apple burden trust snack question feature monkey dinner loan");
                print(privateKey);
          setState(() {
            _barcodeString = new QRCodeReader()
                .setAutoFocusIntervalInMs(200)
                .setForceAutoFocus(true)
                .setTorchEnabled(true)
                .setHandlePermissions(true)
                .setExecuteAfterPermissionGranted(true)
                .scan();            
          });
        },
        tooltip: 'Read the QRCode',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }
}