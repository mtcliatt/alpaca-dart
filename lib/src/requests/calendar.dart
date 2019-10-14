import 'package:alpaca/src/alpaca_api.dart';

/// Contains all calendar-related requests.
class Calendar {
  static AlpacaRequest get({DateTime start, DateTime end}) {
    final Map<String, String> params = {};

    if (start != null) {
      params['start'] = '$start';
    }

    if (end != null) {
      params['end'] = '$end';
    }

    return AlpacaRequest.get('/v2/calendar', params);
  }
}
