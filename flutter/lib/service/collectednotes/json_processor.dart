
import 'dart:convert';

import 'package:sprintf/sprintf.dart';
import 'package:flutter_app/exceptions/unauthorized_exception.dart';
class JsonProcessor {

   static process(response, parser, object) {
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return parser(json.decode(response.body));
    } else if (response.statusCode ~/ 100 == 4) {
      throw UnauthorizedException('Wrong Credentials');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(sprintf('Failed to load %s', [object]));
    }

  }
}