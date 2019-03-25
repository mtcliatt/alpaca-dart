import 'package:alpaca/src/alpaca_api.dart';

/// Contains all asset-related requests.
class Asset {
  /// Get an asset for the given symbol or asset ID.
  ///
  /// Required parameters:
  ///   assetIdentifier: symbol or asset_id.
  static AlpacaRequest getOne(String symbol) {
    if (symbol == null || symbol.isEmpty) {
      throw ArgumentError('symbol must be non-empty: $symbol');
    }

    return AlpacaRequest.get('/v1/assets/$symbol');
  }

  /// Get a list of assets.
  ///
  /// By default all assets will be returned.
  /// Optional parameters:
  ///   status: "active" or "inactive". By default, all statuses are included.
  ///   assetClass: Defaults to "us_equity" (no other values at this time).
  static AlpacaRequest get({String status, String assetClass}) {
    final Map<String, String> params = {};

    if (status != null) {
      if (status != 'active' && status != 'inactive') {
        throw ArgumentError('status must be active or inactive: $status');
      } else {
        params['status'] = '$status';
      }
    }

    if (assetClass != null) {
      params['asset_class'] = '$assetClass';
    }

    return AlpacaRequest.get('/v1/assets', params);
  }
}
