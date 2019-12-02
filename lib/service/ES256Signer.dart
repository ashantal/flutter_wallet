import 'dart:typed_data';
import "package:pointycastle/pointycastle.dart";
import 'package:corsac_jwt/corsac_jwt.dart';

class ES256Signer implements JWTSigner {
  String get algorithm => 'ES256';

  final AsymmetricKeyPair<PublicKey, PrivateKey> pair;

  ES256Signer({
    this.pair,
  });

  @override
  List<int> sign(List<int> data) {
    final pcSigner = Signer("SHA-256/DET-ECDSA");
    pcSigner.init(
      true,
      PrivateKeyParameter(pair.privateKey),
    );
    final ECSignature sig = pcSigner.generateSignature(data);
    var length = 32;
    var bytes = Uint8List(length * 2);
    bytes.setRange(0, length, _bigIntToBytes(sig.r, length).toList().reversed);
    bytes.setRange(
        length, length * 2, _bigIntToBytes(sig.s, length).toList().reversed);
    return bytes;
  }

  @override
  bool verify(List<int> data, List<int> signature) {
    final verifier = Signer("SHA-256/DET-ECDSA");
    verifier.init(false, PublicKeyParameter(pair.publicKey));
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