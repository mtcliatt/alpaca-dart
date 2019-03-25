A Dart wrapper for the Alpaca REST API.

## Examples

Fetch the last 2 closing prices for the S&P, Nasdaq, and Dow Jones indices.
```dart
import 'dart:convert';

import 'package:alpaca_dart/alpaca_dart.dart';

main() async {
  var alpaca = AlpacaApi(
    keyId: '...',
    secretKey: '...',
    paperTrading: true,
  );

  final accountResponse = await alpaca.getAccount();
  final account = jsonDecode(accountResponse.body);

  final status = account['status'] == 'ACTIVE' ? 'Active' : 'Inactive';

  print('Account ID: ${account['id']}');
  print('Account status: $status');
  print('Cash value: ${account['cash']}');
  print('Portfolio value: ${account['portfolio_value']}');
  print('\n');

  final watchlist = ['SPY', 'DIA', 'QQQ'];
  final timeframe = 'day', limit = 2;

  final barsResponse = await alpaca.getBars(timeframe, watchlist, limit: limit);
  final barsJson = jsonDecode(barsResponse.body);

  for (final symbol in watchlist) {
    final bars = barsJson[symbol];

    for (final bar in bars) {
      print('(${bar['t']}): ${bar['c']}');
    }
  }
}
}
```

## Issues and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://github.com/mtcliatt/alpaca-dart/issues
