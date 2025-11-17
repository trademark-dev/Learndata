import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:d99_learn_data_enginnering/src/common/theme/fonts.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/model/python_canvas_token.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/model/python_builder_drag_data.dart';

// Debug logging feature flag
const bool _kEnableCanvasDebugLogging = true;

class CanvasDropDetails {
  final int rowIndex;
  final bool insertAsNewRow;
  final bool forceAppendToBottom;
  final int? blockIndex; // Position within the row to insert at (null = append to end)

  const CanvasDropDetails({
    required this.rowIndex,
    this.insertAsNewRow = false,
    this.forceAppendToBottom = false,
    this.blockIndex,
  });
}

typedef CanvasDropCallback = void Function(
  PythonBuilderDragData data,
  CanvasDropDetails details,
);

typedef _RowDropCallback = void Function(
  PythonBuilderDragData data,
  bool forceAppendToBottom,
  int? blockIndex,
);

typedef _RowPreviewChanged = void Function(int rowIndex, bool isActive);

class PythonBuilderCanvas extends StatefulWidget {
  const PythonBuilderCanvas({
    super.key,
    required this.rows,
    required this.onBlockDropped,
    this.onRemoveBlock,
    this.rowIndents = const <double>[],
    this.onEditLiteral,
  });

  final List<List<PythonCanvasToken>> rows;
  final CanvasDropCallback onBlockDropped;
  final void Function(int rowIndex, int blockIndex)? onRemoveBlock;
  final List<double> rowIndents;
  final void Function(int rowIndex, int blockIndex, String newLabel)? onEditLiteral;

  @override
  State<PythonBuilderCanvas> createState() => _PythonBuilderCanvasState();
}

class _PythonBuilderCanvasState extends State<PythonBuilderCanvas> {
  final GlobalKey _canvasBoundsKey = GlobalKey();
  int _activeCanvasDrags = 0;
  bool _externalDragActive = false;
  final Set<int> _activePreviewRows = <int>{};

  bool get _hasRows => widget.rows.isNotEmpty;

  void _markDropHandled() {
    _stopExternalDrag();
  }

  void _onCanvasDragStarted() {
    setState(() {
      _activeCanvasDrags += 1;
    });
  }

  void _onCanvasDragFinished() {
    if (_activeCanvasDrags == 0) {
      return;
    }
    setState(() {
      _activeCanvasDrags -= 1;
    });
    if (_activeCanvasDrags == 0) {
      _stopExternalDrag();
    }
  }

  void _stopExternalDrag() {
    if (!mounted) {
      _externalDragActive = false;
      return;
    }
    if (!_externalDragActive) {
      return;
    }
    setState(() {
      _externalDragActive = false;
    });
  }

  void _handleRowPreviewChanged(int rowIndex, bool isActive) {
    final bool changed =
        isActive
            ? _activePreviewRows.add(rowIndex)
            : _activePreviewRows.remove(rowIndex);
    if (!changed || !mounted) {
      return;
    }
    setState(() {});
    if (_activePreviewRows.isEmpty) {
      _stopExternalDrag();
    }
  }

  bool _isPointInsideCanvas(Offset globalPosition) {
    final RenderBox? renderBox =
        _canvasBoundsKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return true;
    }
    final Offset topLeft = renderBox.localToGlobal(Offset.zero);
    final Rect bounds = topLeft & renderBox.size;
    return bounds.contains(globalPosition);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          key: _canvasBoundsKey,
          width: constraints.maxWidth,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // Unfocus any active editors
              FocusScope.of(context).unfocus();
            },
            child: GlassBox(
          radius: 16,
          width: constraints.maxWidth,
          padding: EdgeInsets.zero,
              child: Container(
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 4.w,
                  top: 16.w,
                  bottom: 16.w,
                ),
            constraints: BoxConstraints(minHeight: 160.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Always render hidden placeholder rows for accurate positioning
                // These rows are invisible but have same height as actual rows for accurate drop detection
                // This ensures first drop position matches preview position
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    if (!_hasRows)
                      // Empty canvas: Render 10 hidden placeholder rows for accurate drop detection
                      // These are invisible (opacity 0) but maintain same height as actual rows
                      for (int hiddenIndex = 0; hiddenIndex < 10; hiddenIndex++)
                        Opacity(
                          opacity: 0.0,
                          child: IgnorePointer(
                            ignoring: false, // Still allow drop detection
                          child: _RowDropTarget(
                              rowIndex: hiddenIndex,
                              blocks: <PythonCanvasToken>[],
                              indent: 0,
                              isPointInsideCanvas: _isPointInsideCanvas,
                              totalRows: 0,
                              onDrop: (data, forceAppend, blockIndex) {
                                // Hidden rows are always empty, so forceAppend should be false
                                // (we're dropping IN the empty row, not below it)
                                final bool finalForceAppendToBottom = false;
                                if (_kEnableCanvasDebugLogging) {
                                  print('   📍 Hidden placeholder row $hiddenIndex.onDrop:');
                                  print('      isEmptyRow=true, forceAppend=$forceAppend, finalForceAppendToBottom=$finalForceAppendToBottom');
                                }
                                widget.onBlockDropped(
                                  data,
                                  CanvasDropDetails(
                                    rowIndex: hiddenIndex,
                                    insertAsNewRow: true,
                                    forceAppendToBottom: finalForceAppendToBottom,
                                    blockIndex: blockIndex,
                                  ),
                                );
                              },
                              onRemove: null,
                              onEditLiteral: widget.onEditLiteral,
                              onDragStarted: _onCanvasDragStarted,
                              onDragFinished: _onCanvasDragFinished,
                              onDropHandled: _markDropHandled,
                              onPreviewChanged: _handleRowPreviewChanged,
                            ),
                          ),
                        )
                    else
                      // Has rows: Render actual rows
                      for (int index = 0; index <= widget.rows.length; index++)
                        if (index < widget.rows.length)
                          _RowDropTarget(
                            rowIndex: index,
                            blocks: widget.rows[index],
                            indent: index < widget.rowIndents.length
                                ? widget.rowIndents[index]
                                : 0,
                            isPointInsideCanvas: _isPointInsideCanvas,
                            totalRows: widget.rows.length,
                            onDrop: (data, forceAppend, blockIndex) {
                              // Determine if we should insert as new row:
                              // - If row is empty (no blocks), insert as new row (replace empty row)
                              // - If forceAppend is true (cursor below row), insert as new row after this one
                              // - Otherwise, insert in existing non-empty row
                              final bool isEmptyRow = widget.rows[index].isEmpty;
                              final bool shouldInsertAsNewRow = forceAppend || isEmptyRow;
                              
                              // For empty rows, forceAppendToBottom should be false (we're dropping IN the row, not below it)
                              // Only set forceAppendToBottom=true if explicitly requested AND row is not empty
                              final bool finalForceAppendToBottom = forceAppend && !isEmptyRow;
                              
                              if (_kEnableCanvasDebugLogging) {
                                print('   📍 _RowDropTarget.onDrop (row $index):');
                                print('      isEmptyRow=$isEmptyRow, forceAppend=$forceAppend');
                                print('      shouldInsertAsNewRow=$shouldInsertAsNewRow, finalForceAppendToBottom=$finalForceAppendToBottom');
                              }
                              
                              widget.onBlockDropped(
                                data,
                                CanvasDropDetails(
                                  rowIndex: index,
                                  insertAsNewRow: shouldInsertAsNewRow,
                                  forceAppendToBottom: finalForceAppendToBottom,
                                  blockIndex: blockIndex,
                                ),
                              );
                            },
                            onRemove: widget.onRemoveBlock != null
                                ? (blockIndex) => widget.onRemoveBlock!(index, blockIndex)
                                : null,
                            onEditLiteral: widget.onEditLiteral,
                            onDragStarted: _onCanvasDragStarted,
                            onDragFinished: _onCanvasDragFinished,
                            onDropHandled: _markDropHandled,
                            onPreviewChanged: _handleRowPreviewChanged,
                          )
                        else
                          // Last row for "append to end" drops
                          Opacity(
                            opacity: 0.0,
                            child: IgnorePointer(
                              ignoring: false, // Still allow drop detection
                              child: _RowDropTarget(
                                rowIndex: index,
                                blocks: <PythonCanvasToken>[],
                                indent: 0,
                                isPointInsideCanvas: _isPointInsideCanvas,
                                totalRows: widget.rows.length,
                                onDrop: (data, forceAppend, blockIndex) {
                                  // For "append to end" row, use the forceAppend value from onAcceptWithDetails
                                  // If false, replace the empty row; if true, append after it
                                  final bool finalForceAppendToBottom = forceAppend;
                                  if (_kEnableCanvasDebugLogging) {
                                    print('   📍 Append-to-end row $index.onDrop:');
                                    print('      isEmptyRow=true, forceAppend=$forceAppend, finalForceAppendToBottom=$finalForceAppendToBottom');
                                  }
                                  widget.onBlockDropped(
                                    data,
                          CanvasDropDetails(
                                      rowIndex: index,
                            insertAsNewRow: true,
                                      forceAppendToBottom: finalForceAppendToBottom,
                                      blockIndex: blockIndex,
                                    ),
                                  );
                                },
                                onRemove: null,
                                onEditLiteral: widget.onEditLiteral,
                                onDragStarted: _onCanvasDragStarted,
                                onDragFinished: _onCanvasDragFinished,
                                onDropHandled: _markDropHandled,
                                onPreviewChanged: _handleRowPreviewChanged,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


class _RowDropTarget extends StatefulWidget {
  const _RowDropTarget({
    required this.rowIndex,
    required this.blocks,
    required this.onDrop,
    required this.indent,
    required this.onDropHandled,
    required this.onDragStarted,
    required this.onDragFinished,
    required this.onPreviewChanged,
    required this.isPointInsideCanvas,
    required this.totalRows,
    this.onRemove,
    this.onEditLiteral,
  });

  final int rowIndex;
  final List<PythonCanvasToken> blocks;
  final _RowDropCallback onDrop;
  final ValueChanged<int>? onRemove;
  final double indent;
  final VoidCallback onDropHandled;
  final VoidCallback onDragStarted;
  final VoidCallback onDragFinished;
  final _RowPreviewChanged onPreviewChanged;
  final bool Function(Offset globalPosition) isPointInsideCanvas;
  final int totalRows;
  final void Function(int rowIndex, int blockIndex, String newLabel)? onEditLiteral;

  @override
  State<_RowDropTarget> createState() => _RowDropTargetState();
}

class _RowDropTargetState extends State<_RowDropTarget> {
  static const double _rowBaseHeight = 24;
  static const double _rowPadding = 0.5;
  bool _wasHovering = false;
  int? _dropTargetIndex;
  bool _isDraggingWithinRow = false;
  int? _sourceBlockIndex; // Track which tile is being dragged within this row
  final List<GlobalKey> _tileKeys = [];
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _rowKey = GlobalKey();
  double? _lastCursorY; // Track last cursor Y position for drop detection

  void _updateDropTargetIndex(Offset globalOffset) {
    if (_kEnableCanvasDebugLogging) {
      print(
        '   _updateDropTargetIndex: tileKeys.length=${_tileKeys.length}, blocks.length=${widget.blocks.length}',
      );
    }
    int targetIndex = widget.blocks.length; // Default to after last tile
    bool foundTileContainingCursor = false;

    for (int i = 0; i < _tileKeys.length; i++) {
      final RenderBox? box =
          _tileKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box == null) {
        if (_kEnableCanvasDebugLogging) {
          print('   Tile $i: box is null');
        }
        continue;
      }

      final Offset tilePosition = box.localToGlobal(Offset.zero);
      final Size tileSize = box.size;
      final Rect tileRect = tilePosition & tileSize;

      if (_kEnableCanvasDebugLogging) {
        print('   Tile $i: rect=$tileRect');
      }

      if (tileRect.contains(globalOffset)) {
        final double relativePosInTile = globalOffset.dx - tileRect.left;
        final double midpoint = tileSize.width / 2;
        targetIndex = relativePosInTile < midpoint ? i : i + 1;
        foundTileContainingCursor = true;
        if (_kEnableCanvasDebugLogging) {
          print(
            '   ✅ Over tile $i - relativePosInTile=$relativePosInTile, midpoint=$midpoint, targetIndex=$targetIndex',
          );
        }
        break;
      }
    }

    // Handle gaps between tiles - check if cursor is between two adjacent tiles
    if (!foundTileContainingCursor && _tileKeys.length >= 2) {
      for (int i = 0; i < _tileKeys.length - 1; i++) {
        final RenderBox? currentBox =
            _tileKeys[i].currentContext?.findRenderObject() as RenderBox?;
        final RenderBox? nextBox =
            _tileKeys[i + 1].currentContext?.findRenderObject() as RenderBox?;

        if (currentBox != null && nextBox != null) {
          final double currentRight =
              currentBox.localToGlobal(Offset.zero).dx + currentBox.size.width;
          final double nextLeft = nextBox.localToGlobal(Offset.zero).dx;

          // Check if cursor is in the gap between current and next tile
          if (globalOffset.dx > currentRight && globalOffset.dx < nextLeft) {
            targetIndex = i + 1; // Position between the two tiles
            if (_kEnableCanvasDebugLogging) {
              print(
                '   🔵 In gap between tile $i and ${i + 1}: cursorX=${globalOffset.dx.toStringAsFixed(1)}, gap=[${currentRight.toStringAsFixed(1)} to ${nextLeft.toStringAsFixed(1)}], targetIndex=$targetIndex',
              );
            }
            foundTileContainingCursor = true;
            break;
          }
        }
      }
    }

    if (_kEnableCanvasDebugLogging) {
      print(
        '   Final targetIndex: $targetIndex (current _dropTargetIndex: $_dropTargetIndex)',
      );
    }

    if (_dropTargetIndex != targetIndex) {
      if (_kEnableCanvasDebugLogging) {
        print(
          '   📝 Updating _dropTargetIndex from $_dropTargetIndex to $targetIndex',
        );
      }
      setState(() => _dropTargetIndex = targetIndex);
    }
  }

  void _notifyHover(bool isHovering) {
    if (_wasHovering == isHovering) {
      return;
    }
    _wasHovering = isHovering;
    widget.onPreviewChanged(widget.rowIndex, isHovering);
  }

  @override
  void dispose() {
    if (_wasHovering) {
      widget.onPreviewChanged(widget.rowIndex, false);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double indentPx = widget.indent * 24.w;

    return DragTarget<PythonBuilderDragData>(
      key: _rowKey,
        onWillAcceptWithDetails: (details) {
        _notifyHover(true);
        // Initialize drop target index if dragging within same row
        final bool isDraggingWithinRow =
            details.data.sourceRowIndex == widget.rowIndex;
        final bool isEmptyRow = widget.blocks.isEmpty;
        
        // CRITICAL: Always set _dropTargetIndex immediately for empty rows to show preview
        // This ensures preview shows on first drag, even before onMove is called
        if (isEmptyRow && _dropTargetIndex == null) {
          setState(() {
            _dropTargetIndex = 0;
          });
          if (_kEnableCanvasDebugLogging) {
            print('   📍 onWillAcceptWithDetails: Empty row - setting _dropTargetIndex=0 for preview');
          }
        } else if (_dropTargetIndex == null &&
            isDraggingWithinRow &&
            details.data.sourceBlockIndex != null) {
          setState(() {
            _dropTargetIndex = details.data.sourceBlockIndex;
            _isDraggingWithinRow = true;
            _sourceBlockIndex = details.data.sourceBlockIndex;
          });
        } else if (isDraggingWithinRow && !_isDraggingWithinRow) {
          setState(() {
            _isDraggingWithinRow = true;
            _sourceBlockIndex = details.data.sourceBlockIndex;
          });
        } else if (!isDraggingWithinRow && !isEmptyRow && _dropTargetIndex == null) {
          // Initialize for external drag - default to append position
          // For non-empty rows, default to end
          setState(() {
            _dropTargetIndex = widget.blocks.length;
          });
        }
        // Always accept (like SQL builder) - actual drop position determined in onMove/onAcceptWithDetails
        return true;
      },
      onMove: (details) {
        _notifyHover(true);
        // Calculate drop target index if cursor is within this row's vertical bounds or just below
        final RenderBox? rowBox =
            _rowKey.currentContext?.findRenderObject() as RenderBox?;
        if (rowBox != null) {
          final Offset rowGlobalPos = rowBox.localToGlobal(Offset.zero);
          final double rowTop = rowGlobalPos.dy;
          final double rowBottom = rowGlobalPos.dy + rowBox.size.height;
          final double cursorY = details.offset.dy;
          
          // Expanded drop zone: only for last row, and much smaller for other rows
          // This prevents accidental "new row" creation when dropping below tiles in same row
          final bool isLastRow = widget.rowIndex == widget.totalRows - 1;
          // Use small expanded zone (only 20px) for non-last rows to allow precise drops
          // Use larger zone (200px) only for last row
          final double expandedZoneHeight = isLastRow ? 200.0 : 20.0;
          final double expandedBottom = rowBottom + expandedZoneHeight;

          if (_kEnableCanvasDebugLogging) {
            print('🟡 _RowDropTarget.onMove (row ${widget.rowIndex}, isLastRow=$isLastRow):');
            print('   cursorY=$cursorY, rowTop=$rowTop, rowBottom=$rowBottom, expandedBottom=$expandedBottom');
          }

          // Update if cursor is within this row's vertical bounds or expanded zone
          // ALWAYS track cursor position when it's in our zone (even if below row)
          if (cursorY >= rowTop && cursorY <= expandedBottom) {
            // Check if cursor is actually in this row's expanded zone or if it's in next row's bounds
            // If next row exists and cursor is in its bounds, don't handle here (let next row handle it)
            final bool isLastRow = widget.rowIndex == widget.totalRows - 1;
            bool shouldHandleThisRow = true;
            
            if (!isLastRow) {
              // Cursor might be in next row's bounds - check approximate bounds
              // For now, we'll handle it if cursor is clearly in our expanded zone or row bounds
              // Expanded zone priority: if cursor is between rowBottom and rowBottom + expandedZoneHeight/2, handle here
              // Otherwise, let next row handle it if cursor is closer to next row
              if (cursorY > rowBottom) {
                final double expandedZoneMidpoint = rowBottom + (expandedZoneHeight / 2);
                // If cursor is below expanded zone midpoint, next row should handle it
                if (cursorY > expandedZoneMidpoint) {
                  shouldHandleThisRow = false;
                  if (_kEnableCanvasDebugLogging) {
                    print('   ⚠️ Cursor beyond expanded zone midpoint - next row should handle');
                  }
                }
              }
            }
            
            if (shouldHandleThisRow) {
              // Track last cursor position for drop detection - ALWAYS set it
              setState(() {
                _lastCursorY = cursorY;
              });
              
              // If cursor is within row bounds, calculate precise position using X coordinate
              // For empty rows, always set _dropTargetIndex to 0 to show preview
              if (widget.blocks.isEmpty && cursorY >= rowTop && cursorY <= expandedBottom) {
                setState(() {
                  _dropTargetIndex = 0;
                });
                if (_kEnableCanvasDebugLogging) {
                  print('   📍 Empty row detected - setting _dropTargetIndex=0 for preview');
                }
              } else if (cursorY >= rowTop && cursorY <= rowBottom) {
                // Call _updateDropTargetIndex to calculate precise horizontal position
                _updateDropTargetIndex(details.offset);
              } else if (cursorY > rowBottom && cursorY <= expandedBottom) {
                // Cursor is in expanded zone below row
                // For non-last rows: only use expanded zone if cursor is very close to row bottom (within 20px)
                // For last row: use full expanded zone
                final bool isLastRow = widget.rowIndex == widget.totalRows - 1;
                if (isLastRow || (cursorY - rowBottom) <= 20.0) {
                  // Only create new row if cursor is very close to row bottom (for non-last rows)
                  // or if it's the last row (full expanded zone)
                  if (_kEnableCanvasDebugLogging) {
                    print('   ✅ Cursor in expanded zone below row (${cursorY > rowBottom && cursorY <= expandedBottom}) - will create new row after row ${widget.rowIndex}');
                  }
                  // Set drop target index to end position for expanded zone drops
                  if (_dropTargetIndex != widget.blocks.length) {
                    setState(() {
                      _dropTargetIndex = widget.blocks.length;
                    });
                  }
                } else {
                  // Cursor is too far below row - calculate position as if in row
                  // This allows dropping below tiles in same row without creating new row
                  // Still calculate drop target index so preview shows correctly
                  _updateDropTargetIndex(details.offset);
                  if (_kEnableCanvasDebugLogging) {
                    print('   📍 Cursor too far below row - calculating position as if in row for preview');
                  }
                }
              }
            } else {
              // Cursor is beyond this row's expanded zone - clear tracking
              // Next row will handle it
              if (_kEnableCanvasDebugLogging) {
                print('   ⚠️ Cursor beyond expanded zone - next row should handle');
              }
            }
          } else {
            // Cursor is outside this row's zone - only clear if not in any row's zone
            // Don't clear here - let onLeave handle it
          }
        }
      },
      onLeave: (_) {
        // Don't clear _lastCursorY here - we need it in onAcceptWithDetails
        setState(() {
          _dropTargetIndex = null;
          _isDraggingWithinRow = false;
          _sourceBlockIndex = null;
          // Keep _lastCursorY for drop detection
        });
        _notifyHover(false);
      },
      onAcceptWithDetails: (details) {
        final PythonBuilderDragData data = details.data;
        final bool droppedInOriginRow =
            data.sourceRowIndex != null &&
            data.sourceRowIndex == widget.rowIndex;

        if (_kEnableCanvasDebugLogging) {
          print('🔵 onAcceptWithDetails (row ${widget.rowIndex}):');
          print('   _lastCursorY=$_lastCursorY, _dropTargetIndex=$_dropTargetIndex');
          print('   details.offset.dy=${details.offset.dy}');
        }

        // Check if drop was below the row (in expanded zone) using _lastCursorY
        // _lastCursorY is set in onMove when cursor is in expanded zone
        final RenderBox? rowBox =
            _rowKey.currentContext?.findRenderObject() as RenderBox?;
        bool forceAppendToBottom = false;
        
        // Check expanded zone only if we're not in same row AND cursor Y is tracked
        // Same-row drops use _dropTargetIndex for precise horizontal position
        if (!droppedInOriginRow && rowBox != null && _lastCursorY != null) {
          final Offset rowGlobalPos = rowBox.localToGlobal(Offset.zero);
          final double rowTop = rowGlobalPos.dy;
          final double rowBottom = rowGlobalPos.dy + rowBox.size.height;
          final double cursorY = _lastCursorY!;
          final bool isLastRow = widget.rowIndex == widget.totalRows - 1;
          final double expandedZoneHeight = isLastRow ? 200.0 : 20.0;
          final double expandedBottom = rowBottom + expandedZoneHeight;
          
          if (_kEnableCanvasDebugLogging) {
            print('   Checking expanded zone: cursorY=$cursorY, rowTop=$rowTop, rowBottom=$rowBottom, expandedBottom=$expandedBottom');
            print('   isLastRow=$isLastRow, expandedZoneHeight=$expandedZoneHeight');
          }
          
          // Only force append if cursor is clearly below the row (not in row bounds)
          // For non-last rows: only if cursor is very close to row bottom (within 20px)
          // For last row: use full expanded zone
          final bool isInRowBounds = cursorY >= rowTop && cursorY <= rowBottom;
          final bool isBelowRow = cursorY > rowBottom && cursorY <= expandedBottom;
          final bool isCloseToRowBottom = isBelowRow && (cursorY - rowBottom) <= 20.0;
          
          // Only create new row if:
          // 1. It's the last row AND cursor is in expanded zone, OR
          // 2. It's not the last row AND cursor is very close to row bottom (within 20px)
          if (isBelowRow && !isInRowBounds && (isLastRow || isCloseToRowBottom)) {
            // Cursor is in expanded zone - create new row after this one
            forceAppendToBottom = true;
            if (_kEnableCanvasDebugLogging) {
              print('🟢 Drop below row ${widget.rowIndex} - forceAppendToBottom=true');
              print('   Will insert new row after row ${widget.rowIndex} (at index ${widget.rowIndex + 1})');
              print('   isInRowBounds=$isInRowBounds, isBelowRow=$isBelowRow, isCloseToRowBottom=$isCloseToRowBottom');
            }
          } else {
            // Cursor is in row bounds or too far below - use _dropTargetIndex for precise horizontal position
            forceAppendToBottom = false;
            if (_kEnableCanvasDebugLogging) {
              print('🔴 Drop in row bounds or too far below - forceAppendToBottom=false');
              print('   Will insert at row ${widget.rowIndex} using _dropTargetIndex=$_dropTargetIndex');
              print('   isInRowBounds=$isInRowBounds, isBelowRow=$isBelowRow, isCloseToRowBottom=$isCloseToRowBottom');
            }
          }
        } else {
          // Default: use _dropTargetIndex for position
          forceAppendToBottom = false;
          if (_kEnableCanvasDebugLogging) {
            if (droppedInOriginRow) {
              print('ℹ️ Dropped in origin row - using _dropTargetIndex=$_dropTargetIndex, forceAppendToBottom=false');
            } else {
              print('ℹ️ Drop check - rowBox=${rowBox != null}, _lastCursorY=$_lastCursorY - using _dropTargetIndex=$_dropTargetIndex');
            }
          }
        }

        // Use calculated drop target index, or append to end if null
        final int? finalBlockIndex = _dropTargetIndex;

        if (droppedInOriginRow) {
          // Handle same-row rearrangement
          widget.onDrop(data, forceAppendToBottom, finalBlockIndex);
        } else {
          // Dropped from different row or toolbar
          widget.onDrop(data, forceAppendToBottom, finalBlockIndex);
        }

        setState(() {
          _dropTargetIndex = null;
          _isDraggingWithinRow = false;
          _sourceBlockIndex = null;
          _lastCursorY = null; // Clear after drop is handled
        });
        widget.onDropHandled();
        _notifyHover(false);
      },
      builder: (context, candidateData, rejectedData) {
        final List<PythonBuilderDragData> previews =
            candidateData.whereType<PythonBuilderDragData>().toList();
        final bool isHovering = previews.isNotEmpty;

        if (!isHovering && _wasHovering) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _notifyHover(false);
            }
          });
        }

        // Check if we're dragging a tile from this same row
        final bool isDraggingWithinRow = previews.any(
          (preview) => preview.sourceRowIndex == widget.rowIndex,
        );

        // Build chip widgets - show all tiles with their positions
        // Initialize tile keys if needed
        while (_tileKeys.length < widget.blocks.length) {
          _tileKeys.add(GlobalKey());
        }
        while (_tileKeys.length > widget.blocks.length) {
          _tileKeys.removeLast();
        }

        final List<Widget> chipWidgets = [];
        for (int i = 0; i < widget.blocks.length; i++) {
          final PythonCanvasToken token = widget.blocks[i];
          final VoidCallback? removeCallback =
              widget.onRemove != null ? () => widget.onRemove!(i) : null;
          chipWidgets.add(
            Container(
              key: _tileKeys[i],
              child: _CanvasChip(
                label: token.label,
                kind: token.kind,
                rowIndex: widget.rowIndex,
                blockIndex: i,
                onDragStarted: widget.onDragStarted,
                onDragFinished: widget.onDragFinished,
                onDropOutside: removeCallback,
                isPointInsideCanvas: widget.isPointInsideCanvas,
                onEditLiteral: widget.onEditLiteral != null
                    ? (newLabel) => widget.onEditLiteral!(widget.rowIndex, i, newLabel)
                      : null,
                literalType: token.literalType,
              ),
            ),
          );
        }

        // Only add preview chips when dragging from DIFFERENT row
        // Exception: Empty rows should ALWAYS show preview (widget.blocks.length==0)
        final bool isLeftHalfOfSingleTileTarget =
            !isDraggingWithinRow &&
            isHovering &&
            widget.blocks.length == 1 &&
            _dropTargetIndex == 0;

        // Insert preview chips at the calculated drop target index
        // This ensures preview shows exactly where the drop will occur
        // IMPORTANT: Always show preview for empty rows (first tile drop)
        final bool isEmptyRow = widget.blocks.isEmpty;
        if (isHovering &&
            (!isDraggingWithinRow || isEmptyRow) &&
            !isLeftHalfOfSingleTileTarget) {
          // Use _dropTargetIndex if available, otherwise default to end (or 0 for empty rows)
          final int insertIndex = _dropTargetIndex ?? (isEmptyRow ? 0 : chipWidgets.length);
          
          if (_kEnableCanvasDebugLogging) {
            print('   📍 Inserting preview tiles at index $insertIndex (widget.blocks.length=${widget.blocks.length}, chipWidgets.length=${chipWidgets.length}, isEmptyRow=$isEmptyRow)');
            print('   _dropTargetIndex=$_dropTargetIndex, isDraggingWithinRow=$isDraggingWithinRow');
          }
          
          // Create preview chips
          final List<Widget> previewChips = [];
          for (final preview in previews) {
            previewChips.add(
              _CanvasChip(
                label: preview.label,
                kind: preview.kind,
              isPreview: true,
            ),
            );
          }
          
          // Insert preview chips at the calculated position
          // Clamp insertIndex to valid range [0, chipWidgets.length]
          final int clampedIndex = insertIndex.clamp(0, chipWidgets.length);
          chipWidgets.insertAll(clampedIndex, previewChips);
          
          if (_kEnableCanvasDebugLogging) {
            print('   ✅ Preview tiles inserted at index $clampedIndex (total chipWidgets: ${chipWidgets.length})');
          }
        }

        final bool hasContent = chipWidgets.isNotEmpty;

        // Determine if blue indicator should be shown:
        // 1. When dragging within same row: only if row has 2+ tiles AND not at positions adjacent to source
        // 2. When dragging from external source (different row or palette): only if target row has 2+ existing blocks
        final bool shouldShowIndicator;
        if (_isDraggingWithinRow) {
          // Same row drag: need 2+ tiles to show indicator
          // But hide indicator if it would appear immediately before or after the source tile
          if (widget.blocks.length >= 2 &&
              _sourceBlockIndex != null &&
              _dropTargetIndex != null) {
            // Don't show indicator if dropTargetIndex is at sourceBlockIndex or sourceBlockIndex + 1
            shouldShowIndicator =
                _dropTargetIndex != _sourceBlockIndex &&
                _dropTargetIndex != _sourceBlockIndex! + 1;
          } else {
            shouldShowIndicator = widget.blocks.length >= 2;
          }
        } else if (isHovering && previews.isNotEmpty) {
          // External drag hovering over this row
          shouldShowIndicator =
              widget.blocks.length >= 2 || isLeftHalfOfSingleTileTarget;
        } else {
          shouldShowIndicator = false;
        }

        final Widget rowBody = Padding(
          padding: EdgeInsets.only(left: indentPx, right: 1.2.w),
          child: hasContent
              ? _RowContent(
                  tileKeys: _tileKeys,
                  dropTargetIndex:
                      shouldShowIndicator ? _dropTargetIndex : null,
                  stackKey: _stackKey,
                  children: chipWidgets,
                )
              : const SizedBox.shrink(),
        );

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: _rowPadding.h),
          constraints: BoxConstraints(minHeight: _rowBaseHeight.h),
          decoration: const BoxDecoration(),
          child: Align(alignment: Alignment.centerLeft, child: rowBody),
        );
      },
    );
  }
}

class _RowContent extends StatelessWidget {
  const _RowContent({
    required this.children,
    required this.tileKeys,
    this.dropTargetIndex,
    this.stackKey,
  });

  final List<Widget> children;
  final List<GlobalKey> tileKeys;
  final int? dropTargetIndex;
  final GlobalKey? stackKey;

  double? _calculateIndicatorPosition() {
    if (_kEnableCanvasDebugLogging) {
      print(
        '📍 _calculateIndicatorPosition: dropTargetIndex=$dropTargetIndex, tileKeys.length=${tileKeys.length}',
      );
    }

    // Get Stack's global position to convert tile positions to local coordinates
    final RenderBox? stackBox =
        stackKey?.currentContext?.findRenderObject() as RenderBox?;
    if (stackBox == null) {
      return null;
    }
    final Offset stackGlobalPos = stackBox.localToGlobal(Offset.zero);

    if (dropTargetIndex == null || dropTargetIndex! >= tileKeys.length) {
      // Position after the last tile
      if (tileKeys.isEmpty) {
        return null;
      }
      final RenderBox? lastBox =
          tileKeys.last.currentContext?.findRenderObject() as RenderBox?;
      if (lastBox == null) {
        return null;
      }
      final Offset lastGlobalPos = lastBox.localToGlobal(Offset.zero);
      final double globalIndicatorPos =
          lastGlobalPos.dx + lastBox.size.width + 3.w;
      final double localIndicatorPos = globalIndicatorPos - stackGlobalPos.dx;
      return localIndicatorPos;
    }

    // Position before the target tile
    final RenderBox? box =
        tileKeys[dropTargetIndex!].currentContext?.findRenderObject()
            as RenderBox?;
    if (box == null) {
      return null;
    }
    final Offset globalPos = box.localToGlobal(Offset.zero);
    final double globalIndicatorPos = globalPos.dx - 3.w;
    final double localIndicatorPos = globalIndicatorPos - stackGlobalPos.dx;
    return localIndicatorPos;
  }

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    final double? indicatorLeft =
        dropTargetIndex != null ? _calculateIndicatorPosition() : null;

    return Stack(
      key: stackKey,
      clipBehavior: Clip.none,
            children: [
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 3.w,
          runSpacing: 8.h,
          children: children,
        ),
        if (indicatorLeft != null && dropTargetIndex != null)
          Positioned(
            left: indicatorLeft,
            top: 0,
            bottom: 0,
            child: Container(
              width: 2,
              height: 24.h,
              decoration: BoxDecoration(
                color: const Color(0xFF5DB3FF),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyCanvasDropTarget extends StatefulWidget {
  const _EmptyCanvasDropTarget({
    required this.onAccept,
  });

  final void Function(PythonBuilderDragData data, int rowIndex) onAccept;

  @override
  State<_EmptyCanvasDropTarget> createState() => _EmptyCanvasDropTargetState();
}

class _EmptyCanvasDropTargetState extends State<_EmptyCanvasDropTarget> {
  final GlobalKey _emptyTargetKey = GlobalKey();
  int _calculatedRowIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DragTarget<PythonBuilderDragData>(
      key: _emptyTargetKey,
      onWillAcceptWithDetails: (_) => true,
      onMove: (details) {
        // Calculate row index based on Y position
        final RenderBox? targetBox =
            _emptyTargetKey.currentContext?.findRenderObject() as RenderBox?;
        if (targetBox != null) {
          final Offset targetGlobalPos = targetBox.localToGlobal(Offset.zero);
          final double targetTop = targetGlobalPos.dy;
          final double targetBottom = targetGlobalPos.dy + targetBox.size.height;
          final double cursorY = details.offset.dy;
          
          // Calculate relative Y position (0.0 to 1.0)
          final double relativeY = (cursorY - targetTop) / (targetBottom - targetTop);
          
          // Estimate row height (similar to _rowBaseHeight + padding)
          const double estimatedRowHeight = 48.0; // 24 base + 12 margin + 12 padding
          final int totalEstimatedRows = (targetBox.size.height / estimatedRowHeight).ceil();
          
          // Calculate row index based on relative position
          final int calculatedRow = (relativeY * totalEstimatedRows).floor().clamp(0, totalEstimatedRows);
          
          if (_kEnableCanvasDebugLogging) {
            print('🟢 _EmptyCanvasDropTarget.onMove:');
            print('   cursorY=$cursorY, targetTop=$targetTop, targetBottom=$targetBottom');
            print('   relativeY=$relativeY, totalEstimatedRows=$totalEstimatedRows');
            print('   calculatedRow=$calculatedRow (old: $_calculatedRowIndex)');
          }
          
          if (_calculatedRowIndex != calculatedRow) {
            setState(() {
              _calculatedRowIndex = calculatedRow;
            });
          }
        }
      },
      onAcceptWithDetails: (details) {
        if (_kEnableCanvasDebugLogging) {
          print('🟢 _EmptyCanvasDropTarget.onAcceptWithDetails:');
          print('   _calculatedRowIndex=$_calculatedRowIndex');
        }
        widget.onAccept(details.data, _calculatedRowIndex);
      },
      builder: (context, candidateData, rejectedData) {
        final List<PythonBuilderDragData> previews =
            candidateData.whereType<PythonBuilderDragData>().toList();
        final bool fadePlaceholder = previews.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          constraints: BoxConstraints(minHeight: 160.h),
          alignment: Alignment.topLeft,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              IgnorePointer(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.easeOut,
                  opacity: fadePlaceholder ? 0.0 : 1.0,
                  child: const SizedBox.shrink(),
                ),
              ),
              if (previews.isNotEmpty)
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: (_calculatedRowIndex * 48.0).h),
                    child: _RowContent(
                      tileKeys: const [],
                      children:
                          previews
                              .map(
                                (value) => _CanvasChip(
                                  label: value.label,
                                  kind: value.kind,
                                  isPreview: true,
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildCanvasChipBody(
  BuildContext context,
  String label, {
  bool isPreview = false,
  double? minWidth,
  double? textScaleFactorOverride,
  Key? widthKey,
  bool hideText = false,
}) {
  final double textScaleFactor =
      textScaleFactorOverride ??
      MediaQuery.maybeOf(context)?.textScaleFactor ??
      1.0;
  final TextStyle baseStyle = TextStyle(
    fontFamily: AppFonts.geistMono,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: Colors.white,
  );

  final TextPainter painter = TextPainter(
    text: TextSpan(text: label, style: baseStyle),
    maxLines: 1,
    textDirection: TextDirection.ltr,
    textScaleFactor: textScaleFactor,
  )..layout(maxWidth: double.infinity);

  final double horizontalPadding = 3.w;
  final double verticalPadding = 2.h;
  final double widthBuffer = 2.w;
  double chipWidth = painter.width + horizontalPadding * 2 + 2 + widthBuffer;

  if (minWidth != null) {
    chipWidth = math.max(chipWidth, minWidth);
  }

  final double backgroundOpacity = isPreview ? 0.03 : 0.06;
  final double edgeOpacity = isPreview ? 0.09 : 0.125;

  Widget textWidget = hideText
      ? SizedBox(height: baseStyle.fontSize! * baseStyle.height!)
      : Text(
          label,
          style: baseStyle,
          maxLines: 1,
          overflow: TextOverflow.visible,
          softWrap: false,
          textAlign: TextAlign.center,
        );

  Widget textContent =
      isPreview ? Opacity(opacity: 0.5, child: textWidget) : textWidget;

  // Use Container with decoration for custom opacity since GlassBox has fixed opacity
  Widget chip = Container(
    width: chipWidth,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6.r),
      color: Colors.white.withOpacity(backgroundOpacity),
      border: Border.all(
        color: Colors.white.withOpacity(edgeOpacity),
        width: 1,
      ),
    ),
    padding: EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    ),
    child: Center(child: textContent),
  );

  return SizedBox(key: widthKey, width: chipWidth, child: chip);
}

class _CanvasChip extends StatefulWidget {
  const _CanvasChip({
    required this.label,
    this.kind = PythonCanvasTokenKind.unknown,
    this.isPreview = false,
    this.rowIndex,
    this.blockIndex,
    this.onDragStarted,
    this.onDragFinished,
    this.onDropOutside,
    this.isPointInsideCanvas,
    this.onEditLiteral,
    this.literalType,
  });

  final String label;
  final PythonCanvasTokenKind kind;
  final bool isPreview;
  final int? rowIndex;
  final int? blockIndex;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragFinished;
  final VoidCallback? onDropOutside;
  final bool Function(Offset globalPosition)? isPointInsideCanvas;
  final void Function(String newLabel)? onEditLiteral;
  final String? literalType;

  @override
  State<_CanvasChip> createState() => _CanvasChipState();
}

class _CanvasChipState extends State<_CanvasChip> {
  bool _isEditingLiteral = false;
  TextEditingController? _literalController;
  final FocusNode _literalFocusNode = FocusNode();
  final GlobalKey _chipSizeKey = GlobalKey();

  bool get _isLiteralTile => widget.kind == PythonCanvasTokenKind.literal;

  @override
  void initState() {
    super.initState();
    _literalFocusNode.addListener(_handleLiteralFocusChange);
  }

  @override
  void dispose() {
    _literalFocusNode
      ..removeListener(_handleLiteralFocusChange)
      ..dispose();
    _literalController?.dispose();
    super.dispose();
  }

  void _handleLiteralFocusChange() {
    if (!_literalFocusNode.hasFocus && _isEditingLiteral) {
      _commitLiteralEdit();
    }
  }

  void _enterLiteralEditMode() {
    if (!_isLiteralTile || widget.onEditLiteral == null) {
      return;
    }
    if (_isEditingLiteral) {
      _literalFocusNode.requestFocus();
      return;
    }
    setState(() {
      _isEditingLiteral = true;
    });
    final TextEditingController controller = _obtainLiteralController();
    controller
      ..text = ''
      ..selection = const TextSelection.collapsed(offset: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _literalFocusNode.requestFocus();
      }
    });
  }

  void _commitLiteralEdit() {
    if (!_isEditingLiteral) {
      return;
    }
    final String nextValue = _literalController?.text ?? '';
    final String sanitizedValue = _sanitizeLiteralInput(nextValue);
    setState(() {
      _isEditingLiteral = false;
    });
    if (
      widget.onEditLiteral != null &&
      widget.rowIndex != null &&
      widget.blockIndex != null &&
      sanitizedValue.isNotEmpty &&
      sanitizedValue != widget.label
    ) {
      widget.onEditLiteral!(sanitizedValue);
      final TextEditingController controller = _obtainLiteralController();
      controller
        ..text = sanitizedValue
        ..selection = TextSelection.collapsed(offset: controller.text.length);
    } else {
      final TextEditingController controller = _obtainLiteralController();
      controller
        ..text = widget.label
        ..selection = TextSelection.collapsed(offset: controller.text.length);
    }
  }

  TextEditingController _obtainLiteralController() {
    _literalController ??= TextEditingController(text: widget.label)
      ..selection = TextSelection.collapsed(offset: widget.label.length);
    return _literalController!;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData effectiveMediaQuery =
        MediaQuery.maybeOf(context) ??
        MediaQueryData.fromView(View.of(context));
    final double textScaleFactor = effectiveMediaQuery.textScaleFactor;

    final String displayLabel = _isEditingLiteral
        ? (_literalController?.text ?? widget.label)
        : widget.label;

    Widget chipBody = _buildCanvasChipBody(
      context,
      displayLabel,
      isPreview: widget.isPreview,
      textScaleFactorOverride: textScaleFactor,
      widthKey: widget.isPreview ? null : _chipSizeKey,
      hideText: _isEditingLiteral,
    );

    // Add TextField overlay for literal editing
    if (_isEditingLiteral) {
      chipBody = Stack(
        clipBehavior: Clip.none,
        children: [
          chipBody,
          Positioned.fill(
              child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              child: _LiteralInlineEditor(
                controller: _obtainLiteralController(),
                focusNode: _literalFocusNode,
                onSubmit: _commitLiteralEdit,
              ),
            ),
          ),
        ],
      );
    }

    if (widget.isPreview ||
        widget.rowIndex == null ||
        widget.blockIndex == null) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: chipBody,
      );
    }

    final PythonBuilderDragData payload = PythonBuilderDragData(
      label: widget.label,
      kind: widget.kind,
      sourceRowIndex: widget.rowIndex,
      sourceBlockIndex: widget.blockIndex,
      literalType: widget.literalType,
    );

    bool handledOutsideDrop = false;
    void maybeHandleOutsideDrop(Offset globalPosition, bool wasAccepted) {
      if (handledOutsideDrop || widget.onDropOutside == null) {
        return;
      }
      if (widget.isPointInsideCanvas == null) {
        return;
      }
      // Only remove the tile if it was NOT accepted AND dropped outside canvas bounds
      if (!wasAccepted && !widget.isPointInsideCanvas!(globalPosition)) {
        handledOutsideDrop = true;
        widget.onDropOutside!();
      }
    }

    final Widget draggableChild = Draggable<PythonBuilderDragData>(
      data: payload,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: MediaQuery(
        data: effectiveMediaQuery,
        child: _CanvasChipDragFeedback(
          label: widget.label,
          textScaleFactor: textScaleFactor,
        ),
      ),
      maxSimultaneousDrags: _isEditingLiteral ? 0 : null,
      onDragStarted: () {
        widget.onDragStarted?.call();
      },
      onDragEnd: (details) {
        maybeHandleOutsideDrop(details.offset, details.wasAccepted);
        widget.onDragFinished?.call();
      },
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: _buildCanvasChipBody(
            context,
            widget.label,
            textScaleFactorOverride: textScaleFactor,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: chipBody,
      ),
    );

    final bool canEditLiteral =
        _isLiteralTile && widget.onEditLiteral != null;
    Widget result = draggableChild;
    if (canEditLiteral && !_isEditingLiteral) {
      result = _TapPassthroughListener(
        onTap: _enterLiteralEditMode,
        child: draggableChild,
      );
    }

    return result;
  }
}

class _LiteralInlineEditor extends StatelessWidget {
  const _LiteralInlineEditor({
    required this.controller,
    required this.focusNode,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(
      fontFamily: AppFonts.geistMono,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: Colors.white,
    );

    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: true,
      cursorColor: Colors.white,
      cursorWidth: 2,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      style: style,
      decoration: const InputDecoration(
        isCollapsed: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
      ),
      onSubmitted: (_) => onSubmit(),
      onEditingComplete: onSubmit,
    );
  }
}

class _CanvasChipDragFeedback extends StatelessWidget {
  const _CanvasChipDragFeedback({
    required this.label,
    required this.textScaleFactor,
  });

  final String label;
  final double textScaleFactor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Opacity(
        opacity: 0.7,
        child: _buildCanvasChipBody(
          context,
          label,
          textScaleFactorOverride: textScaleFactor,
        ),
      ),
    );
  }
}

// Listens for taps without entering the gesture arena so drags keep working.
class _TapPassthroughListener extends StatefulWidget {
  const _TapPassthroughListener({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  State<_TapPassthroughListener> createState() => _TapPassthroughListenerState();
}

class _TapPassthroughListenerState extends State<_TapPassthroughListener> {
  static const double _tapSlop = 6.0;
  int? _activePointer;
  Offset? _downPosition;
  bool _movedBeyondSlop = false;

  void _resetTracking() {
    _activePointer = null;
    _downPosition = null;
    _movedBeyondSlop = false;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (_activePointer != null) {
      return;
    }
    _activePointer = event.pointer;
    _downPosition = event.position;
    _movedBeyondSlop = false;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (event.pointer != _activePointer || _downPosition == null || _movedBeyondSlop) {
      return;
    }
    final Offset delta = event.position - _downPosition!;
    if (delta.distanceSquared > _tapSlop * _tapSlop) {
      _movedBeyondSlop = true;
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (event.pointer != _activePointer) {
      return;
    }
    final bool shouldTriggerTap = !_movedBeyondSlop;
    _resetTracking();
    if (shouldTriggerTap) {
      widget.onTap();
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (event.pointer != _activePointer) {
      return;
    }
    _resetTracking();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.deferToChild,
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      child: widget.child,
    );
  }
}

const Map<String, String> _kLiteralReplacementMap = <String, String>{
  '\u2018': "'",
  '\u2019': "'",
  '\u201A': "'",
  '\u201B': "'",
  '\u02BC': "'",
  '\u02BB': "'",
  '\u00B4': "'",
  '\u201C': '"',
  '\u201D': '"',
  '\u201E': '"',
  '\u201F': '"',
  '\u00AB': '"',
  '\u00BB': '"',
  '\u2013': '-',
  '\u2014': '-',
  '\u2015': '-',
  '\u2212': '-',
  '\u2026': '...',
};

String _sanitizeLiteralInput(String input) {
  if (input.isEmpty) {
    return '';
  }
  String sanitized = input;
  _kLiteralReplacementMap.forEach((String source, String target) {
    if (sanitized.contains(source)) {
      sanitized = sanitized.replaceAll(source, target);
    }
  });
  sanitized = sanitized
      .replaceAll(RegExp(r'[\u00A0\u2007\u202F]'), ' ')
      .replaceAll(RegExp(r'[\u200B-\u200D\u2060\uFEFF]'), '');
  return sanitized.trim();
}
