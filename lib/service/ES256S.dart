import 'dart:math';
import 'dart:typed_data';
import 'package:hex/hex.dart';
import 'package:my_app/service/jwt_service.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/signers/ecdsa_signer.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart' as web3;
class ES256S implements JWTSigner {
  String get algorithm => 'ES256K-R';
  final Uint8List _key; 

  ES256S(Uint8List key) : _key = key;

  @override
  Future<List<int>> sign(List<int> data) async{
    final k = ECK(_key);
    List<int> sigList = await k.sign(Uint8List.fromList(data));
    return sigList;

    //why is the length 64 when recover index is == 0        ??????
    //Bug Uint8List + operator ???
  }

  @override
  bool verify(List<int> data, List<int> signature) {
    return false;
  }
}

class ECK extends web3.EthPrivateKey{
  ECK(Uint8List privateKey) : super(privateKey);
  
  @override
  Future<MsgSignature> signToSignature(Uint8List payload, {int chainId}) async {
 // final signature = await super.signToSignature(payload); 

  final message = SHA256Digest().process(payload);
  //final message = keccak256(payload);

  final ECDomainParameters _params = ECCurve_secp256k1();
  final BigInt _halfCurveOrder = _params.n >> 1;

  final digest = SHA256Digest();
  final signer = ECDSASigner(null, HMac(digest, 64));
  final key = ECPrivateKey(bytesToInt(privateKey), _params);

  signer.init(true, PrivateKeyParameter(key));
  var sig = signer.generateSignature(message) as ECSignature;

  /*
	This is necessary because if a message can be signed by (r, s), it can also
	be signed by (r, -s (mod N)) which N being the order of the elliptic function
	used. In order to ensure transactions can't be tampered with (even though it
	would be harmless), Ethereum only accepts the signature with the lower value
	of s to make the signature for the message unique.
	More details at
	https://github.com/web3j/web3j/blob/master/crypto/src/main/java/org/web3j/crypto/ECDSASignature.java#L27
	 */
  if (sig.s.compareTo(_halfCurveOrder) > 0) {
    final canonicalisedS = _params.n - sig.s;
    sig = ECSignature(sig.r, canonicalisedS);
  }
  final pubBytes = privateKeyBytesToPublic(privateKey);
  final publicKey = bytesToInt(pubBytes);


print("----- searching for pub bytes -----");
print("${HEX.encode(pubBytes)}");
print("$publicKey");
print("-----------------------------------");

  //Implementation for calculating v naively taken from there, I don't understand
  //any of this.
  //https://github.com/web3j/web3j/blob/master/crypto/src/main/java/org/web3j/crypto/Sign.java
  var recId = -1;
  for (var i = 0; i < 4; i++) {
    final k = recoverFromSignature(i, sig, message, _params);
    if (k == publicKey) {
      recId = i;
      break;
    }
  }

  if (recId == -1) {
    print('Could not construct a recoverable key. This should never happen');
    throw Exception(
        'Could not construct a recoverable key. This should never happen');
  }



    //var rBytes = intToBytes(sig.r).toList().reversed;
    //var sBytes = intToBytes(sig.s).toList().reversed;
    //bytes.setRange(0, 32, rBytes);
    //bytes.setRange(32,64, sBytes);
    //print(bytes);
  
  return MsgSignature(sig.r, sig.s, recId);
    //return MsgSignature(signature.r, signature.s, 1/*signature.v-27*/);
  }

  int fromBytes(var rBytes){
    var n=0;
    final int8List = new Int8List(rBytes.length);
    var list = rBytes.toList();
    list.forEach((i)=>
       int8List[n]=i
    );
    var bdata = new ByteData.view(int8List.buffer);
    return bdata.getInt32(0);
  }


  BigInt recoverFromSignature(
    int recId, ECSignature sig, Uint8List msg, ECDomainParameters params) {
  final n = params.n;
  final i = BigInt.from(recId ~/ 2);
  final x = sig.r + (i * n);

  //Parameter q of curve
  final prime = BigInt.parse(
      'fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f',
      radix: 16);
  if (x.compareTo(prime) >= 0) return null;

  final R = _decompressKey(x, (recId & 1) == 1, params.curve);
  if (!(R * n).isInfinity) return null;

  final e = bytesToInt(msg);

  final eInv = (BigInt.zero - e) % n;
  final rInv = sig.r.modInverse(n);
  final srInv = (rInv * sig.s) % n;
  final eInvrInv = (rInv * eInv) % n;

  final q = (params.G * eInvrInv) + (R * srInv);

  final bytes = q.getEncoded(false);
  return bytesToInt(bytes.sublist(1));
}
ECPoint _decompressKey(BigInt xBN, bool yBit, ECCurve c) {
  List<int> x9IntegerToBytes(BigInt s, int qLength) {
    //https://github.com/bcgit/bc-java/blob/master/core/src/main/java/org/bouncycastle/asn1/x9/X9IntegerConverter.java#L45
    final bytes = intToBytes(s);

    if (qLength < bytes.length) {
      return bytes.sublist(0, bytes.length - qLength);
    } else if (qLength > bytes.length) {
      final tmp = List<int>.filled(qLength, 0);

      final offset = qLength - bytes.length;
      for (var i = 0; i < bytes.length; i++) {
        tmp[i + offset] = bytes[i];
      }

      return tmp;
    }

    return bytes;
  }

  final compEnc = x9IntegerToBytes(xBN, 1 + ((c.fieldSize + 7) ~/ 8));
  compEnc[0] = yBit ? 0x03 : 0x02;
  return c.decodePoint(compEnc);
}
}