import 'package:alpaca_dart/src/alpaca_api.dart';

/// Contains all order-related requests.
class Order {
  /// Attempts to cancel an open order.
  ///
  /// If the order is no longer cancelable (example: status=order_filled), the
  /// server will respond with status 422, and reject the request.
  static AlpacaRequest cancel(String orderId) {
    if (orderId == null || orderId.isEmpty) {
      throw ArgumentError('orderId must be a non-empty String.');
    }

    return AlpacaRequest.delete('/v1/orders/$orderId');
  }

  /// Retrieves a single order for the given [orderId].
  static AlpacaRequest getOne(String orderId) {
    if (orderId == null || orderId.isEmpty) {
      throw ArgumentError('orderId must be a non-empty String.');
    }

    return AlpacaRequest.get('/v1/orders/$orderId');
  }

  /// Retrieves a single order for the given [clientOrderId].
  static AlpacaRequest getByClientOrderId(String clientOrderId) {
    if (clientOrderId == null || clientOrderId.isEmpty) {
      throw ArgumentError('clientOrderId must be a non-empty String.');
    }

    return AlpacaRequest.get(
        '/v1/orders:by_client_order_id', {'client_order_id': clientOrderId});
  }

  /// Retrieves a list of orders for the account,
  /// filtered by the supplied query parameters.
  ///
  /// Optional parameters:
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
      if (limit < 1 || limit > 500) {
        throw ArgumentError('limit must be a positive number <=500: $limit');
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

  /// Places a new order for the given account.
  ///
  /// An order request may be rejected if the account is not authorized for
  /// trading, or if the tradable balance is insufficient to fill the order.
  static AlpacaRequest create(
    String symbol,
    String quantity,
    String side,
    String type,
    String timeInForce, {
    String limitPrice,
    String stopPrice,
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

    if (side != 'buy' && side != 'buy') {
      throw ArgumentError('side must be buy or sell: $side');
    }

    if (type != 'market' &&
        type != 'limit' &&
        type != 'stop' &&
        type != 'stop_limit') {
      throw ArgumentError(
          'type must be market, limit, stop, or stop_limit: $type');
    }

    if (timeInForce != 'day' && timeInForce != 'gtc' && timeInForce != 'opg') {
      throw ArgumentError('timeInForce must be day, gtc, or opg: $timeInForce');
    }

    if (type == 'limit' || type == 'stop_limit') {
      if (limitPrice == null) {
        throw ArgumentError(
            'limitPrice must be specified for order type: $type');
      }
    }

    if (type == 'stop' || type == 'stop_limit') {
      if (stopPrice == null) {
        throw ArgumentError(
            'stopPrice must be specified for order type: $type');
      }
    }

    return AlpacaRequest.post('/v1/orders', params);
  }
}
