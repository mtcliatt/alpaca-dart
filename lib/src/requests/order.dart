import 'package:alpaca_dart/src/alpaca_api.dart';

/// Contains all order-related requests.
// TODO: add documentation for all requests.
// TODO: use proper type for each query parameter.
// TODO: enforce parameter requirements (e.g., limit must be <500).

class Order {
  static AlpacaRequest cancel(String orderId) {
    if (orderId == null || orderId.isEmpty) {
      throw ArgumentError('orderId must be a non-empty String.');
    }

    return AlpacaRequest.delete('/v1/orders/$orderId');
  }

  static AlpacaRequest getOne(String orderId) {
    if (orderId == null || orderId.isEmpty) {
      throw ArgumentError('orderId must be a non-empty String.');
    }

    return AlpacaRequest.get('/v1/orders/$orderId');
  }

  static AlpacaRequest getByClientOrderId(String clientOrderId) {
    if (clientOrderId == null || clientOrderId.isEmpty) {
      throw ArgumentError('clientOrderId must be a non-empty String.');
    }

    return AlpacaRequest.get('/v1/orders:by_client_order_id',
          {'client_order_id': clientOrderId});
  }

  /// Retrieves a list of orders for the account,
  /// filtered by the supplied query parameters.
  ///
  /// Query parameters:
  ///   status: Order status to be queried. open, closed or all. Default: open.
  ///   limit: The maximum number of orders in response. Default: 50, max: 500.
  ///   after: The response will include only ones submitted after
  ///       this timestamp (exclusive.)
  ///   until: The response will include only ones submitted until
  ///       this timestamp (exclusive.)
  ///   direction: The chronological order of response based on the
  ///       submission time. asc or desc. Defaults to desc.
  static AlpacaRequest get({
    String status,
    int limit,
    DateTime after,
    DateTime until,
    String direction,
  }) {
    final params = {};

    if (after != null) {
      params['after'] = after;
    }

    if (until != null) {
      params['until'] = until;
    }

    if (status != null) {
      if (status != 'open' && status != 'closed' && status != 'all') {
        throw ArgumentError('status must be open, closed, or all: $status');
      } else {
        params['status'] = status;
      }
    }

    if (limit != null) {
      if (limit < 0 || limit > 500) {
        throw ArgumentError('limit must be a positive number <500: $limit');
      } else {
        params['limit'] = limit;
      }
    }

    if (direction != null) {
      if (direction != 'asc' && direction != 'desc') {
        throw ArgumentError('direction must be asc or desc: $direction');
      } else {
        params['direction'] = direction;
      }
    }

    return AlpacaRequest.get('/v1/assets', params);
  }


  static AlpacaRequest create(
    String symbol,
    String quantity,
    String side,
    String type,
    String timeInForce,
    String limitPrice,
    String stopPrice, {
    String clientOrderId,
  }) {
    final params = {
      'symbol': symbol,
      'qty': quantity,
      'side': side,
      'type': type,
      'time_in_force': timeInForce,
      'limit_price': limitPrice,
      'stop_price': stopPrice,
      'client_order_id': clientOrderId,
    }..removeWhere((k, v) => v == null || v.isEmpty);

    return AlpacaRequest.post('/v1/orders', params);
  }
}
