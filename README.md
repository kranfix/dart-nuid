# dart-nuid

A Dart-lang implementation of [NATS](https://nats.io) Unique Identifiers
inspired by [node-nuid](https://github.com/nats-io/node-nuid)
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
    print('  - ${nuid.next_bytes()}');
  }

  print('  Reseting nuid:');
  nuid.reset();

  for(var i = 0; i < 4; i++){
    print('  - ${nuid.next_bytes()}');
  }
}
```

As code above shows, there are two methods: `next` and `next_bytes`.
They return the nuid in a `String` and `List<int>` format respectively.
The lastone is designed to be compatible with `Socket` in `dart:io` library.
