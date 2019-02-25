import 'package:alpaca_dart/src/alpaca_api.dart';

/// Contains all account-related requests.
class Account {
  static AlpacaRequest get() => AlpacaRequest.get('/v1/account');
}
