import 'package:flutter/material.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:http/http.dart';
import 'package:sacco/sacco.dart';
import 'package:my_app/service/ES256S.dart';
import 'package:hex/hex.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:web3dart/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:my_app/service/jwt_service.dart';
import 'dart:typed_data';



class MyWallet with ChangeNotifier{
  static String _mnemonic = "analyst end eye apple burden trust snack question feature monkey dinner loan";
  final networkInfo = NetworkInfo(id:"ec", bech32Hrp: "ec", lcdUrl: "");
  JWT _jwt = JWT.parse("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c");

  Map<String, dynamic> get claims => _jwt.claims;

  void load(String token){
    _jwt = JWT.parse(token);
    print(claims);

    notifyListeners();
  }


  void requestCredentials(String token) async {
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

    var parsedJwt = JWT.parse(token);
    var jwtResponse = await issueJWT(did, parsedJwt.issuer, token, 'name', hdnode.privateKey);
        
    String url = parsedJwt.getClaim('callbackUrl');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"access_token": "$jwtResponse"}';
    Response resp = await post(url, headers: headers, body: json);

    load(resp.body);
  }

  void initCredentials(String token) async{
    Response resp = await get('https://cc6b6971.ngrok.io');
    print(resp.body);

    requestCredentials(resp.body);
  }


  Future<String> issueJWT(var iss, var aud, var req, cred, Uint8List privateKey) async{
    var builder = new JWTBuilder()
      ..issuer = iss //'did:ethr:0xb9c5714089478a327f09197987f16f9e5d936e8a'
      ..audience= aud //'did:ethr:0xbc3ae59bc76f894822622cdef7a2018dbe353840'
      ..expiresAt = new DateTime.now().add(new Duration(minutes: 3))
      ..setClaim('type', 'shareResp')
      ..setClaim('own', cred)
      ..setClaim('req', req)
      ..setClaim('verified', req);

    ES256S signer = new ES256S(privateKey);
    var signedToken = await builder.getSignedToken(signer);
    return signedToken.toString();
  }

  JWT parseJwt(String token) {
    final request = token.split('/');
    final path = request[request.length-1].split('?');
    return JWT.parse(path[0]);
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

}