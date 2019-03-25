import 'dart:convert';

import 'package:alpaca/alpaca.dart';

main() async {
  var alpaca = AlpacaApi(
    keyId: 'PK7EQG7Q3RVC6DK4BY99',
    secretKey: 'H5QpmT/QmBoADSDpUeI35GqIvu0C/oYXjTI2DquM',
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
