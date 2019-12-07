import 'dart:typed_data';
import "package:pointycastle/pointycastle.dart";
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:sacco/sacco.dart';
class ES256Signer implements JWTSigner {
  String get algorithm => 'ES256K-R';
  final Wallet _wallet;
  ES256Signer(Wallet wallet) : _wallet = wallet;

  /*final AsymmetricKeyPair<PublicKey, PrivateKey> pair;

  ES256Signer({
    this.pair,
  });*/

  @override
  List<int> sign(List<int> data) {
  
    final pcSigner = Signer("SHA-256/DET-ECDSA");
    pcSigner.init(
      true,
      PrivateKeyParameter(_wallet.ecPrivateKey),
    );
    
    final ECSignature sig = pcSigner.generateSignature(data);
    return Uint8List.fromList(
      _intToBytes(sig.r) + _intToBytes(sig.s),
    );    
    /*var length = 32;
    var bytes = Uint8List(length * 2);
    bytes.setRange(0, length, _bigIntToBytes(sig.r, length).toList().reversed);
    bytes.setRange(length, length * 2, _bigIntToBytes(sig.s, length).toList().reversed);
    return bytes;*/
  }

  @override
  bool verify(List<int> data, List<int> signature) {
    final verifier = Signer("SHA-256/DET-ECDSA");
    verifier.init(false, PublicKeyParameter(_wallet.ecPublicKey));
    final sig = ECSignature(
      _bigIntFromBytes(signature.take(32)),
      _bigIntFromBytes(signature.skip(32)),
    );
    return verifier.verifySignature(data, sig);
  }
}

final _b256 = BigInt.from(256);

Iterable<int> _bigIntToBytes(BigInt v, int length) sync* {
  for (var i = 0; i < length; i++) {
    yield (v % _b256).toInt();
    v = v ~/ _b256;
  }
}

BigInt _bigIntFromBytes(Iterable<int> bytes) {
  return bytes.fold(BigInt.zero, (a, b) => a * _b256 + BigInt.from(b));
}

final BigInt _byteMask = BigInt.from(0xff);
Uint8List _intToBytes(BigInt number) => _encodeBigInt(number);
Uint8List _encodeBigInt(BigInt number) {
    final size = (number.bitLength + 7) >> 3;
    final result = Uint8List(size);
    var num = number;
    for (var i = 0; i < size; i++) {
      result[size - i - 1] = (num & _byteMask).toInt();
      num = num >> 8;
    }
    return result;
  }