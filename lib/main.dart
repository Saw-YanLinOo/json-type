import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:json_type/constant.dart';
import 'package:json_type/extension.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

enum Option {
  Dart,
  Kotlin,
  Swift,
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Json Type',
      debugShowCheckedModeBanner: false,
      scrollBehavior:
          kIsWeb ? const ScrollBehavior().copyWith(scrollbars: false) : null,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameEditingController = TextEditingController();
  late final RichTextController jsonEditingController;
  late final RichTextController objectEditingController;
  bool showHistory = false;
  bool showOption = false;
  int optionGroupValue = 0;
  Option selectOption = Option.Dart;

  Map<RegExp, TextStyle> objectPatternMap = {
    quoteRegex: TextStyle(color: Colors.blue.shade900),
    keywordRegex: TextStyle(color: Colors.red.shade900),
  };

  Map<RegExp, TextStyle> jsonPatternMap = {
    mapKeyRegex: TextStyle(color: Colors.blue.shade900),
  };

  @override
  void initState() {
    super.initState();
    _initializeDefaultJson();
  }

  void _initializeDefaultJson() {
    nameEditingController.text = defaultName;
    jsonEditingController = RichTextController(
      patternMatchMap: jsonPatternMap,
      onMatch: (List<String> match) {},
    );
    jsonEditingController.text = defaultJson;
    objectEditingController = RichTextController(
      patternMatchMap: objectPatternMap,
      onMatch: (List<String> match) {},
    );
    objectEditingController.text = defaultObject;
  }

  void stringToJson(String name, String text) {
    switch (selectOption) {
      case Option.Dart:
        {
          var result = _toDartConverter(name, text);
          objectEditingController.text = result;
          setState(() {});
          break;
        }
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Json Type",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showOption = !showOption;
              setState(() {});
            },
            child: ActionItemView(
              icon: showOption
                  ? FontAwesomeIcons.solidEye
                  : FontAwesomeIcons.solidEyeSlash,
              title: "options",
            ),
          ),
          8.x,
          ActionItemView(
            icon: FontAwesomeIcons.solidHeart,
            title: "Make with Flutter",
            iconColor: Colors.red,
          ),
          12.x,
        ],
      ),
      body: Row(
        children: [
          HistoryView(
            showHistory: showHistory,
            onTap: () {
              showHistory = !showHistory;
              setState(() {});
            },
          ),
          Container(
            width: context.width * 0.3,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showHistory = !showHistory;
                        setState(() {});
                      },
                      child: Visibility(
                        visible: !showHistory,
                        child: Icon(Icons.navigate_next),
                      ),
                    ),
                    4.x,
                    Text(
                      "Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                4.y,
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          onChanged: (value) {
                            var json = jsonEditingController.text;
                            if (json.isJson) {
                              closeToast();
                              stringToJson(value, json);
                            } else {
                              showToast(
                                  "Unknown character , invalid json format.");
                            }
                          },
                          controller: nameEditingController,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            filled: true,
                            // fillColor: Colors.grey,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.only(left: 4),
                          ),
                        ),
                      ),
                    ),
                    4.x,
                    GestureDetector(
                      onTap: () {
                        // var json = jsonEditingController.text;
                        // if (json.isJson) {
                        //   jsonEditingController.text = json.formatToJson;
                        //   setState(() {});
                        // } else {
                        //   showToast("Unknown character , invalid json format.");
                        // }
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 247, 245, 245),
                          // color: Color.fromARGB(255, 246, 243, 243),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Center(
                            child: Text(
                              "SAVE",
                              style: TextStyle(
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                12.y,
                // fillColor: Theme.of(context).inputDecorationTheme.fillColor,

                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      var json = jsonEditingController.text;
                      if (json.isJson) {
                        closeToast();
                        stringToJson(nameEditingController.text, value);
                      } else {
                        showToast("Unknown character , invalid json format.");
                      }
                    },
                    controller: jsonEditingController,
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      filled: true,
                      //fillColor: Colors.grey,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: EdgeInsets.only(top: 4),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: TextField(
                    controller: objectEditingController,
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    style: TextStyle(letterSpacing: 1.2),
                    decoration: InputDecoration(
                      filled: true,
                      // fillColor: Colors.grey,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 20,
                  child: Visibility(
                    visible: showOption,
                    child: Card(
                      elevation: 10,
                      child: Container(
                        width: 250,
                        height: 400,
                        child: Column(
                          children: [
                            Expanded(
                              child: ExpansionTile(
                                title: Text("Language"),
                                initiallyExpanded: true,
                                children: [
                                  ...Option.values.map((item) {
                                    return RadioListTile(
                                      onChanged: (value) {
                                        optionGroupValue = 0;
                                        // selectOption = item;
                                        setState(() {});
                                      },
                                      value: item.index,
                                      groupValue: optionGroupValue,
                                      title: Text(item.name),
                                    );
                                  })
                                ],
                              ),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () async {
                                  await FlutterClipboard.copy(
                                      objectEditingController.text);
                                  showToast("Copy ${selectOption.name} Code!");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  width: 200,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "Copy Code",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            12.y,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HistoryView extends StatefulWidget {
  const HistoryView({
    super.key,
    required this.showHistory,
    required this.onTap,
  });

  final bool showHistory;
  final Function onTap;

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  bool expandedHistory = true;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.showHistory,
      child: SizedBox(
        width: context.width * 0.15,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      widget.onTap();
                    },
                    child: Icon(Icons.navigate_before),
                  ),
                  4.x,
                  Text("History"),
                ],
              ),
            ),
            Text("no history"),
          ],
        ),
      ),
    );
  }
}

class ActionItemView extends StatelessWidget {
  const ActionItemView({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
  });

  final String title;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 16,
        ),
        6.x,
        Text(title),
      ],
    );
  }
}

// Generator

String _toDartConverter(String variableName, String variableValue) {
  final jsonMap = json.decode(variableValue) as Map<String, dynamic>;

  final buffer = StringBuffer()..writeln();
  final generatedClasses = <String>{};

  _generateClass(buffer, variableName, jsonMap, generatedClasses);
  return buffer.toString();
}

void _generateClass(
  StringBuffer buffer,
  String className,
  Map<String, dynamic> jsonMap,
  Set<String> generatedClasses,
) {
  if (generatedClasses.contains(className)) return;

  generatedClasses.add(className);

  buffer.writeln('class $className {');

  jsonMap.forEach((key, dynamic value) {
    final type = _getType(value, key);
    buffer.writeln('    final $type? ${key.camelCase};');
  });

  // Unnamed constructor
  buffer
    ..writeln()
    ..writeln('    $className({')
    ..writeAll(
        jsonMap.entries.map((e) => '        this.${e.key.camelCase}, '), "\n")
    ..writeln()
    ..writeln('    });')

    // fromJson factory method
    ..writeln()
    ..writeln(
        '    factory $className.fromJson(Map<String, dynamic> json) =>  $className(')
    ..writeAll(jsonMap.entries.map((e) {
      final type = _getType(e.value, e.key);
      if (type.startsWith('List<')) {
        return "        ${e.key.camelCase}: (json['${e.key}'] as List<dynamic>?)?.map((e) => ${type.substring(5, type.length - 1)}.fromJson(e as Map<String, dynamic>)).toList(),";
      } else if (e.value is Map) {
        return "        ${e.key.camelCase}: json['${e.key}'] !=null ? ${_getType(e.value, e.key)}.fromJson(json['${e.key}'] as Map<String, dynamic>) : null,";
      } else {
        return "        ${e.key.camelCase}: json['${e.key}'] != null ? json['${e.key}'] as ${_getType(e.value, e.key)}? : null,";
      }
    }), "\n")
    ..writeln()
    ..writeln('    );')

    // toJson method
    ..writeln()
    ..writeln('    Map<String, dynamic> toJson() => {')
    ..writeAll(jsonMap.entries.map((e) {
      final type = _getType(e.value, e.key);
      if (type.startsWith('List<')) {
        return "        '${e.key.camelCase}': ${e.key}?.map((e) => e.toJson()).toList(),";
      } else if (e.value is Map) {
        return "        '${e.key.camelCase}': ${e.key}?.toJson(),";
      } else {
        return "        '${e.key.camelCase}': ${e.key},";
      }
    }), "\n")
    ..writeln()
    ..writeln('    };')
    ..writeln('}');

  jsonMap.forEach((key, dynamic value) {
    if (value is Map<String, dynamic>) {
      _generateClass(buffer, _getType(value, key), value, generatedClasses);
    } else if (value is List) {
      if (value.isNotEmpty && value.first is Map) {
        _generateClass(
          buffer,
          _getType(value.first, key),
          value.first as Map<String, dynamic>,
          generatedClasses,
        );
      }
      for (final element in value) {
        if (element is Map<String, dynamic>) {
          _generateClass(
            buffer,
            _getType(element, key),
            element,
            generatedClasses,
          );
        }
      }
    }
  });
}

String _getType(dynamic value, String key) {
  if (value is int) {
    return 'int';
  } else if (value is double) {
    return 'double';
  } else if (value is String) {
    return 'String';
  } else if (value is bool) {
    return 'bool';
  } else if (value is List) {
    if (value.isEmpty) {
      return 'List<dynamic>';
    } else {
      return 'List<${_getType(value.first, key)}>';
    }
  } else if (value is Map) {
    return _capitalize(key);
  } else {
    return 'dynamic';
  }
}

String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

void closeToast() {
  Fluttertoast.cancel();
}

void showToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM_LEFT,
    webPosition: "left",
    timeInSecForIosWeb: 3,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
    webShowClose: true,
  );
}
