import 'dart:convert';

import 'package:alpaca_dart/src/alpaca_api.dart';

main() async {
  var api = AlpacaApi(
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

