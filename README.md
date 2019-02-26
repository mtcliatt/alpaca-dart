A Dart wrapper for the Alpaca REST API.

## Usage

A simple usage example:

```dart
import 'package:alpaca_dart/alpaca_dart.dart';

main() {
  var alpaca = AlpacaApi(
    keyId: '...',
    secretKey: '...',
  );
  
  final accountResponse = await api.getAccount();
  final account = jsonDecode(accountResponse.body);
  
  final status = account['status'] == 'ACTIVE' ? 'Active' : 'Inactive';
  
  print('Account ID: ${account['id']}');
  print('Account status: $status');
  print('Cash value: ${account['cash']}');
  print('Portfolio value: ${account['portfolio_value']}');
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://github.com/mtcliatt/alpaca-dart/issues
