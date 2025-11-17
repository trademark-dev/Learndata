import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/services/status_bar_service.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/back_top_bar.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/widget/python_builder_toolbar.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/widget/python_builder_canvas.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/widget/python_popup.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/widget/hint_popup.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/widget/run_result_popup.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/widget/compiled_failed_popup.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/widget/information_popup.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/model/python_canvas_token.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/model/python_builder_drag_data.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/services/python_canvas_service.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/services/python_row_repositioner.dart';
import 'package:d99_learn_data_enginnering/src/services/local_python_executor.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/visualization/static_table.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/visualization/table_style_presets.dart';

// Debug logging feature flag
const bool _kEnableCanvasDebugLogging = true;

class PythonBuilderPage extends StatefulWidget {
  const PythonBuilderPage({super.key});

  @override
  State<PythonBuilderPage> createState() => _PythonBuilderPageState();
}

class _PythonBuilderPageState extends State<PythonBuilderPage>
    with TickerProviderStateMixin {
  bool _showPopup = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  bool _showHintPopup = false;
  late AnimationController _hintSlideController;
  late Animation<Offset> _hintSlideAnimation;

  bool _showRunResultPopup = false;
  late AnimationController _runResultSlideController;
  late Animation<Offset> _runResultSlideAnimation;

  bool _showCompiledFailedPopup = false;
  late AnimationController _compiledFailedSlideController;
  late Animation<Offset> _compiledFailedSlideAnimation;

  bool _showInformationPopup = false;
  late AnimationController _informationSlideController;
  late Animation<Offset> _informationSlideAnimation;

  final List<List<PythonCanvasToken>> _canvasRows = [];
  final List<List<List<PythonCanvasToken>>> _undoStack = [];
  final List<List<List<PythonCanvasToken>>> _redoStack = [];
  final PythonRowRepositioner _rowRepositioner = const PythonRowRepositioner();
  String _rawPython = ''; // Raw Python from canvas (no processing)
  PythonFormattingResult? _lastProcessingResult; // Result from PythonProcessor (only when RUN pressed)
  List<double> _rowIndents = []; // Computed indentation levels (calculated after RUN)
  
  // Execution state (similar to SQL builder)
  PythonExecutionResult? _executionResult;
  bool _isExecuting = false;
  bool _hasExecutedCode = false;
  String _executionStatus = 'COMPILATION SUCCESSFUL'; // 'COMPILATION SUCCESSFUL', 'RUNNING', 'COMPILATION FAILED'

  @override
  void initState() {
    super.initState();
    StatusBarService.setTransparentStatusBar();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    _hintSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _hintSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from bottom
      end: Offset.zero, // End at current position
    ).animate(CurvedAnimation(
      parent: _hintSlideController,
      curve: Curves.easeOut,
    ));

    _runResultSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _runResultSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from bottom
      end: Offset.zero, // End at current position
    ).animate(CurvedAnimation(
      parent: _runResultSlideController,
      curve: Curves.easeOut,
    ));

    _compiledFailedSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _compiledFailedSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from bottom
      end: Offset.zero, // End at current position
    ).animate(CurvedAnimation(
      parent: _compiledFailedSlideController,
      curve: Curves.easeOut,
    ));

    _informationSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _informationSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from bottom
      end: Offset.zero, // End at current position
    ).animate(CurvedAnimation(
      parent: _informationSlideController,
      curve: Curves.easeOut,
    ));
    
    // Canvas remains empty by default - user will drag tiles from toolbar
    // SQL tiles (SELECT, FROM, orders, customers) are available in toolbar tabs
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _hintSlideController.dispose();
    _runResultSlideController.dispose();
    _compiledFailedSlideController.dispose();
    _informationSlideController.dispose();
    super.dispose();
  }

  List<List<PythonCanvasToken>> _cloneCanvasRows() {
    return _canvasRows
        .map((row) => row.map((token) => token.copyWith()).toList(growable: true))
        .toList(growable: true);
  }

  void _recordForUndo() {
    _undoStack.add(_cloneCanvasRows());
    if (_undoStack.length > 50) {
      _undoStack.removeAt(0);
    }
  }

  void _updatePythonArtifactsLocked() {
    // Simplified: just serialize to raw Python, no formatting/validation
    // Processing only happens when RUN button is pressed
    final PythonCanvasSerializationResult serialization =
        PythonCanvasSerializer.serialize(_canvasRows);
    _rawPython = serialization.python;
  }

  void _ensureRowExists(int rowIndex) {
    if (rowIndex < 0) return;
    while (_canvasRows.length <= rowIndex) {
      _canvasRows.add(<PythonCanvasToken>[]);
    }
  }

  void _ensureInsertIndex(int rowIndex) {
    if (rowIndex < 0) return;
    while (_canvasRows.length < rowIndex) {
      _canvasRows.add(<PythonCanvasToken>[]);
    }
  }

  void _handleBlockDropped(PythonBuilderDragData data, CanvasDropDetails details) {
    if (_kEnableCanvasDebugLogging) {
      print('🔵 _handleBlockDropped:');
      print('   data.label=${data.label}');
      print('   details.rowIndex=${details.rowIndex}');
      print('   details.insertAsNewRow=${details.insertAsNewRow}');
      print('   details.forceAppendToBottom=${details.forceAppendToBottom}');
      print('   details.blockIndex=${details.blockIndex}');
      print('   _canvasRows.length=${_canvasRows.length}');
      print('   data.sourceRowIndex=${data.sourceRowIndex}');
      print('   data.sourceBlockIndex=${data.sourceBlockIndex}');
    }
    setState(() {
      _recordForUndo();
      // When forceAppendToBottom is true, insert after the current row (rowIndex + 1)
      // Otherwise, insert at the current rowIndex
      int targetRowIndex = details.forceAppendToBottom 
          ? details.rowIndex + 1  // Insert after current row
          : details.rowIndex;      // Insert at current row
      
      // Clamp targetRowIndex to valid range to prevent gaps
      // If dropping at an index beyond existing rows, create rows up to that index
      final bool targetRowExists = targetRowIndex >= 0 && targetRowIndex < _canvasRows.length;
      final bool isTargetRowEmpty = targetRowExists && _canvasRows[targetRowIndex].isEmpty;
      
      // Determine if we should insert as new row:
      // 1. If forceAppendToBottom is true (cursor below row), insert as new row
      // 2. If explicitly requested via insertAsNewRow, insert as new row  
      // 3. If target row doesn't exist (targetRowIndex >= _canvasRows.length), insert as new row
      // 4. If target row is empty, insert as new row (replace empty row)
      // 5. Otherwise, insert in existing non-empty row
      bool insertAsNewRow = details.forceAppendToBottom 
          ? true  // Cursor below row - create new row
          : (details.insertAsNewRow || !targetRowExists || isTargetRowEmpty); // New row if requested, row doesn't exist, or row is empty
      
      // If inserting at an index beyond existing rows, ensure we create rows sequentially
      // This prevents gaps when transitioning from hidden rows to actual rows
      // IMPORTANT: Fill gaps BEFORE checking insertAsNewRow to maintain row structure
      // Use >= instead of > to handle case when targetRowIndex equals _canvasRows.length
      if (targetRowIndex >= _canvasRows.length && insertAsNewRow) {
        // Fill gaps by creating empty rows up to targetRowIndex - 1
        // Then we'll insert at targetRowIndex as new row
        while (_canvasRows.length < targetRowIndex) {
          _canvasRows.add(<PythonCanvasToken>[]);
          if (_kEnableCanvasDebugLogging) {
            print('   📍 Filling gap: creating empty row at index ${_canvasRows.length - 1}');
          }
        }
        // After filling gaps, targetRowIndex should equal _canvasRows.length
        // So we should insert as new row
        insertAsNewRow = true;
        if (_kEnableCanvasDebugLogging) {
          print('   📍 After gap fill: targetRowIndex=$targetRowIndex, _canvasRows.length=${_canvasRows.length}, insertAsNewRow=$insertAsNewRow');
        }
      } else if (targetRowIndex > _canvasRows.length && !insertAsNewRow) {
        // If not inserting as new row but targetRowIndex is beyond, still fill gaps
        // This handles cases where dropping on non-empty row but structure needs fixing
        while (_canvasRows.length < targetRowIndex) {
          _canvasRows.add(<PythonCanvasToken>[]);
          if (_kEnableCanvasDebugLogging) {
            print('   📍 Filling gap (non-new-row): creating empty row at index ${_canvasRows.length - 1}');
          }
        }
      }
      
      if (_kEnableCanvasDebugLogging) {
        print('   After initial calc: targetRowIndex=$targetRowIndex, insertAsNewRow=$insertAsNewRow, _canvasRows.length=${_canvasRows.length}');
      }
      if (insertAsNewRow) {
        _ensureInsertIndex(targetRowIndex);
      } else {
        _ensureRowExists(targetRowIndex);
      }
      
      PythonCanvasToken tokenToInsert = PythonCanvasToken(
        label: data.label,
        kind: data.kind,
        literalType: data.literalType,
      );

      final int? sourceRowIndex = data.sourceRowIndex;
      final int? sourceBlockIndex = data.sourceBlockIndex;
      final bool isSameRowRearrange =
          sourceRowIndex != null &&
          sourceRowIndex == targetRowIndex &&
          !insertAsNewRow;

      // Extract the token from source if it exists
      if (sourceRowIndex != null && sourceBlockIndex != null) {
        if (sourceRowIndex >= 0 && sourceRowIndex < _canvasRows.length) {
          final List<PythonCanvasToken> sourceRow = _canvasRows[sourceRowIndex];
          if (sourceBlockIndex >= 0 && sourceBlockIndex < sourceRow.length) {
            tokenToInsert = sourceRow[sourceBlockIndex];

            // For same-row rearrangement, we handle differently
            if (!isSameRowRearrange) {
              sourceRow.removeAt(sourceBlockIndex);
            }
          }
        }
      }

      if (_canvasRows.isEmpty) {
        targetRowIndex = 0;
        insertAsNewRow = true;
        _ensureInsertIndex(targetRowIndex);
      }

      if (_kEnableCanvasDebugLogging) {
        print('   Final: targetRowIndex=$targetRowIndex, insertAsNewRow=$insertAsNewRow, _canvasRows.length=${_canvasRows.length}');
      }

      if (insertAsNewRow) {
        final int boundedIndex =
            targetRowIndex.clamp(0, _canvasRows.length).toInt();
        
        // If target row exists and is empty, replace it instead of inserting before it
        // This prevents gaps when dropping on empty rows
        if (targetRowExists && isTargetRowEmpty) {
          if (_kEnableCanvasDebugLogging) {
            print('   Replacing empty row at index $boundedIndex');
          }
          _canvasRows[boundedIndex] = <PythonCanvasToken>[tokenToInsert];
        } else {
          if (_kEnableCanvasDebugLogging) {
            print('   Inserting new row at index $boundedIndex');
          }
          _canvasRows.insert(boundedIndex, <PythonCanvasToken>[tokenToInsert]);
        }
      } else {
        _ensureRowExists(targetRowIndex);
        final int maxIndex = _canvasRows.isEmpty ? 0 : _canvasRows.length - 1;
        final int boundedIndex = targetRowIndex.clamp(0, maxIndex).toInt();

        if (isSameRowRearrange && sourceBlockIndex != null) {
          // Same-row rearrangement: remove from old position, insert at new
          final row = _canvasRows[boundedIndex];
          row.removeAt(sourceBlockIndex);

          // Adjust insert index if dropping after the removed item
          int insertIndex = details.blockIndex ?? row.length;
          if (insertIndex > sourceBlockIndex) {
            insertIndex--;
          }
          insertIndex = insertIndex.clamp(0, row.length);
          row.insert(insertIndex, tokenToInsert);
        } else if (details.blockIndex != null) {
          // Different row: insert at specific position
          final int insertIndex = details.blockIndex!.clamp(
            0,
            _canvasRows[boundedIndex].length,
          );
          _canvasRows[boundedIndex].insert(insertIndex, tokenToInsert);
        } else {
          // Append to end
          _canvasRows[boundedIndex].add(tokenToInsert);
        }
      }
      _redoStack.clear();
      _updatePythonArtifactsLocked();
    });
  }

  void _removeCanvasBlock(int rowIndex, int blockIndex) {
    if (rowIndex < 0 || rowIndex >= _canvasRows.length) return;
    final row = _canvasRows[rowIndex];
    if (blockIndex < 0 || blockIndex >= row.length) return;
    setState(() {
      _recordForUndo();
      row.removeAt(blockIndex);
      _redoStack.clear();
      _updatePythonArtifactsLocked();
    });
  }

  void _clearCanvas() {
    if (_canvasRows.isEmpty) return;
    setState(() {
      _recordForUndo();
      _canvasRows.clear();
      _redoStack.clear();
      _rowIndents = [];
      _updatePythonArtifactsLocked();
    });
  }

  void _undo() {
    if (_undoStack.isEmpty) return;
    setState(() {
      _redoStack.add(_cloneCanvasRows());
      final previous = _undoStack.removeLast();
      _canvasRows
        ..clear()
        ..addAll(
          previous.map(
            (row) => row.map((token) => token.copyWith()).toList(growable: true),
          ),
        );
      _updatePythonArtifactsLocked();
    });
  }

  void _redo() {
    if (_redoStack.isEmpty) return;
    setState(() {
      _undoStack.add(_cloneCanvasRows());
      final next = _redoStack.removeLast();
      _canvasRows
        ..clear()
        ..addAll(
          next.map(
            (row) => row.map((token) => token.copyWith()).toList(growable: true),
          ),
        );
      _updatePythonArtifactsLocked();
    });
  }

  bool get _canUndo => _undoStack.isNotEmpty;
  bool get _canRedo => _redoStack.isNotEmpty;

  void _onInfoThreeDotsTap() {
    setState(() {
      _showPopup = true;
    });
    _fadeController.forward();
  }

  void _onSkip() {
    _fadeController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showPopup = false;
        });
      }
    });
  }

  void _onReset() {
    _fadeController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showPopup = false;
        });
      }
    });
  }

  void _onHints() {
    _fadeController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showPopup = false;
          _showHintPopup = true;
        });
        _hintSlideController.forward();
      }
    });
  }

  void _onCloseHint() {
    _hintSlideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showHintPopup = false;
        });
      }
    });
  }

  void _onNextHint() {
    _hintSlideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showHintPopup = false;
        });
      }
      // TODO: Show next hint
    });
  }

  void _onRun() {
    if (_canvasRows.isEmpty) {
      return; // Can't run empty canvas
    }
    
    // Serialize canvas to Python code
    _updatePythonArtifactsLocked();
    final String pythonCode = _rawPython;
    
    if (pythonCode.trim().isEmpty) {
      return; // Can't run empty code
    }
    
    // Show run result popup with "RUNNING" status
    setState(() {
      _executionStatus = 'RUNNING';
      _isExecuting = true;
      _executionResult = null;
      _showRunResultPopup = true;
    });
    _runResultSlideController.forward();
    
    // Execute Python code
    _executePythonCode(pythonCode);
  }
  
  Future<void> _executePythonCode(String pythonCode) async {
    try {
      final result = await LocalPythonExecutor.instance.execute(pythonCode);
      
      if (!mounted) return;
      
      setState(() {
        _executionResult = result;
        _isExecuting = false;
        _hasExecutedCode = true;
        
        if (result.hasError) {
          _executionStatus = 'COMPILATION FAILED';
          // Switch to compiled failed popup if error
          _showRunResultPopup = false;
          _showCompiledFailedPopup = true;
          _runResultSlideController.reverse().then((_) {
            if (mounted) {
              _compiledFailedSlideController.forward();
            }
          });
        } else {
          _executionStatus = 'COMPILATION SUCCESSFUL';
        }
      });
    } catch (e) {
      if (!mounted) return;
      
      final String formattedError = 'Unexpected error: $e';
      setState(() {
        _executionResult = PythonExecutionResult(error: formattedError);
        _isExecuting = false;
        _executionStatus = 'COMPILATION FAILED';
        // Switch to compiled failed popup
        _showRunResultPopup = false;
        _showCompiledFailedPopup = true;
        _runResultSlideController.reverse().then((_) {
          if (mounted) {
            _compiledFailedSlideController.forward();
          }
        });
      });
    }
  }

  void _onCloseRunResult() {
    _runResultSlideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showRunResultPopup = false;
        });
      }
    });
  }

  void _toggleTableView() {
    setState(() {
      if (_executionResult != null) {
        // Currently showing results, clear them to show tiles
        _executionResult = null;
        _isExecuting = false;
      }
      // If not showing results, do nothing (tiles are already shown)
    });
  }

  Widget? _buildResultsContent() {
    if (_executionResult == null && !_isExecuting) {
      return null;
    }

    if (_isExecuting) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: const CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_executionResult!.error != null) {
      final String errorMessage = _executionResult!.error ?? 'Unknown error';
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF333436),
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 16.w,
          bottom: 16.w,
        ),
        child: SingleChildScrollView(
          child: GlassBox(
            radius: 12,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
            backgroundOpacity: 0.20,
            backgroundColorOverride: Colors.black,
            child: Text(
              'Error: $errorMessage',
              style: TextStyle(
                fontFamily: 'Consolas',
                fontSize: 12.sp,
                color: Colors.redAccent,
                height: 1.5,
              ),
            ),
          ),
        ),
      );
    }

    final PythonExecutionResult result = _executionResult!;
    
    // Extract headers from rows
    List<String> headers = [];
    if (result.rows.isNotEmpty) {
      headers = result.rows.first.keys.toList();
    }

    if (result.rows.isNotEmpty) {
      final List<List<String>> dataRows =
          result.rows
              .map((row) {
                return headers.map((header) {
                  final value = row[header];
                  return value?.toString() ?? 'NULL';
                }).toList();
              })
              .toList();

      // Table widget - replaces tabs/content area using StaticTable (SQL builder style)
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(12.w, 12.w, 12.w, 16.w),
            child: StaticTable(
              style: TableStylePalette.output(),
              columns:
                  headers
                      .map((header) => TableColumnConfig(header: header))
                      .toList(),
              rows: dataRows,
              expandToMaxWidth: true,
            ),
          ),
        ),
      );
    }

    if (headers.isNotEmpty) {
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(12.w, 12.w, 12.w, 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StaticTable(
                  style: TableStylePalette.output(),
                  columns:
                      headers
                          .map((header) => TableColumnConfig(header: header))
                          .toList(),
                  rows: const <List<String>>[],
                  expandToMaxWidth: true,
                ),
                SizedBox(height: 12.h),
                _buildNoRowsMessage(result.message ?? 'No results'),
              ],
            ),
          ),
        ),
      );
    }

    return _buildNoRowsMessage(result.message ?? 'No results');
  }

  Widget _buildNoRowsMessage(String message) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Text(
          message,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  void _onShowCompiledFailed() {
    // Close the run result popup first
    _runResultSlideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showRunResultPopup = false;
          _showCompiledFailedPopup = true;
        });
        _compiledFailedSlideController.forward();
      }
    });
  }

  void _onCloseCompiledFailed() {
    _compiledFailedSlideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showCompiledFailedPopup = false;
        });
      }
    });
  }

  void _onShowInformation() {
    // Close the compiled failed popup first
    _compiledFailedSlideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showCompiledFailedPopup = false;
          _showInformationPopup = true;
        });
        _informationSlideController.forward();
      }
    });
  }

  void _onCloseInformation() {
    _informationSlideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showInformationPopup = false;
        });
      }
    });
  }

  Widget _buildQuestionCard() {
    return GlassBox(
      radius: 16,
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Q:',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Write a loop to add an array of numbers.',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                height: 1.4,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.otherPageBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              if (_showPopup) {
                _fadeController.reverse().then((_) {
                  if (mounted) {
                    setState(() {
                      _showPopup = false;
                    });
                  }
                });
              } else if (_showHintPopup) {
                _hintSlideController.reverse().then((_) {
                  if (mounted) {
                    setState(() {
                      _showHintPopup = false;
                    });
                  }
                });
              } else if (_showRunResultPopup) {
                _runResultSlideController.reverse().then((_) {
                  if (mounted) {
                    setState(() {
                      _showRunResultPopup = false;
                    });
                  }
                });
              } else if (_showCompiledFailedPopup) {
                _compiledFailedSlideController.reverse().then((_) {
                  if (mounted) {
                    setState(() {
                      _showCompiledFailedPopup = false;
                    });
                  }
                });
              } else if (_showInformationPopup) {
                _informationSlideController.reverse().then((_) {
                  if (mounted) {
                    setState(() {
                      _showInformationPopup = false;
                    });
                  }
                });
              }
            },
            child: Stack(
              children: [
                SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 280.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: BackTopBar(
                        title: 'PYTHON BUILDER',
                        showSettingsIcon: false,
                        customRightIcon: SvgPicture.asset(
                          AppIcons.infoThreeDots,
                          width: 24.w,
                          height: 24.h,
                          colorFilter: const ColorFilter.mode(
                            AppColors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        onCustomIconTap: _onInfoThreeDotsTap,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: _buildQuestionCard(),
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: PythonBuilderCanvas(
                        rows: _canvasRows,
                        rowIndents: _rowIndents.length == _canvasRows.length
                            ? _rowIndents
                            : List.filled(_canvasRows.length, 0.0),
                        onBlockDropped: _handleBlockDropped,
                        onRemoveBlock: _removeCanvasBlock,
                        onEditLiteral: (rowIndex, blockIndex, newLabel) {
                          setState(() {
                            _recordForUndo();
                            if (rowIndex >= 0 &&
                                rowIndex < _canvasRows.length &&
                                blockIndex >= 0 &&
                                blockIndex < _canvasRows[rowIndex].length) {
                              _canvasRows[rowIndex][blockIndex] =
                                  _canvasRows[rowIndex][blockIndex]
                                      .copyWith(label: newLabel);
                              _redoStack.clear();
                              _updatePythonArtifactsLocked();
                            }
                          });
                        },
                      ),
                    ),
                   
                    SizedBox(height: 160.h),
                  ],
                ),
              ),
              // Python Builder Toolbar - fixed at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: PythonBuilderToolbar(
                  onUndo: _canUndo && _executionResult == null ? _undo : null,
                  onRedo: _canRedo && _executionResult == null ? _redo : null,
                  onTableIcon: (_executionResult != null || _hasExecutedCode) ? _toggleTableView : null,
                  onRun: _onRun,
                  tableViewActive: _executionResult != null,
                  showTableIcon: _executionResult != null || _hasExecutedCode,
                  bottomContent: _buildResultsContent(),
                ),
              ),
              // Popup overlay
              if (_showPopup)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 0.h + 4.h, // SafeArea + 10 spacing + icon height
                  right: 0,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: PythonPopup(
                      onSkip: _onSkip,
                      onHints: _onHints,
                      onReset: _onReset,
                    ),
                  ),
                ),
              // Hint popup overlay
              if (_showHintPopup)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SlideTransition(
                    position: _hintSlideAnimation,
                    child: HintPopup(
                      onClose: _onCloseHint,
                      onNextHint: _onNextHint,
                    ),
                  ),
                ),
              // Run result popup overlay
              if (_showRunResultPopup)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SlideTransition(
                    position: _runResultSlideAnimation,
                    child: RunResultPopup(
                      onClose: _onCloseRunResult,
                      onShowCompiledFailed: _onShowCompiledFailed,
                      status: _executionStatus,
                      executionResult: _executionResult,
                      isExecuting: _isExecuting,
                    ),
                  ),
                ),
              // Compiled failed popup overlay
              if (_showCompiledFailedPopup)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SlideTransition(
                    position: _compiledFailedSlideAnimation,
                    child: CompiledFailedPopup(
                      onClose: _onCloseCompiledFailed,
                      onShowInformation: _onShowInformation,
                    ),
                  ),
                ),
              // Information popup overlay
              if (_showInformationPopup)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SlideTransition(
                    position: _informationSlideAnimation,
                    child: InformationPopup(
                      onClose: _onCloseInformation,
                    ),
                  ),
                ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}
