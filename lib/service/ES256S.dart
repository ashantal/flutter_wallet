import 'dart:math';
import 'dart:typed_data';
import 'package:my_app/service/jwt_service.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart' as web3;
class ES256S implements JWTSigner {
  String get algorithm => 'ES256K-R';
  final Uint8List _key; 

  ES256S(Uint8List key) : _key = key;

  @override
  Future<List<int>> sign(List<int> data) async{
    final k = ECK(_key);
    final key = web3.EthPrivateKey(_key);
    //final key = ECK(Random.secure());
    List<int> sigList = await k.sign(Uint8List.fromList(data));
    return sigList;
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
    final signature = await super.signToSignature(payload); 

    return MsgSignature(signature.r, signature.s, signature.v-27);
  }
}