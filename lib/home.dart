import 'package:flutter/material.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:sacco/sacco.dart';
import 'package:my_app/service/ES256S.dart';
import 'package:my_app/service/jwt_service.dart';
import 'package:hex/hex.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;

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
  static String _path="m/7696500'/0'/0'/0'";
  final networkInfo = NetworkInfo(id:"ec", bech32Hrp: "ec", lcdUrl: "");
  String _did = "did:ethr:0x199254bf2a7b5d0c705cdb1648f4165e64364696";
  String _pk = "b3a39ebac976a45c9c439741ffa26bfd5fd0cdcabf4ccf2d627cc8b26d0f398a";
  static String _jwt = 
  "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NkstUiJ9.eyJpYXQiOjE1NzU2OTc4OTAsImV4cCI6MTU3NTY5ODQ5MCwicmVxdWVzdGVkIjpbIm5hbWUiXSwidmVyaWZpZWQiOlsiVXBvcnRsYW5kaWEgQ2l0eSBJRCJdLCJjYWxsYmFjayI6Imh0dHBzOi8vOWVhOGRmN2Yubmdyb2suaW8vY2FsbGJhY2siLCJ0eXBlIjoic2hhcmVSZXEiLCJpc3MiOiJkaWQ6ZXRocjoweGJjM2FlNTliYzc2Zjg5NDgyMjYyMmNkZWY3YTIwMThkYmUzNTM4NDAifQ.kscGK47t25RDHDWB0-aJ8rgfpp67JlESf5o4gT2wq_Yl6V22arJz0tP8fUuJTzESE7XKWAuBO4OBvJbx7i3xUQA";  //me.uport:request/eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NkstUiJ9.eyJpYXQiOjE1NzQ4ODI5NzAsImV4cCI6MTU3NDg4MzA5MCwicmVxdWVzdGVkIjpbIm5hbWUiXSwidmVyaWZpZWQiOlsiVXBvcnRsYW5kaWEgQ2l0eSBJRCJdLCJwZXJtaXNzaW9ucyI6WyJub3RpZmljYXRpb25zIl0sImNhbGxiYWNrIjoiaHR0cHM6Ly9hcGkudXBvcnQubWUvY2hhc3F1aS90b3BpYy9UWXpNVnZEUXoiLCJ2YyI6WyIvaXBmcy9RbWRXbnNnRDlOdVFjQmF1VThlQXJ4Uk1Da2JEUTQycThtaUNoYjZ3b0htUlRSIl0sImFjdCI6Im5vbmUiLCJ0eXBlIjoic2hhcmVSZXEiLCJpc3MiOiJkaWQ6ZXRocjoweGFiMjU4YTE3MjU2Y2NlZGI5MjJkNjgwYTVkZDIwNGJhNmI5ODFmMDkifQ.N72Nfug-YiEXemCtLJfApJlb0mGvX-YXGGv2JQ1zTz6ZOh7xLxEuQ4Itgc7hG7jD4mWrkL-P9kT_mweQRrivBAE";
  Future<String> _barcodeString;
  JWT _parsedJwt = JWT.parse(_jwt);

  JWT parseJwt(String token) {
    final request = token.split('/');
    final path = request[request.length-1].split('?');
    return JWT.parse(path[0]);
  }

  Future<String> issueJWT() async{
    var builder = new JWTBuilder()
      ..issuer = _did
      ..audience='did:ethr:0xbc3ae59bc76f894822622cdef7a2018dbe353840'
      ..expiresAt = new DateTime.now().add(new Duration(minutes: 3))
      ..setClaim('type', 'shareResp')
      ..setClaim('own', {'name': 'Ash'})
      ..setClaim('req', _jwt);
    Wallet wallet = Wallet.derive(_mnemonic.split(" "), _path, networkInfo);

    //prv b3a39ebac976a45c9c439741ffa26bfd5fd0cdcabf4ccf2d627cc8b26d0f398a
    //pub 029f1f4a350c5527220501e8aae1ff9992cb6a19b3440917bcd2f67852702d0984
    ES256S signer = new ES256S(wallet.privateKey);

    var signedToken = await builder.getSignedToken(signer);

/*
    var w=Wallet.derive(m.split(" "), "m/7696500'/0'/0'/0'", networkInfo);
    print(base64.encode(w.publicKey));
    print(base64.encode(w.address));
    var w1=Wallet.derive(m.split(" "), "m/7696500'/1'/0'/0'", networkInfo);
    print(base64.encode(w1.publicKey));
    print(base64.encode(w1.address));
    var w2=Wallet.derive(m.split(" "), "m/7696500'/2'/0'/0'", networkInfo);
    print(base64.encode(w2.publicKey));
    print(base64.encode(w2.address));
 */

    print(signedToken);
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

for(var a=0;a<4;a++){
    for(var n=0;n<=4;n++){
        for(var i=0;i<=4;i++){
          var path = "m/7696500'/$a'/$n'/$i";
          
          /*var hdnode = root.derivePath(path);
          var secp256k1 = ECCurve_secp256k1();
          var point = secp256k1.G;
          // Compute the curve point associated to the private key
          var bigInt = BigInt.parse(HEX.encode(hdnode.privateKey), radix: 16);
          var curvePoint = point * bigInt;
          // Get the public key
          var key0 = curvePoint.getEncoded();
          print("$path 0x${HEX.encode(key0)}"); 
*/
          var key1 = Wallet.derive(_mnemonic.split(" "), path, networkInfo).publicKey;
          print("$path 0x${HEX.encode(key1)}");

          //var add = Wallet.derive(_mnemonic.split(" "), path, networkInfo).address;
          //print("address 0x${HEX.encode(add)}");

        }        
    }
}  
  
  /*var jwtResponse = await issueJWT();
  
  String url = _parsedJwt.getClaim('callback');
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"access_token": "$jwtResponse"}';
  Response response = await post(url, headers: headers, body: json);
  print(response.statusCode);
  print(response.body);
  */
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

                /*    
                String seed = bip39.mnemonicToSeedHex(_mnemonic);
                print(seed);
                bip32.BIP32 root = bip32.BIP32.fromSeed(HEX.decode(seed));
                bip32.BIP32 child = root.derivePath(_path);
                String privateKey = HEX.encode(child.privateKey);
                print(privateKey);
                */

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
