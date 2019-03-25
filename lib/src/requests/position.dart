import 'package:alpaca/src/alpaca_api.dart';

/// Contains all position-related requests.
class Position {
  /// Retrieves a list of the account's open positions.
  static AlpacaRequest get() => AlpacaRequest.get('/v1/positions');

  /// Retrieves the account’s open position for the given symbol.
  ///
  /// Required parameters:
  ///   symbol: symbol or asset_id.
  static AlpacaRequest getOne(String symbol) {
    if (symbol == null || symbol.isEmpty) {
      throw ArgumentError('symbol must be a non-empty String: $symbol');
    }

    return AlpacaRequest.get('/v1/positions/$symbol');
  }
}
