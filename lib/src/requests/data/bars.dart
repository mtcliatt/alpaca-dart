import 'package:alpaca_dart/src/alpaca_api.dart';

/// Contains all bars-related requests.
class Bars {
  static AlpacaDataRequest get(String timeframe, symbols,
      {String limit, String start, String end, String after, String until}) {

    final Map<String, String> params = {};

    if (timeframe != 'minute' && timeframe != '1Min' && timeframe != '5Min'
        && timeframe != '15Min' && timeframe != '1D' && timeframe != 'day') {
      throw ArgumentError('Invalid timeframe: $timeframe');
    }

    if (symbols != null && symbols is !String && symbols is !List<String>) {
      throw ArgumentError('symbols must be a String or List of Strings.');
    }

    params['symbols'] = symbols is List<String> ? symbols.join(',') : symbols;

    return AlpacaDataRequest('v1/bars/${timeframe}', params);
  }
}
