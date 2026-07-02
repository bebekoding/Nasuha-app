import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// Envelope written when the user enables a password.
///
/// Layout (JSON):
/// ```
/// {
///   "v": 1,
///   "kdf": "pbkdf2-sha256",
///   "iter": 200000,
///   "salt": "<base64>",
///   "nonce": "<base64>",
///   "mac": "<base64>",
///   "ct": "<base64>"
/// }
/// ```
class EncryptedEnvelope {
  static const int version = 1;
  static const int iterations = 200000;
  static const int saltLength = 16;
  static const int nonceLength = 12;

  final int v;
  final String kdf;
  final int iter;
  final Uint8List salt;
  final Uint8List nonce;
  final Uint8List mac;
  final Uint8List ciphertext;

  const EncryptedEnvelope({
    required this.v,
    required this.kdf,
    required this.iter,
    required this.salt,
    required this.nonce,
    required this.mac,
    required this.ciphertext,
  });

  String toJsonString() => jsonEncode({
        'v': v,
        'kdf': kdf,
        'iter': iter,
        'salt': base64Encode(salt),
        'nonce': base64Encode(nonce),
        'mac': base64Encode(mac),
        'ct': base64Encode(ciphertext),
      });

  factory EncryptedEnvelope.fromJsonString(String s) {
    final m = jsonDecode(s) as Map<String, dynamic>;
    return EncryptedEnvelope(
      v: m['v'] as int,
      kdf: m['kdf'] as String,
      iter: m['iter'] as int,
      salt: base64Decode(m['salt'] as String),
      nonce: base64Decode(m['nonce'] as String),
      mac: base64Decode(m['mac'] as String),
      ciphertext: base64Decode(m['ct'] as String),
    );
  }
}

class BackupCrypto {
  final _aes = AesGcm.with256bits();

  /// Encrypts [plaintext] with [password] using AES-256-GCM and a key derived
  /// via PBKDF2-HMAC-SHA256. Returns the envelope as a JSON string.
  Future<String> encrypt(String plaintext, String password) async {
    final salt = _randomBytes(EncryptedEnvelope.saltLength);
    final nonce = _randomBytes(EncryptedEnvelope.nonceLength);

    final key = await _deriveKey(password, salt);
    final box = await _aes.encrypt(
      utf8.encode(plaintext),
      secretKey: key,
      nonce: nonce,
    );

    return EncryptedEnvelope(
      v: EncryptedEnvelope.version,
      kdf: 'pbkdf2-sha256',
      iter: EncryptedEnvelope.iterations,
      salt: salt,
      nonce: nonce,
      mac: Uint8List.fromList(box.mac.bytes),
      ciphertext: Uint8List.fromList(box.cipherText),
    ).toJsonString();
  }

  /// Decrypts an envelope produced by [encrypt]. Throws on bad password / tampering.
  Future<String> decrypt(String envelopeJson, String password) async {
    final env = EncryptedEnvelope.fromJsonString(envelopeJson);
    final key = await _deriveKey(password, env.salt);
    final box = SecretBox(
      env.ciphertext,
      nonce: env.nonce,
      mac: Mac(env.mac),
    );
    final clear = await _aes.decrypt(box, secretKey: key);
    return utf8.decode(clear);
  }

  /// Quick sniff: does this payload look like an encrypted envelope?
  bool isEnvelope(String s) {
    try {
      final m = jsonDecode(s);
      return m is Map &&
          m['kdf'] == 'pbkdf2-sha256' &&
          m['ct'] is String &&
          m['nonce'] is String;
    } catch (_) {
      return false;
    }
  }

  Future<SecretKey> _deriveKey(String password, Uint8List salt) async {
    final kdf = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: EncryptedEnvelope.iterations,
      bits: 256,
    );
    return kdf.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
  }

  Uint8List _randomBytes(int length) {
    final r = Random.secure();
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = r.nextInt(256);
    }
    return bytes;
  }
}
