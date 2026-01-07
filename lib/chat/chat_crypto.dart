import 'dart:convert';
import 'dart:developer';
import 'package:encrypt/encrypt.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pointycastle/asymmetric/api.dart';

class ChatCrypto {

  static String decryptMessage(String encryptedBase64) {
    log(_privateKeyPem.toString(), name: "_privateKeyPem.toString()");
    try {
      final parser = RSAKeyParser();
      final RSAPrivateKey privateKey =
          parser.parse(_privateKeyPem) as RSAPrivateKey;

      final encrypter = Encrypter(
        RSA(privateKey: privateKey, encoding: RSAEncoding.OAEP),
      );

      final encrypted = Encrypted(base64Decode(encryptedBase64));
      return encrypter.decrypt(encrypted);
    } catch (e) {
      return '[رسالة غير قابلة للفك]';
    }
  }

  static const String _privateKeyPem = '''
-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6Gpt45J1lfq6vfo1UhWm\nUC8SbPVj8XCCKCM0rMYxA3cSLmCfe9CivFEO/Zd9G/ehsOexjN1TsrrBZcX2NrTO\ngMbIXVhslIs43JuIHXM2sjd6VnMFm3Tb2RbhbB0PQWl2t3NrIwO1ddCC6GHib/lU\nuJ7El381w8tL6ix9ACzD11dMZ7A1UXeAWkBhIWMyeB4gyofg6VgBbQXO6qwrQcgc\nPeThlOvuUqGmATCKp2pMvkoSnOTdA4SOehhwT5/8NTWP5Juozr5ex5oMm/CPCC4J\n/O6GEORynkv5TdDSsgD14E1sbHRG06Q7w1XiqraZ/bLb6695ybXqxKmTt0J9RXyU\nRQIDAQAB\n-----END PUBLIC KEY-----\n
''';

  static String decryptRsa(String base64Cipher) {
    // String _privateKeyPem = GetStorage().read('publicKey');
    // log(_privateKeyPem.toString(), name: "_privateKeyPem.toString()");
    final priv = RSAKeyParser().parse(_privateKeyPem) as RSAPrivateKey;
    final encrypter = Encrypter(RSA(privateKey: priv));

    final encrypted = Encrypted.fromBase64(base64Cipher);
    return encrypter.decrypt(encrypted);
  }
}
