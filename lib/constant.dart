const kAnimationDuration = Duration(milliseconds: 100);
const defaultName = "Welcome";
const defaultJson = """
{
  "greeting": "Welcome to quicktype!",
  "instructions": [
    "Type or paste JSON here",
    "Or choose a sample above",
    "quicktype will generate code in your",
    "chosen language to parse the sample data"
  ]
}
""";
const defaultObject = """
class Welcome {
    String greeting;
    List<String> instructions;

    Welcome({
        required this.greeting,
        required this.instructions,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        greeting: json["greeting"],
        instructions: List<String>.from(json["instructions"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "greeting": greeting,
        "instructions": List<dynamic>.from(instructions.map((x) => x)),
    };
}
""";
const Set<String> dartKeywords = {
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'covariant',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'false',
  'final',
  'finally',
  'for',
  'Function',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'inferface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'null',
  'on',
  'operator',
  'part',
  'rethrow',
  'return',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'typedef',
  'var',
  'void',
  'while',
  'with',
  'yield',
};
final List<String> dartDataTypes = [
  'int',
  'double',
  'num',
  'bool',
  'String',
  'dynamic',
  // 'List',
  // 'Map',
  // 'Set',
  // 'Iterable',
  // 'Iterator',
  // 'Object',
  // 'void'
];

final String keywordsPattern = '\\b(${dartKeywords.join('|')})\\b';
final String dataTypesPattern = '\\b(${dartDataTypes.join('|')})\\b';
final String keywordRegexPattern = '($keywordsPattern|$dataTypesPattern)';
final RegExp keywordRegex = RegExp(keywordRegexPattern, caseSensitive: false);

final String quoteRegexPattern = r'''(["'])(?:(?=(\\?))\2.)*?\1''';
final RegExp quoteRegex = RegExp(quoteRegexPattern);

final String mapKeyPattern = r'''['\"]?(.*?)['\"]?\s*:\s*''';
final RegExp mapKeyRegex = RegExp(mapKeyPattern);
