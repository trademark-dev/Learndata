import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;
  final int? selectedRowIndex;

  const ResultTable({
    super.key,
    required this.headers,
    required this.rows,
    this.selectedRowIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(8.r),
        bottomRight: Radius.circular(8.r),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 0.h), // Only top/bottom padding, no left/right
        decoration: BoxDecoration(
          color: const Color(0x1A009CFF), // #009CFF1A
          border: Border.all(
            color: Colors.white.withOpacity(0.075), // Simulating border-image gradient
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8.r), // All corners 8 radius
        ),
        child: Column(
          children: [
            // Header row
            Padding(
              padding: EdgeInsets.only(bottom: 1.h), // Only bottom padding
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ), // Header cell padding: 12 left/right, 10 top/bottom
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.r),
                    bottomRight: Radius.circular(8.r),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0x12FFFFFF), // #FFFFFF12
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: headers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final header = entry.value;
                    return Expanded(
                      child: Text(
                        header,
                        textAlign: index == 0 
                            ? TextAlign.left 
                            : (index == headers.length - 1 
                                ? TextAlign.right 
                                : TextAlign.center),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Data rows
            ...rows.asMap().entries.map((entry) {
              final rowIndex = entry.key;
              final row = entry.value;
              final isSelected = selectedRowIndex != null && rowIndex == selectedRowIndex;
              
              return Padding(
                padding: EdgeInsets.only(bottom: 0.h), // Only bottom padding
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ), // Row cell padding: 12 left/right, 10 top/bottom
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? const Color(0xFF11446A) // #11446A for selected row
                        : const Color(0x1AB9CEF1), // #B9CEF11A for other rows
                    border: Border(
                      left: isSelected 
                          ? BorderSide(
                              color: const Color(0xFF68C5FF), // #68C5FF
                              width: 3.w,
                            )
                          : BorderSide.none,
                      bottom: BorderSide(
                        color: const Color(0x0DFFFFFF), // #FFFFFF0D
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: row.asMap().entries.map((cellEntry) {
                      final cellIndex = cellEntry.key;
                      final cell = cellEntry.value;
                      return Expanded(
                        child: Text(
                          cell,
                          textAlign: cellIndex == 0 
                              ? TextAlign.left 
                              : (cellIndex == row.length - 1 
                                  ? TextAlign.right 
                                  : TextAlign.center),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
