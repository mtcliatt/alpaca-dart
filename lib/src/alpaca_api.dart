import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';

const _alpacaBaseUrl = 'api.alpaca.markets';
const _alpacaPaperBaseUrl = 'paper-api.alpaca.markets';

class AlpacaApi {
  final BaseClient _client;
  final String _baseUrl;
  final String _keyId;
  final String _secretKey;

  AlpacaApi({
    BaseClient client,
    String keyId,
    String secretKey,
    String baseUrl,
    String paperBaseUrl,
    bool paperTrading = false,
  })  : _client = client ?? HttpClient(),
        _keyId = keyId,
        _secretKey = secretKey,
        _baseUrl = paperTrading
            ? (paperBaseUrl ?? _alpacaPaperBaseUrl)
            : (baseUrl ?? _alpacaBaseUrl);

  Future<Response> getAccount() => _executeRequest('/v1/account');

  Future<Response> getCalendar({String start, String end}) {
    final params = {'start': start, 'end': end};

    return _executeRequest('/v1/calendar', params: params);
  }

  Future<Response> getClock() => _executeRequest('/v1/clock');

  Future<Response> getAssets({String status, String assetClass}) {
    final params = {'status': status, 'asset_class': assetClass};

    return _executeRequest('/v1/assets', params: params);
  }

  Future<Response> getAsset({String assetIdentifier}) =>
      _executeRequest('/v1/assets/$assetIdentifier');

  Future<Response> getPositions() => _executeRequest('/v1/positions');

  Future<Response> getPosition(String positionIdentifier) =>
      _executeRequest('/v1/positions/$positionIdentifier');

  Future<Response> cancelOrder(String orderId) =>
      _executeRequest('/v1/orders/$orderId', method: 'DELETE');

  Future<Response> getOrder(String orderIdentifier) =>
      _executeRequest('/v1/orders/$orderIdentifier');

  Future<Response> getOrderByClientOrderId(String clientOrderId) =>
      _executeRequest('/v1/orders:by_client_order_id/$clientOrderId');

  Future<Response> getOrders(
    String symbol,
    String quantity,
    String side,
    String type,
    String timeInForce,
    String limitPrice,
    String stopPrice,
    String clientOrderId,
  ) {
    final params = {
      'symbol': symbol,
      'qty': quantity,
      'side': side,
      'type': type,
      'time_in_force': timeInForce,
      'limit_price': limitPrice,
      'stop_price': stopPrice,
      'client_order_id': clientOrderId,
    };

    return _executeRequest('/v1/assets', params: params);
  }

  Future<Response> createOrder(
    String status,
    String limit,
    String after,
    String until,
    String direction,
  ) {
    final params = {
      'status': status,
      'limit': limit,
      'after': after,
      'until': until,
      'direction': direction,
    };

    return _executeRequest('/v1/orders', params: params, method: 'POST');
  }

  Future<Response> _executeRequest(String requestPath,
      {Map<String, String> params = const {}, String method = 'GET'}) async {
    switch (method) {
      case 'DELETE':
        return _client.delete(
          Uri(
            host: _baseUrl,
            scheme: 'https',
            path: requestPath,
          ),
          headers: {
            'APCA-API-KEY-ID': _keyId,
            'APCA-API-SECRET-KEY': _secretKey,
          },
        );

      case 'POST':
        return _client.post(
          Uri(
            host: _baseUrl,
            scheme: 'https',
            path: requestPath,
          ),
          body: params,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'APCA-API-KEY-ID': _keyId,
            'APCA-API-SECRET-KEY': _secretKey,
          },
        );

      case 'GET':
      default:
        return _client.get(
          Uri(
            host: _baseUrl,
            scheme: 'https',
            path: requestPath,
            queryParameters: params,
          ),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'APCA-API-KEY-ID': _keyId,
            'APCA-API-SECRET-KEY': _secretKey,
          },
        );
    }
  }
}
