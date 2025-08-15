import 'package:lunaris_engine/Consensus/proof_of_work.dart';
import 'package:test/test.dart';

BigInt trivialHash(String data, int nonce) {
  // simple deterministic hash useful for tests
  return data.codeUnits.fold<BigInt>(
    BigInt.from(nonce),
    (p, e) => (p + BigInt.from(e)) & BigInt.from(0x7fffffff),
  );
}

void main() {
  group('ProofOfWork', () {
    test('mine finds solution under easy target', () {
      final pow = ProofOfWork(hashFn: trivialHash, seed: 1);
      final res = pow.mine('block', BigInt.from(1000000), maxAttempts: 1000);
      expect(res.attempts, lessThanOrEqualTo(1000));
    });
  });
}
