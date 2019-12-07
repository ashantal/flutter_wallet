import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:sacco/sacco.dart';

class ECSigner implements JWTSigner {
  final Wallet _wallet;

  ECSigner(Wallet wallet) : _wallet = wallet;

  @override
  String get algorithm => 'ES256K';

  @override
  List<int> sign(List<int> body) {
    return _wallet.signTxData(String.fromCharCodes(body));
  }

  @override
  bool verify(List<int> body, List<int> signature) {
    var actual = sign(body);
    if (actual.length == signature.length) {
      // constant-time comparison
      bool isEqual = true;
      for (var i = 0; i < actual.length; i++) {
        if (actual[i] != signature[i]) isEqual = false;
      }
      return isEqual;
    } else
      return false;
  }
}