import 'package:alpaca/src/alpaca_api.dart';

/// Contains all clock-related requests.
class Clock {
  static AlpacaRequest get() => AlpacaRequest.get('/v2/clock');
}
