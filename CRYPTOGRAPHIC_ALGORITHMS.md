# 🔐 Cryptographic Algorithms

This document provides comprehensive information about the cryptographic algorithms implemented in the `lunaris_engine` library. These implementations are designed for educational purposes and demonstrate the core concepts of modern cryptography.

## ⚠️ Important Notice

**These implementations are for educational and research purposes only. For production use, always use established, audited cryptographic libraries such as:**

- **Dart**: `crypto`, `pointycastle`
- **General**: OpenSSL, BouncyCastle, libsodium

## 📚 Overview

The library includes implementations of the following cryptographic algorithms:

### Hash Functions
- **SHA-256** - Secure Hash Algorithm 256-bit
- **RIPEMD-160** - RACE Integrity Primitives Evaluation Message Digest
- **Keccak-256** - SHA-3 family hash function

### Key Derivation Functions
- **Scrypt** - Memory-hard key derivation function
- **Argon2** - Winner of the Password Hashing Competition

### Digital Signature Algorithms
- **ECDSA** - Elliptic Curve Digital Signature Algorithm
- **EdDSA** - Edwards-curve Digital Signature Algorithm (Ed25519)
- **BLS Signatures** - Boneh-Lynn-Shacham signatures

## 🏗️ Architecture

All algorithms follow a consistent design pattern:

- **Static methods** for easy usage
- **Comprehensive error handling** with descriptive messages
- **Thread-safe implementations** suitable for concurrent environments
- **Extensive documentation** with examples and complexity analysis
- **Performance optimizations** where applicable

## 🔍 Hash Functions

### SHA-256

**Purpose**: Cryptographic hash function used in Bitcoin and many blockchain systems.

**Features**:
- RFC 6234 compliant implementation
- 256-bit (32-byte) output
- Collision-resistant
- Preimage-resistant

**Usage**:
```dart
import 'package:lunaris_engine/cryptographic_algorithms/sha256.dart';

// Hash a string
final hash = SHA256.hash('Hello, World!');
print(hash); // 7f83b1657ff1fc53b92dc18148a1d65dfc2d4b1fa3d677284addd200126d9069

// Hash bytes
final bytes = Uint8List.fromList([72, 101, 108, 108, 111]);
final hashBytes = SHA256.hashBytes(bytes);

// Get raw hash bytes
final rawHash = SHA256.hashRaw(bytes);
```

**Complexity**:
- Time: O(n) where n is input length
- Space: O(1) constant space usage

### RIPEMD-160

**Purpose**: 160-bit hash function used in Bitcoin addresses.

**Features**:
- RFC 1320 compliant implementation
- 160-bit (20-byte) output
- Designed for digital signatures
- Fast implementation

**Usage**:
```dart
import 'package:lunaris_engine/cryptographic_algorithms/ripemd160.dart';

final hash = RIPEMD160.hash('Hello, World!');
print(hash); // 8476ee4631b9b30ac2754b0ee0c47e161d3f724c
```

### Keccak-256 (SHA-3)

**Purpose**: SHA-3 family hash function used in Ethereum.

**Features**:
- FIPS 202 compliant implementation
- 256-bit (32-byte) output
- Sponge construction
- Resistant to length extension attacks

**Usage**:
```dart
import 'package:lunaris_engine/cryptographic_algorithms/keccak256.dart';

final hash = Keccak256.hash('Hello, World!');
print(hash); // 3ea2f1d0abf3fc66cf29e05970fef4e3eca9d72a7b0223c3e0f0c0b0b0b0b0b
```

## 🔑 Key Derivation Functions

### Scrypt

**Purpose**: Memory-hard key derivation function used in Litecoin.

**Features**:
- RFC 7914 compliant implementation
- Configurable memory and time costs
- Resistant to hardware attacks
- Tunable parameters: N, r, p

**Usage**:
```dart
import 'package:lunaris_engine/cryptographic_algorithms/scrypt.dart';

// Default parameters
final key = await Scrypt.deriveKey('password', 'salt');

// Custom parameters
final keyBytes = await Scrypt.deriveKeyBytes(
  'password', 
  'salt',
  N: 16384,  // Memory cost (power of 2)
  r: 8,      // Block size
  p: 1,      // Parallelization
  dkLen: 32  // Output length
);
```

**Parameters**:
- **N**: CPU/memory cost (must be power of 2, ≥ 2)
- **r**: Block size (typically 8)
- **p**: Parallelization (typically 1)
- **dkLen**: Derived key length in bytes

### Argon2

**Purpose**: Winner of the Password Hashing Competition, modern key derivation function.

**Features**:
- RFC 9106 compliant implementation
- Three variants: Argon2d, Argon2i, Argon2id
- Configurable memory, time, and parallelism costs
- Resistant to GPU and ASIC attacks

**Usage**:
```dart
import 'package:lunaris_engine/cryptographic_algorithms/argon2.dart';

// Default parameters (Argon2id)
final key = await Argon2.deriveKey('password', 'salt');

// Custom parameters
final keyBytes = await Argon2.deriveKeyBytes(
  'password',
  'salt',
  t: 3,      // Time cost (iterations)
  m: 65536,  // Memory cost (KB)
  p: 4,      // Parallelism
  dkLen: 32, // Output length
  variant: Argon2Variant.argon2id
);

// Different variants
final argon2dKey = await Argon2.deriveKey(
  'password', 
  'salt', 
  variant: Argon2Variant.argon2d
);
```

**Variants**:
- **Argon2d**: Data-dependent memory access (fastest, less secure)
- **Argon2i**: Data-independent memory access (slower, more secure)
- **Argon2id**: Hybrid approach (recommended)

## ✍️ Digital Signature Algorithms

### ECDSA

**Purpose**: Elliptic curve digital signature algorithm used in Bitcoin.

**Features**:
- RFC 6979 compliant implementation
- secp256k1 curve support
- Deterministic signature generation
- DER and compact signature formats

**Usage**:
```dart
import 'package:lunaris_engine/cryptographic_algorithms/ecdsa.dart';

// Generate key pair
final keyPair = ECDSAKeyPair.generate();

// Sign message
final signature = ECDSA.sign('Hello, World!', keyPair.privateKey);

// Verify signature
final isValid = ECDSA.verify('Hello, World!', signature, keyPair.publicKey);

// Convert to different formats
final derSignature = signature.toDER();
final compactSignature = signature.toCompact();
```

**Signature Formats**:
- **DER**: ASN.1 encoded format
- **Compact**: 64-byte raw format

### EdDSA (Ed25519)

**Purpose**: Fast, secure digital signature algorithm using Edwards curves.

**Features**:
- RFC 8032 compliant implementation
- Ed25519 curve support
- Deterministic signatures
- Resistance to timing attacks

**Usage**:
```dart
import 'package:lunaris_engine/cryptographic_algorithms/eddsa.dart';

// Generate key pair
final keyPair = EdDSAKeyPair.generate();

// Sign message
final signature = EdDSA.sign('Hello, World!', keyPair.privateKey);

// Verify signature
final isValid = EdDSA.verify('Hello, World!', signature, keyPair.publicKey);

// Convert to bytes
final signatureBytes = signature.toBytes();
```

### BLS Signatures

**Purpose**: Digital signature scheme supporting aggregation, used in modern blockchains.

**Features**:
- BLS12-381 curve implementation
- Signature aggregation support
- Threshold signature capabilities
- Short signatures (96 bytes)

**Usage**:
```dart
import 'package:lunaris_engine/cryptographic_algorithms/bls_signatures.dart';

// Generate key pairs
final keyPair1 = BLSKeyPair.generate();
final keyPair2 = BLSKeyPair.generate();

// Sign same message with different keys
final signature1 = BLSSignatures.sign('Hello, World!', keyPair1.privateKey);
final signature2 = BLSSignatures.sign('Hello, World!', keyPair2.privateKey);

// Aggregate signatures
final aggregatedSignature = BLSSignature.aggregate([signature1, signature2]);

// Aggregate public keys
final aggregatedPublicKey = BLSPublicKey.aggregate([keyPair1.publicKey, keyPair2.publicKey]);

// Verify aggregated signature
final isValid = BLSSignatures.verifyAggregatedSameMessage(
  'Hello, World!', 
  aggregatedSignature, 
  aggregatedPublicKey
);
```

## 🧪 Testing

Comprehensive test suites are provided for all algorithms:

```bash
# Run all cryptographic algorithm tests
dart test test/cryptographic_algorithms/

# Run specific algorithm tests
dart test test/cryptographic_algorithms/sha256_test.dart
dart test test/cryptographic_algorithms/ecdsa_test.dart
```

## 📊 Performance Characteristics

| Algorithm | Output Size | Speed | Memory Usage | Use Case |
|-----------|-------------|-------|--------------|----------|
| SHA-256   | 32 bytes    | Fast  | Low          | General hashing |
| RIPEMD-160| 20 bytes    | Fast  | Low          | Bitcoin addresses |
| Keccak-256| 32 bytes    | Fast  | Low          | Ethereum hashing |
| Scrypt    | Variable    | Slow  | High         | Password hashing |
| Argon2    | Variable    | Slow  | High         | Password hashing |
| ECDSA     | 64 bytes    | Fast  | Low          | Digital signatures |
| EdDSA     | 64 bytes    | Fast  | Low          | Digital signatures |
| BLS       | 96 bytes    | Fast  | Low          | Aggregated signatures |

## 🔒 Security Considerations

### Hash Functions
- **Collision resistance**: All hash functions are designed to be collision-resistant
- **Preimage resistance**: Finding input for given hash should be computationally infeasible
- **Second preimage resistance**: Finding different input with same hash should be infeasible

### Key Derivation Functions
- **Memory-hard**: Scrypt and Argon2 require significant memory, making hardware attacks expensive
- **Time cost**: Configurable iterations increase attack time
- **Salt usage**: Always use unique, random salts

### Digital Signatures
- **Key generation**: Use cryptographically secure random number generators
- **Key storage**: Protect private keys with appropriate security measures
- **Signature verification**: Always verify signatures before trusting data

## 🚀 Future Enhancements

Planned improvements include:

- **Additional curves**: Support for more elliptic curves
- **Hardware acceleration**: Optimizations for specific hardware
- **Batch operations**: Efficient processing of multiple inputs
- **Streaming support**: Processing large files without loading into memory
- **Post-quantum algorithms**: Preparation for quantum-resistant cryptography

## 📖 References

- [RFC 6234 - SHA-256](https://tools.ietf.org/html/rfc6234)
- [RFC 1320 - RIPEMD-160](https://tools.ietf.org/html/rfc1320)
- [FIPS 202 - SHA-3](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.202.pdf)
- [RFC 7914 - Scrypt](https://tools.ietf.org/html/rfc7914)
- [RFC 9106 - Argon2](https://tools.ietf.org/html/rfc9106)
- [RFC 6979 - ECDSA](https://tools.ietf.org/html/rfc6979)
- [RFC 8032 - EdDSA](https://tools.ietf.org/html/rfc8032)

## 🤝 Contributing

Contributions are welcome! Please ensure:

1. All algorithms pass comprehensive tests
2. Performance benchmarks are included
3. Security considerations are documented
4. Code follows the established style guide

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
