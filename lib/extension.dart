import 'dart:convert';

import 'package:flutter/material.dart';

extension Sizes on num {
  Widget get x => SizedBox(width: toDouble());
  Widget get y => SizedBox(height: toDouble());
}

extension FullScreenSizes on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}

extension Formatter on String {
  String get formatToJson {
    final dynamic parsedJson = json.decode(this);
    final JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(parsedJson);
  }
}

extension Capitalizer on String {
  String get camelCase {
    List<String> words = split('_');
    String camelCase = words[0];

    for (int i = 1; i < words.length; i++) {
      String capitalizedWord =
          words[i][0].toUpperCase() + words[i].substring(1);
      camelCase += capitalizedWord;
    }

    return camelCase;
  }
}

extension Validator on String {
  bool get isJson {
    try {
      json.decode(this);
      return true;
    } catch (e) {
      return false;
    }
  }
}
