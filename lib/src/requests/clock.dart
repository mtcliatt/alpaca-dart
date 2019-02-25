import 'package:alpaca_dart/src/alpaca_api.dart';

/// Contains all clock-related requests.
class Clock {
  static AlpacaRequest get() => AlpacaRequest.get('/v1/clock');
}
