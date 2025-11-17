/// Distinguishes the semantic role of a Python canvas tile.
enum PythonCanvasTokenKind {
  keyword,
  operator,
  literal,
  function,
  variable,
  dataType,
  controlFlow,
  unknown,
}

class PythonCanvasToken {
  const PythonCanvasToken({
    required this.label,
    required this.kind,
    this.wrappedToken,
    this.literalType,
    this.indentation,
  });

  final String label;
  final PythonCanvasTokenKind kind;
  final PythonCanvasToken? wrappedToken; // For function tiles that wrap another token
  final String? literalType; // For literal tiles: STR, INT, FLOAT, BOOL, etc.
  final int? indentation; // Python indentation level (0-based)

  factory PythonCanvasToken.fromJson(Map<String, Object?> json) {
    final String? kindValue = json['kind'] as String?;
    final PythonCanvasTokenKind resolvedKind =
        PythonCanvasTokenKind.values.firstWhere(
      (value) => value.name == kindValue,
      orElse: () => PythonCanvasTokenKind.unknown,
    );
    final Map<String, Object?>? wrapped =
        json['wrappedToken'] as Map<String, Object?>?;
    return PythonCanvasToken(
      label: json['label'] as String? ?? '',
      kind: resolvedKind,
      wrappedToken: wrapped == null ? null : PythonCanvasToken.fromJson(wrapped),
      literalType: json['literalType'] as String?,
      indentation: json['indentation'] as int?,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'label': label,
      'kind': kind.name,
      if (wrappedToken != null) 'wrappedToken': wrappedToken!.toJson(),
      if (literalType != null) 'literalType': literalType,
      if (indentation != null) 'indentation': indentation,
    };
  }

  PythonCanvasToken copyWith({
    String? label,
    PythonCanvasTokenKind? kind,
    PythonCanvasToken? wrappedToken,
    String? literalType,
    int? indentation,
  }) {
    return PythonCanvasToken(
      label: label ?? this.label,
      kind: kind ?? this.kind,
      wrappedToken: wrappedToken ?? this.wrappedToken,
      literalType: literalType ?? this.literalType,
      indentation: indentation ?? this.indentation,
    );
  }

  @override
  int get hashCode =>
      Object.hash(label, kind, wrappedToken, literalType, indentation);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PythonCanvasToken &&
        other.label == label &&
        other.kind == kind &&
        other.wrappedToken == wrappedToken &&
        other.literalType == literalType &&
        other.indentation == indentation;
  }
}

