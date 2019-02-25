import 'dart:io';

import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:alpaca_dart/src/alpaca_api.dart';
import 'util/mocks.dart';

const fakeBaseUrl = 'fake_base_url';
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

  group('A group of tests', () {
    setUp(() {
      api = AlpacaApi(
          baseUrl: fakeBaseUrl,
          client: mockClient,
          keyId: fakeKeyId,
          secretKey: fakeSecretKey);
    });

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
  });
}
