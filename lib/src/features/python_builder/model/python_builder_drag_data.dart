import 'package:d99_learn_data_enginnering/src/features/python_builder/model/python_canvas_token.dart';

class PythonBuilderDragData {
  const PythonBuilderDragData({
    required this.label,
    required this.kind,
    this.sourceRowIndex,
    this.sourceBlockIndex,
    this.literalType,
    this.wrappedToken,
    this.wrappedFunctionRowIndex,
    this.wrappedFunctionBlockIndex,
  });

  final String label;
  final PythonCanvasTokenKind kind;
  final int? sourceRowIndex;
  final int? sourceBlockIndex;
  final String? literalType;
  final PythonCanvasToken? wrappedToken;
  final int? wrappedFunctionRowIndex;
  final int? wrappedFunctionBlockIndex;

  PythonBuilderDragData copyWith({
    int? sourceRowIndex,
    int? sourceBlockIndex,
    String? literalType,
    PythonCanvasToken? wrappedToken,
    int? wrappedFunctionRowIndex,
    int? wrappedFunctionBlockIndex,
  }) {
    return PythonBuilderDragData(
      label: label,
      kind: kind,
      sourceRowIndex: sourceRowIndex ?? this.sourceRowIndex,
      sourceBlockIndex: sourceBlockIndex ?? this.sourceBlockIndex,
      literalType: literalType ?? this.literalType,
      wrappedToken: wrappedToken ?? this.wrappedToken,
      wrappedFunctionRowIndex:
          wrappedFunctionRowIndex ?? this.wrappedFunctionRowIndex,
      wrappedFunctionBlockIndex:
          wrappedFunctionBlockIndex ?? this.wrappedFunctionBlockIndex,
    );
  }
}

