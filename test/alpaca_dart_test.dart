import 'package:alpaca_dart/src/alpaca_api.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    AlpacaApi api;

    setUp(() {
      api = AlpacaApi();
    });

    test('First Test', () {
      expect(api, isNotNull);
    });
  });
}
