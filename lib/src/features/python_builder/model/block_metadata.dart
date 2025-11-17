enum BlockParameterRequirement {
  none,
  single,
  double,
}

class BlockMetadata {
  BlockMetadata._();

  static final RegExp digitPattern = RegExp(r'^\d+$');

  static const Set<String> twoParamLabels = {
    'AND',
    'OR',
    'IS',
    'IN',
    'IS NOT',
    'NOT IN',
    'AS',
    'FROM',
    'WITH',
    'EXCEPT',
    'CASE',
    'MATCH',
    'YIELD FROM',
    'order'
  };

  static const Set<String> labelOnlyLabels = {
    'TRUE',
    'FALSE',
    'NONE',
    'BREAK',
    'CONTINUE',
    'PASS',
    'RETURN',
    'RAISE',
    'ASSERT',
    'AWAIT',
  };

  static const Set<String> symbolLabels = {
    '+',
    '-',
    '*',
    '/',
    '//',
    '%',
    '**',
    '=',
    '==',
    '!=',
    '>',
    '<',
    '>=',
    '<=',
    '+=',
    '-=',
    '*=',
    '/=',
    '%=',
    '//=',
    '**=',
    '&',
    '|',
    '^',
    '~',
    '<<',
    '>>',
    ':=',
    '@',
    '=>',
    '=<',
    '=+',
  };

  static const List<String> operatorTokens = [
    '+',
    '-',
    '*',
    '/',
    '//',
    '%',
    '**',
    '=',
    '==',
    '!=',
    '>',
    '<',
    '>=',
    '<=',
    '+=',
    '-=',
    '*=',
    '/=',
    '%=',
    '//=',
    '**=',
    '&',
    '|',
    '^',
    '~',
    '<<',
    '>>',
    ':=',
    '@',
    '=>',
    '=<',
    '=+',
  ];

  static BlockParameterRequirement requirementFor(String token) {
    final String upper = token.toUpperCase();
    if (labelOnlyLabels.contains(upper)) return BlockParameterRequirement.none;
    if (symbolLabels.contains(token)) return BlockParameterRequirement.double;
    if (digitPattern.hasMatch(token)) return BlockParameterRequirement.none;
    if (twoParamLabels.contains(upper)) return BlockParameterRequirement.double;
    return BlockParameterRequirement.single;
  }
}

class ParameterizedBlockSerializer {
  ParameterizedBlockSerializer._();

  static const String prefix = 'param_block::';

  static String encode(String label, List<String> params) {
    final encodedLabel = Uri.encodeComponent(label);
    final encodedParams =
        params.map((value) => Uri.encodeComponent(value)).join('::');
    return '$prefix$encodedLabel::$encodedParams';
  }

  static ParameterizedBlockDescriptor? tryParse(String raw) {
    if (!raw.startsWith(prefix)) return null;
    final String payload = raw.substring(prefix.length);
    final List<String> parts = payload.split('::');
    if (parts.length < 2) return null;
    final String decodedLabel = Uri.decodeComponent(parts.first);
    final List<String> decodedParams =
        parts.skip(1).map(Uri.decodeComponent).toList();
    return ParameterizedBlockDescriptor(
      label: decodedLabel,
      parameters: decodedParams,
    );
  }
}

class ParameterizedBlockDescriptor {
  final String label;
  final List<String> parameters;

  const ParameterizedBlockDescriptor({
    required this.label,
    required this.parameters,
  });

  String? parameterAt(int index) =>
      index >= 0 && index < parameters.length ? parameters[index] : null;

  int get parameterCount => parameters.length;
}

class ParameterOptionSets {
  ParameterOptionSets._();

  static final List<String> singleParameterOptions = [
    'order',
    'orders',
    'total',
    ...List<String>.generate(10, (index) => '$index'),
  ];

  static final List<String> doubleParameterLeftOptions =
      singleParameterOptions;

  static final List<String> doubleParameterRightOptions = [
    ...List<String>.generate(10, (index) => '$index'),
    'order',
    'orders',
    'total',
  ];

  static String normalizeValue(String value) => value.toLowerCase();
}

