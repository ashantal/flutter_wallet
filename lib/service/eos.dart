/*import 'package:eosdart_ecc/eosdart_ecc.dart';

eosTest(String key) {
  // Construct the EOS private key from string
  EOSPrivateKey privateKey = EOSPrivateKey.fromString(key);

  // Get the related EOS public key
  EOSPublicKey publicKey = privateKey.toEOSPublicKey();
  // Print the EOS public key
  print(publicKey.toString());

  // Going to sign the data
  String data = 'blah....blah...';

  // Sign
  EOSSignature signature = privateKey.signString(data);
  // Print the EOS signature
  print(signature.toString());

  // Verify the data using the signature
  var v =signature.verify(data, publicKey);

  print(v);
}

eosTestSeed(String seed) {
  // Construct the EOS private key from string
  EOSPrivateKey privateKey = EOSPrivateKey.fromSeed(seed);

  print(privateKey.toString());
  // Get the related EOS public key
  EOSPublicKey publicKey = privateKey.toEOSPublicKey();
  // Print the EOS public key
  print(publicKey.toString());

  // Going to sign the data
  String data = 'blah....blah...';

  // Sign
  EOSSignature signature = privateKey.signString(data);
  // Print the EOS signature
  print(signature.toString());

  // Verify the data using the signature
  var v =signature.verify(data, publicKey);

  print(v);
}*/