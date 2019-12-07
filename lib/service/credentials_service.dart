/*
import 'dart:math';
import 'dart:typed_data';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';

/// Credentials that can sign payloads with an Ethereum private key.
class ECPrivateKey extends Credentials {
  final Uint8List privateKey;
  EthereumAddress _cachedAddress;

  ECPrivateKey(this.privateKey);

  ECPrivateKey.fromHex(String hex) : privateKey = hexToBytes(hex);

  /// Creates a new, random private key from the [random] number generator.
  ///
  /// For security reasons, it is very important that the random generator used
  /// is cryptographically secure. The private key could be reconstructed by
  /// someone else otherwise. Just using [Random()] is a very bad idea! At least
  /// use [Random.secure()].
  factory ECPrivateKey.createRandom(Random random) {
    final key = generateNewPrivateKey(random);
    return ECPrivateKey(intToBytes(key));
  }

  @override
  final bool isolateSafe = true;

  @override
  Future<EthereumAddress> extractAddress() async {
    return _cachedAddress ??= EthereumAddress(
        publicKeyToAddress(privateKeyBytesToPublic(privateKey)));
  }

  @override
  Future<MsgSignature> signToSignature(Uint8List payload, {int chainId}) async {
    final signature = _globalSign(keccak256(payload), privateKey);

    // https://github.com/ethereumjs/ethereumjs-util/blob/8ffe697fafb33cefc7b7ec01c11e3a7da787fe0e/src/signature.ts#L26
    // be aware that signature.v already is recovery + 27
    final chainIdV =
        chainId != null ? (signature.v - 27 + (chainId * 2 + 35)) : signature.v;

    return MsgSignature(signature.r, signature.s, chainIdV);
  }
}

*/