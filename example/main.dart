import '../nuid.dart';

void main() {
  for(var i = 0; i < 4; i++){
    print(nuid.next());
  }

  print('\nReseting nuid:');
  nuid.reset();

  for(var i = 0; i < 4; i++){
    print(nuid.next());
  }
}
