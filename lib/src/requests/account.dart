import 'package:alpaca/src/alpaca_api.dart';

/// Contains all account-related requests.
class Account {
  static AlpacaRequest get() => AlpacaRequest.get('/v2/account');
}
