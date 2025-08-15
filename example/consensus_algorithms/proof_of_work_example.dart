import 'dart:convert';
import 'package:lunaris_engine/Consensus/proof_of_work.dart';

BigInt simpleHash(String data, int nonce) {
  final s = utf8.encode(data + nonce.toString());
  var h = 0;
  for (var b in s) {
    h = (h * 31 + b) & 0x7fffffff;
  }
  return BigInt.from(h);
}

void main() {
  final pow = ProofOfWork(hashFn: simpleHash, seed: 42);
  final res = pow.mine('block-1', BigInt.from(1000), maxAttempts: 10000);
  print(
    'nonce=${res.nonce} hash=${res.hash} attempts=${res.attempts} success=${res.success}',
  );
}
