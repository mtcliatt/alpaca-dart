import 'package:alpaca/src/alpaca_api.dart';
import 'package:alpaca/src/util/formatting.dart';

/// Contains all bars-related requests.
class Bars {
  /// Retrieves a list of bars for each requested symbol.
  /// It is guaranteed all bars are in ascending order by time.
  ///
  /// Required parameters:
  ///  timeframe: One of minute, 1Min, 5Min, 15Min, day or 1D. minute is an
  ///      alias of 1Min. Similarly, day is of 1D.
  ///  symbols: One or more (max 200) symbol names split by commas (",").
  ///
  /// Optional parameters:
  ///   limit: The maximum number of bars to be returned for each symbol.
  ///       It can be between 1 and 1000. Default is 100 if parameter is
  ///       unspecified or 0.
  ///   start: Filter bars equal to or after this time.
  ///       Cannot be used with after.
  ///   end: Filter bars equal to or after this time.
  ///       Cannot be used with until.
  ///   after: Filter bars equal to or after this time.
  ///       Cannot be used with start.
  ///   until: Filter bars equal to or after this time.
  ///       Cannot be used with end.
  static AlpacaDataRequest get(
    String timeframe,
    symbols, {
    int limit,
    DateTime start,
    DateTime end,
    DateTime after,
    DateTime until,
  }) {
    if (timeframe != 'minute' &&
        timeframe != '1Min' &&
        timeframe != '5Min' &&
        timeframe != '15Min' &&
        timeframe != '1D' &&
        timeframe != 'day') {
      throw ArgumentError('Invalid timeframe: $timeframe');
    }

    if (symbols == null || (symbols is! String && symbols is! List<String>)) {
      throw ArgumentError('symbols must be a String or List of Strings.');
    }

    if (symbols is List<String> && symbols.length > 200) {
      throw ArgumentError('max 200 symbols, ${symbols.length} provided');
    }

    final Map<String, String> params = {};
    params['symbols'] = symbols is List<String> ? symbols.join(',') : symbols;

    if (limit != null) {
      if (limit < 0 || limit > 1000) {
        throw ArgumentError('limit must be between 0 and 1000: $limit');
      } else {
        params['limit'] = '$limit';
      }
    }

    if (start != null && after != null) {
      throw ArgumentError('start and after cannot be used together.');
    }

    if (end != null && until != null) {
      throw ArgumentError('end and until cannot be used together.');
    }

    if (start != null) {
      params['start'] = toRfc3339String(start);
    }

    if (end != null) {
      params['end'] = toRfc3339String(end);
    }

    if (after != null) {
      params['after'] = toRfc3339String(after);
    }

    if (until != null) {
      params['until'] = toRfc3339String(until);
    }

    return AlpacaDataRequest('v1/bars/${timeframe}', params);
  }
}
