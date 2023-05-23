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
