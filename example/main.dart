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