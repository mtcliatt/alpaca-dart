import 'package:alpaca_dart/src/alpaca_api.dart';

/// Contains all position-related requests.
class Position {
  static AlpacaRequest getOne({String positionIdentifier})
      => AlpacaRequest.get('/v1/positions/$positionIdentifier');

  static AlpacaRequest get() => AlpacaRequest.get('/v1/positions');
}
