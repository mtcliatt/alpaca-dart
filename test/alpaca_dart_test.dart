import 'dart:io';

import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:alpaca_dart/src/alpaca_api.dart';
import 'util/mocks.dart';

const fakeBaseUrl = 'fake_base_url';
const fakeDataBaseUrl = 'fake_data_base_url';
const fakeKeyId = '123';
const fakeSecretKey = '12345';

const fullHeaders = {
  HttpHeaders.contentTypeHeader: 'application/json',
  'APCA-API-KEY-ID': fakeKeyId,
  'APCA-API-SECRET-KEY': fakeSecretKey,
};

// TODO: Add tests for orders.
// TODO: Add tests for positions.

void main() {
  AlpacaApi api;
  MockClient mockClient = AlpacaMockitoClient();

  void verifyGetRequest(String path, [Map<String, String> params]) {
    final expectedUri = params == null
        ? Uri.https(fakeBaseUrl, path)
        : Uri.https(fakeBaseUrl, path, params);

    verify(mockClient.get(
      expectedUri,
      headers: fullHeaders,
    ));
  }

  void verifyDataRequest(String path, [Map<String, String> params]) {
    final expectedUri = params == null
        ? Uri.https(fakeDataBaseUrl, path)
        : Uri.https(fakeDataBaseUrl, path, params);

    verify(mockClient.get(
      expectedUri,
      headers: fullHeaders,
    ));
  }

  group('Alpaca', () {
    setUp(() {
      api = AlpacaApi(
          baseUrl: fakeBaseUrl,
          dataBaseUrl: fakeDataBaseUrl,
          client: mockClient,
          keyId: fakeKeyId,
          secretKey: fakeSecretKey);
    });

    group('Alpaca API', () {
      group('account', () {
        test('get', () async {
          final expectedPath = 'v1/account';

          await api.getAccount();

          verifyGetRequest(expectedPath);
        });
      });

      group('clock', () {
        test('GET', () async {
          final expectedPath = 'v1/clock';

          await api.getClock();

          verifyGetRequest(expectedPath);
        });
      });

      group('calendar', () {
        test('GET', () async {
          final expectedPath = 'v1/calendar';

          await api.getCalendar();

          verifyGetRequest(expectedPath);
        });
      });

      group('asset', () {
        test('getAsset', () async {
          final assetId = '123';
          final expectedPath = 'v1/assets/$assetId';

          await api.getAsset(assetId);

          verifyGetRequest(expectedPath);
        });

        test('getAssets', () async {
          final expectedPath = 'v1/assets';

          await api.getAssets();

          verifyGetRequest(expectedPath);
        });

        test('getAssets w/ status', () async {
          final expectedPath = 'v1/assets';
          final statusValue = 'active';
          final expectedParams = {'status': statusValue};

          await api.getAssets(status: statusValue);

          verifyGetRequest(expectedPath, expectedParams);
        });

        test('getAssets w/ assetClass', () async {
          final expectedPath = 'v1/assets';
          final assetClassValue = 'us_equity';
          final expectedParams = {'asset_class': assetClassValue};

          await api.getAssets(assetClass: assetClassValue);

          verifyGetRequest(expectedPath, expectedParams);
        });

        test('getAssets w/ status and assetClass', () async {
          final expectedPath = 'v1/assets';
          final statusValue = 'active';
          final assetClassValue = 'us_equity';
          final expectedParams = {
            'status': statusValue,
            'asset_class': assetClassValue,
          };

          await api.getAssets(status: statusValue, assetClass: assetClassValue);

          verifyGetRequest(expectedPath, expectedParams);
        });

        test('getAssets throws with bad status value', () async {
          final badStatus = 'not good lol';

          final getAssets = () => api.getAssets(status: badStatus);

          expect(getAssets, throwsA(const TypeMatcher<ArgumentError>()));
        });

        test('getAsset throws when given an empty ID', () async {
          final badId = '';

          final getAsset = () => api.getAsset(badId);

          expect(getAsset, throwsA(const TypeMatcher<ArgumentError>()));
        });
      });

      group('position', () {
        test('getPositions', () async {
          final symbol = 'SPY';
          final expectedPath = 'v1/positions/$symbol';

          await api.getPosition(symbol);

          verifyGetRequest(expectedPath);
        });

        test('getPosition', () async {
          final expectedPath = 'v1/positions';

          await api.getPositions();

          verifyGetRequest(expectedPath);
        });

        test('getPosition throws when given an empty symbol', () async {
          final badSymbol = '';

          final getPosition = () => api.getPosition(badSymbol);

          expect(getPosition, throwsA(const TypeMatcher<ArgumentError>()));
        });
      });
    });

    group('Alpaca Data API', () {
      group('bars', () {
        test('getBars throws with bad timeframe argument', () async {
          final badTimeframe = '17 years or something';
          final goodSymbol = 'SPY';

          final getBars = () => api.getBars(badTimeframe, goodSymbol);

          expect(getBars, throwsA(const TypeMatcher<ArgumentError>()));
        });

        test('getBars throws with bad symbols argument', () async {
          final goodTimeframe = '1min';
          final badSymbol = 123;  // is not a String or List of Strings.

          final getBars = () => api.getBars(goodTimeframe, badSymbol);

          expect(getBars, throwsA(const TypeMatcher<ArgumentError>()));
        });

        test('getBars with timeframe and single symbol', () async {
          final timeframe = '1Min';
          final symbol = 'SPY';
          final expectedPath = 'v1/bars/$timeframe';
          final expectedParams = {
            'symbols': symbol,
          };

          await api.getBars(timeframe, symbol);

          verifyDataRequest(expectedPath, expectedParams);
        });

        test('getBars with timeframe and a list of symbols', () async {
          final timeframe = '1Min';
          final symbols = ['SPY', 'QQQ', 'DIA'];
          final expectedPath = 'v1/bars/$timeframe';
          final expectedParams = {
            'symbols': symbols.join(','),
          };

          await api.getBars(timeframe, symbols);

          verifyDataRequest(expectedPath, expectedParams);
        });
      });
    });

  });
}
