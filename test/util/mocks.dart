import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';

import 'dart:async';

class _AlpacaMockClient extends MockClient {
  _AlpacaMockClient(MockClientHandler fn)
      : super((request) => Future.value(null));
}

class AlpacaMockitoClient extends Mock implements _AlpacaMockClient {}
