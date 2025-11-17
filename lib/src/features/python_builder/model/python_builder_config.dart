import 'dart:async';

import 'package:d99_learn_data_enginnering/src/features/python_builder/model/python_canvas_token.dart';

/// Represents the available tab types in the Python builder toolbar.
enum PythonToolbarTabKind {
  math,
  logic,
  operators,
  data,
  strings,
  functions,
  itertools,
  errors,
  variables,
}

/// Configuration for a toolbar tab, allowing custom labels and filtered items.
class PythonToolbarTabConfig {
  const PythonToolbarTabConfig({
    required this.kind,
    this.label,
    this.allowedItems,
  });

  final PythonToolbarTabKind kind;
  final String? label;
  final List<String>? allowedItems;
}

typedef PythonResultValidator = FutureOr<bool> Function(
  String output,
  Map<String, dynamic>? inputs,
);

/// Configuration describing the active Python challenge.
class PythonChallengeConfig {
  const PythonChallengeConfig({
    required this.prompt,
    this.expectedOutput,
    this.fallbackExpectedOutput,
    this.customValidator,
    this.mockInputs = const <String, dynamic>{},
  });

  final String prompt;
  final String? expectedOutput;
  final String? fallbackExpectedOutput;
  final PythonResultValidator? customValidator;
  final Map<String, dynamic> mockInputs;
}

/// Configuration for the Python builder toolbar.
class PythonToolbarConfig {
  const PythonToolbarConfig({this.tabs});

  final List<PythonToolbarTabConfig>? tabs;
}

/// Centralized defaults for the Python builder experience.
class PythonBuilderDefaults {
  static const Map<String, dynamic> defaultMockInputs =
      <String, dynamic>{};

  static const List<PythonToolbarTabConfig> toolbarTabs =
      <PythonToolbarTabConfig>[
    PythonToolbarTabConfig(kind: PythonToolbarTabKind.math),
    PythonToolbarTabConfig(kind: PythonToolbarTabKind.logic),
    PythonToolbarTabConfig(kind: PythonToolbarTabKind.operators),
    PythonToolbarTabConfig(kind: PythonToolbarTabKind.data),
    PythonToolbarTabConfig(kind: PythonToolbarTabKind.strings),
    PythonToolbarTabConfig(kind: PythonToolbarTabKind.functions),
    PythonToolbarTabConfig(kind: PythonToolbarTabKind.itertools),
    PythonToolbarTabConfig(kind: PythonToolbarTabKind.errors),
    PythonToolbarTabConfig(kind: PythonToolbarTabKind.variables),
  ];

  static const Map<PythonToolbarTabKind, String> tabLabels =
      <PythonToolbarTabKind, String>{
    PythonToolbarTabKind.math: 'Math',
    PythonToolbarTabKind.logic: 'Logic',
    PythonToolbarTabKind.operators: 'Operators',
    PythonToolbarTabKind.data: 'Data',
    PythonToolbarTabKind.strings: 'Strings',
    PythonToolbarTabKind.functions: 'Functions',
    PythonToolbarTabKind.itertools: 'Itertools',
    PythonToolbarTabKind.errors: 'Errors',
    PythonToolbarTabKind.variables: 'Variables',
  };

  static const List<String> mathItems = <String>[
    'SUM',
    'MIN',
    'MAX',
    'ABS',
    'ROUND',
    'FLOOR',
    'CEIL',
    'POW',
    'DIVMOD',
    'SQRT',
    'LOG',
    'EXP',
    'FACTORIAL',
    'CLAMP',
    'RANGE',
    'HYPOT',
    'COMPLEX',
    'FRACTION',
    'DECIMAL',
  ];

  static const List<String> logicItems = <String>[
    'IF',
    'ELIF',
    'ELSE',
    'MATCH',
    'CASE',
    'FOR',
    'WHILE',
    'BREAK',
    'CONTINUE',
    'PASS',
    'AND',
    'OR',
    'NOT',
    'IN',
    'NOT IN',
    'IS',
    'IS NOT',
    'TRUE',
    'FALSE',
    'NONE',
    'ALL',
    'ANY',
    'BOOL',
  ];

  static const List<String> operatorItems = <String>[
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
  ];

  static const List<String> dataItems = <String>[
    'LIST',
    'TUPLE',
    'DICT',
    'SET',
    'FROZENSET',
    'RANGE',
    'ENUMERATE',
    'ZIP',
    'MAP',
    'FILTER',
    'SORTED',
    'REVERSED',
    'SLICE',
    'APPEND',
    'EXTEND',
    'INSERT',
    'POP',
    'REMOVE',
    'CLEAR',
    'COPY',
    'UPDATE',
    'ITEMS',
    'VALUES',
    'KEYS',
    'DEFAULTDICT',
    'COUNTER',
    'GROUPBY',
    // SQL keywords (used in Python string queries)
    'SELECT',
    'FROM',
    'WHERE',
    'GROUP BY',
    'ORDER BY',
    'orders',
    'LIMIT',
    'JOIN',
    'INNER JOIN',
    'LEFT JOIN',
    'RIGHT JOIN',
  ];

  static const List<String> stringItems = <String>[
    'STR',
    'LEN',
    'SPLIT',
    'JOIN',
    'FORMAT',
    'FSTRING',
    'LOWER',
    'UPPER',
    'TITLE',
    'STRIP',
    'REPLACE',
    'STARTSWITH',
    'ENDSWITH',
    'FIND',
    'COUNT',
    'SLICE',
    'ENCODE',
    'DECODE',
    'REGEX',
    'SUB',
  ];

  static const List<String> functionItems = <String>[
    'DEF',
    'RETURN',
    'LAMBDA',
    'YIELD',
    'YIELD FROM',
    'ASYNC',
    'AWAIT',
    'GLOBAL',
    'NONLOCAL',
    'DECORATOR',
    'CALLABLE',
    'ARGS',
    'KWARGS',
    'IMPORT',
    'FROM',
    'AS',
    'WITH',
    'PASS',
    'ASSERT',
    'RAISE',
    'DOCSTRING',
    // SQL execution functions (Python style)
    'EXECUTE_SQL',
    'QUERY',
  ];

  static const List<String> itertoolsItems = <String>[
    'ITER',
    'NEXT',
    'RANGE',
    'ZIP',
    'MAP',
    'FILTER',
    'CHAIN',
    'CYCLE',
    'PRODUCT',
    'PERMUTATIONS',
    'COMBINATIONS',
    'ACCUMULATE',
    'GROUPBY',
    'COUNT',
    'ISLICE',
    'TAKEWHILE',
    'DROPWHILE',
    'ENUMERATE',
    'LISTCOMPREHENSION',
    'GENEXPR',
  ];

  static const List<String> errorItems = <String>[
    'TRY',
    'EXCEPT',
    'FINALLY',
    'ELSE',
    'RAISE',
    'ASSERT',
    'ERROR',
    'WARNING',
    'VALUEERROR',
    'TYPEERROR',
    'KEYERROR',
    'INDEXERROR',
    'IOERROR',
    'IMPORTERROR',
    'ATTRIBUTEERROR',
    'RUNTIMEERROR',
    'TRACEBACK',
    'LOG',
  ];

  static const List<String> variableItems = <String>[
    'VAR',
    'INT',
    'FLOAT',
    'BOOL',
    'STR',
    'LIST',
    'DICT',
    'SET',
    'TUPLE',
    'CONST',
    'CLASS',
    'SELF',
    'INIT',
    'ATTRIBUTE',
    'PROPERTY',
    'STATIC',
    'CLASSMETHOD',
    'DATACLASS',
    'TYPEHINT',
    'OPTIONAL',
    'UNION',
    'TYPEVAR',
    // Database table names
    'orders',
    'customers',
  ];

  static const Map<String, PythonCanvasTokenKind> itemKindMap =
      <String, PythonCanvasTokenKind>{
    // Keywords
    'IF': PythonCanvasTokenKind.controlFlow,
    'ELIF': PythonCanvasTokenKind.controlFlow,
    'ELSE': PythonCanvasTokenKind.controlFlow,
    'FOR': PythonCanvasTokenKind.controlFlow,
    'WHILE': PythonCanvasTokenKind.controlFlow,
    'BREAK': PythonCanvasTokenKind.controlFlow,
    'CONTINUE': PythonCanvasTokenKind.controlFlow,
    'PASS': PythonCanvasTokenKind.keyword,
    'RETURN': PythonCanvasTokenKind.keyword,
    'DEF': PythonCanvasTokenKind.keyword,
    'CLASS': PythonCanvasTokenKind.keyword,
    'IMPORT': PythonCanvasTokenKind.keyword,
    'FROM': PythonCanvasTokenKind.keyword, // Python FROM (also used in SQL)
    'AS': PythonCanvasTokenKind.keyword,
    'WITH': PythonCanvasTokenKind.keyword,
    'TRY': PythonCanvasTokenKind.controlFlow,
    'EXCEPT': PythonCanvasTokenKind.controlFlow,
    'FINALLY': PythonCanvasTokenKind.controlFlow,
    'RAISE': PythonCanvasTokenKind.keyword,
    'ASSERT': PythonCanvasTokenKind.keyword,
    'AND': PythonCanvasTokenKind.keyword,
    'OR': PythonCanvasTokenKind.keyword,
    'NOT': PythonCanvasTokenKind.keyword,
    'IN': PythonCanvasTokenKind.keyword,
    'IS': PythonCanvasTokenKind.keyword,
    // SQL keywords (for Python string queries)
    'SELECT': PythonCanvasTokenKind.keyword,
    'WHERE': PythonCanvasTokenKind.keyword,
    'GROUP BY': PythonCanvasTokenKind.keyword,
    'ORDER BY': PythonCanvasTokenKind.keyword,
    'LIMIT': PythonCanvasTokenKind.keyword,
    'JOIN': PythonCanvasTokenKind.keyword,
    'INNER JOIN': PythonCanvasTokenKind.keyword,
    'LEFT JOIN': PythonCanvasTokenKind.keyword,
    'RIGHT JOIN': PythonCanvasTokenKind.keyword,
    // SQL execution functions
    'EXECUTE_SQL': PythonCanvasTokenKind.function,
    'QUERY': PythonCanvasTokenKind.function,
    // Database tables
    'orders': PythonCanvasTokenKind.variable,
    'customers': PythonCanvasTokenKind.variable,
    // Literals
    'TRUE': PythonCanvasTokenKind.literal,
    'FALSE': PythonCanvasTokenKind.literal,
    'NONE': PythonCanvasTokenKind.literal,
    // Data types
    'INT': PythonCanvasTokenKind.dataType,
    'FLOAT': PythonCanvasTokenKind.dataType,
    'BOOL': PythonCanvasTokenKind.dataType,
    'STR': PythonCanvasTokenKind.dataType,
    'LIST': PythonCanvasTokenKind.dataType,
    'DICT': PythonCanvasTokenKind.dataType,
    'SET': PythonCanvasTokenKind.dataType,
    'TUPLE': PythonCanvasTokenKind.dataType,
  };

  static List<String> itemsFor(PythonToolbarTabKind kind) {
    switch (kind) {
      case PythonToolbarTabKind.math:
        return mathItems;
      case PythonToolbarTabKind.logic:
        return logicItems;
      case PythonToolbarTabKind.operators:
        return operatorItems;
      case PythonToolbarTabKind.data:
        return dataItems;
      case PythonToolbarTabKind.strings:
        return stringItems;
      case PythonToolbarTabKind.functions:
        return functionItems;
      case PythonToolbarTabKind.itertools:
        return itertoolsItems;
      case PythonToolbarTabKind.errors:
        return errorItems;
      case PythonToolbarTabKind.variables:
        return variableItems;
    }
  }

  static PythonCanvasTokenKind kindFor(String item) {
    return itemKindMap[item.toUpperCase()] ?? PythonCanvasTokenKind.unknown;
  }

  static String labelFor(PythonToolbarTabKind kind) =>
      tabLabels[kind] ?? kind.name;
}

