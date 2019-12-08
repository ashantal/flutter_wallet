import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pointycastle/digests/ripemd160.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:http/http.dart';
import 'package:randombytes/randombytes.dart';
import 'dart:convert';
import 'package:sacco/sacco.dart';
import 'package:my_app/service/ES256S.dart';
import 'package:my_app/service/jwt_service.dart';
import 'package:hex/hex.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:keccak/keccak.dart' as keccak;
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart' as w3;

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
  static String _mnemonic = "analyst end eye apple burden trust snack question feature monkey dinner loan";
  final networkInfo = NetworkInfo(id:"ec", bech32Hrp: "ec", lcdUrl: "");
  //static String _path="m/7696500'/0'/0'/0'";
  String _did_issuer = "did:ethr:0x199254bf2a7b5d0c705cdb1648f4165e64364696";
  String _did_audience = "did:ethr:0xbc3ae59bc76f894822622cdef7a2018dbe353840";
  static String _jwt = 
  "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NkstUiJ9.eyJpYXQiOjE1NzU4MzA4MDIsImV4cCI6MTU3NTgzMTQwMiwicmVxdWVzdGVkIjpbIm5hbWUiXSwidmVyaWZpZWQiOlsiVXBvcnRsYW5kaWEgQ2l0eSBJRCJdLCJjYWxsYmFjayI6Imh0dHBzOi8vODAyNjU5ZmMubmdyb2suaW8vY2FsbGJhY2siLCJ0eXBlIjoic2hhcmVSZXEiLCJpc3MiOiJkaWQ6ZXRocjoweGJjM2FlNTliYzc2Zjg5NDgyMjYyMmNkZWY3YTIwMThkYmUzNTM4NDAifQ.7fkW_9qGdZvcSsTpzJwUDK9j0TTipkITOLM0A2fBHUoQPuvVBBx_YjX8qeUrF1hXFsHGWPEf5MSbYf7wQLFGMAE";  //me.uport:request/eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NkstUiJ9.eyJpYXQiOjE1NzQ4ODI5NzAsImV4cCI6MTU3NDg4MzA5MCwicmVxdWVzdGVkIjpbIm5hbWUiXSwidmVyaWZpZWQiOlsiVXBvcnRsYW5kaWEgQ2l0eSBJRCJdLCJwZXJtaXNzaW9ucyI6WyJub3RpZmljYXRpb25zIl0sImNhbGxiYWNrIjoiaHR0cHM6Ly9hcGkudXBvcnQubWUvY2hhc3F1aS90b3BpYy9UWXpNVnZEUXoiLCJ2YyI6WyIvaXBmcy9RbWRXbnNnRDlOdVFjQmF1VThlQXJ4Uk1Da2JEUTQycThtaUNoYjZ3b0htUlRSIl0sImFjdCI6Im5vbmUiLCJ0eXBlIjoic2hhcmVSZXEiLCJpc3MiOiJkaWQ6ZXRocjoweGFiMjU4YTE3MjU2Y2NlZGI5MjJkNjgwYTVkZDIwNGJhNmI5ODFmMDkifQ.N72Nfug-YiEXemCtLJfApJlb0mGvX-YXGGv2JQ1zTz6ZOh7xLxEuQ4Itgc7hG7jD4mWrkL-P9kT_mweQRrivBAE";
  Future<String> _barcodeString;
  JWT _parsedJwt = JWT.parse(_jwt);

  JWT parseJwt(String token) {
    final request = token.split('/');
    final path = request[request.length-1].split('?');
    return JWT.parse(path[0]);
  }

  Future<String> issueJWT(String did, Uint8List privateKey) async{
    var builder = new JWTBuilder()
      ..issuer = did //'did:ethr:0xb9c5714089478a327f09197987f16f9e5d936e8a'
      ..audience= _parsedJwt.issuer //'did:ethr:0xbc3ae59bc76f894822622cdef7a2018dbe353840'
      ..expiresAt = new DateTime.now().add(new Duration(minutes: 3))
      ..setClaim('type', 'shareResp')
      ..setClaim('own', {'name': 'Ash'})
      ..setClaim('req', _jwt);

    ES256S signer = new ES256S(privateKey);
    var signedToken = await builder.getSignedToken(signer);
    return signedToken.toString();
  }


  bool validateJWT(String stringToken) {
    var isValid=false;
    /*var decodedToken = new JWT.parse(stringToken);
    var signer = new JWTHmacSha256Signer('sharedSecret');
    if(decodedToken.verify(signer)){
      var validator = new JWTValidator() // uses DateTime.now() by default
        ..issuer = 'did:ethr:0xbc3ae59bc76f894822622cdef7a2018dbe353840'; // set claims you wish to validate
      Set<String> errors = validator.validate(decodedToken);
      print(errors); // (empty list)
      isValid=(errors.length==0);
    }*/ 
    return isValid;
}



void makePostRequest() async {
  // set up POST request arguments
final seed = bip39.mnemonicToSeed(_mnemonic);
print("seed 0x${HEX.encode(seed)}");  
final root = bip32.BIP32.fromSeed(seed);

var path = "m/7696500'/0'/0'/0'";          
var hdnode = root.derivePath(path);
var secp256k1 = ECCurve_secp256k1();
var point = secp256k1.G;
// Compute the curve point associated to the private key
var bigInt = BigInt.parse(HEX.encode(hdnode.privateKey), radix: 16);
var curvePoint = point * bigInt;

//var creds = w3.EthPrivateKey.fromHex(HEX.encode(hdnode.privateKey));
//var extractAddress = await creds.extractAddress();
//print("did:ethr:${extractAddress.hex}");

// Get the public key
//var pubKey = curvePoint.getEncoded(); //32 bit
var pubBytes = curvePoint.getEncoded(false).sublist(1);
const int shaBytes = 256 ~/ 8;
var hashed = sha3digest.process(pubBytes);
var address = Uint8List.view(hashed.buffer, shaBytes - 20);

final did = "did:ethr:0x${HEX.encode(address)}";
print("----- did -----");
print("$did");
print("----- pu -----");
print("${HEX.encode(pubBytes)}");
print("------priv-----");
print("${HEX.encode(hdnode.privateKey)}");
print("-------JWT-----");

var jwtResponse = await issueJWT(did,hdnode.privateKey);
print("$jwtResponse");

    
  String url = _parsedJwt.getClaim('callback');
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"access_token": "$jwtResponse"}';
  Response response = await post(url, headers: headers, body: json);
  print(response.statusCode);
  print(response.body);
  
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
                  _parsedJwt = parseJwt(snapshot.data);
                }                
                makePostRequest();
                return new Text(json.encode(_jwt));
              }),              
              ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
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
