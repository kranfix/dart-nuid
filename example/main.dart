import 'package:nuid/nuid.dart';

void main() {
  final nuid = Nuid.instance;

  print('String:');
  print('  First nuid:');
  for (var i = 0; i < 4; i++) {
    print('  - ${nuid.next()}');
  }

  print('  Reseting nuid:');
  nuid.reset();

  for (var i = 0; i < 4; i++) {
    print('  - ${nuid.next()}');
  }

  print('\nBytes:');
  print('  First nuid:');
  for (var i = 0; i < 4; i++) {
    print('  - ${nuid.nextBytes()}');
  }

  print('  Reseting nuid:');
  nuid.reset();

  for (var i = 0; i < 4; i++) {
    print('  - ${nuid.nextBytes()}');
  }
}
