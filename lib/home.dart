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
  Future<String> _barcodeString;
  String _jwt;

  JWT parseJwt(String token) {
    final request = token.split('/');
    final path = request[request.length-1].split('?');
    return JWT.parse(path[0]);
  }

  Future<String> issueJWT(var iss, var aud, var req, Uint8List privateKey) async{
    var builder = new JWTBuilder()
      ..issuer = iss //'did:ethr:0xb9c5714089478a327f09197987f16f9e5d936e8a'
      ..audience= aud //'did:ethr:0xbc3ae59bc76f894822622cdef7a2018dbe353840'
      ..expiresAt = new DateTime.now().add(new Duration(minutes: 3))
      ..setClaim('type', 'shareResp')
      ..setClaim('own', {'name': 'Ash'})
      ..setClaim('req', req)
      ..setClaim('verified', _jwt);

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

void shareCredentials() async {
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

Response resp = await get('https://db8818d6.ngrok.io');
print(resp.body);
_jwt = resp.body;
     
var parsedJwt = JWT.parse(_jwt);
var jwtResponse = await issueJWT(did, parsedJwt.issuer, _jwt, hdnode.privateKey);
    
  String url = parsedJwt.getClaim('callbackUrl');
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"access_token": "$jwtResponse"}';
  resp = await post(url, headers: headers, body: json);

  var creds = JWT.parse(resp.body);
  print(creds.claims);
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
                shareCredentials();
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
