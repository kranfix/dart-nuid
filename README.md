# dart-nuid

A Dart-lang implementation of [NATS](https://nats.io) Unique Identifiers
inspired by [node-nuid](https://github.com/nats-io/node-nuid) like UUID,
but much faster and lighter.
The NUID contains numbers and capital letters only, i.e. it works with base 36.

## Examples:

Run the `example/main.dart`:

```
dart example/main.dart
```

```dart
import 'package:nuid/nuid.dart';

void main() {
  print('String:');
  print('  First nuid:');
  for(var i = 0; i < 4; i++){
    print('  - ${nuid.next()}');
  }

  print('  Reseting nuid:');
  nuid.reset();

  for(var i = 0; i < 4; i++){
    print('  - ${nuid.next()}');
  }

  print('\nBytes:');
  print('  First nuid:');
  for(var i = 0; i < 4; i++){
    print('  - ${nuid.nextBytes()}');
  }

  print('  Reseting nuid:');
  nuid.reset();

  for(var i = 0; i < 4; i++){
    print('  - ${nuid.nextBytes()}');
  }
}
```

As code above shows, there are two methods: `next` and `nextBytes`.
They return the nuid in a `String` and `List<int>` format respectively.
The lastone is designed to be compatible with `Socket` in `dart:io` library.

## Performance

NUID needs to be very fast to generate and be truly unique, all while being entropy pool friendly.
NUID uses 12 bytes of crypto generated data (entropy draining), and 10 bytes of pseudo-random sequential data that increments with a pseudo-random increment.

Total length of a NUID string is 22 bytes of base 36 ascii text, so 36^22 or 17324272922341479351919144385642496 possibilities.
