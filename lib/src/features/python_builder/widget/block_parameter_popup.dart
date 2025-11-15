import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/fonts.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/model/block_metadata.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/all_types_python_widgets.dart';

class BlockParameterPopup extends StatefulWidget {
  final String label;
  final BlockParameterRequirement requirement;

  const BlockParameterPopup({
    super.key,
    required this.label,
    required this.requirement,
  });

  static Future<List<String>?> show(
    BuildContext context, {
    required String label,
    required BlockParameterRequirement requirement,
  }) {
    return showDialog<List<String>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => BlockParameterPopup(
        label: label,
        requirement: requirement,
      ),
    );
  }

  @override
  State<BlockParameterPopup> createState() => _BlockParameterPopupState();
}

class _BlockParameterPopupState extends State<BlockParameterPopup> {
  late final List<TextEditingController> _controllers;
  bool _showError = false;
  String? _selectedSingleValue;
  String? _selectedLeftValue;
  String? _selectedRightValue;

  int get _fieldCount =>
      widget.requirement == BlockParameterRequirement.double ? 2 : 1;

  bool get _isSingleSelector =>
      widget.requirement == BlockParameterRequirement.single;
  bool get _isDoubleSelector =>
      widget.requirement == BlockParameterRequirement.double;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(_fieldCount, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  void _onSubmit() {
    final values = _controllers
        .map((controller) => controller.text.trim())
        .toList(growable: false);
    final hasEmpty = values.any((value) => value.isEmpty);
    if (hasEmpty) {
      setState(() {
        _showError = true;
      });
      return;
    }
    Navigator.of(context).pop(values);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 24.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: const Color(0xFF101B2B),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Provide parameters',
              style: TextStyle(
                fontFamily: AppFonts.geistMono,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              widget.label.toUpperCase(),
              style: TextStyle(
                fontFamily: AppFonts.geistMono,
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                color: AppColors.textLightBlue,
              ),
            ),
            SizedBox(height: 16.h),
            if (_isSingleSelector) ...[
              _buildSelectionGrid(
                options: ParameterOptionSets.singleParameterOptions,
                selectedValue: _selectedSingleValue,
                onSelected: (value) {
                  setState(() {
                    _selectedSingleValue = value;
                    _controllers.first.text = value;
                    _showError = false;
                  });
                },
              ),
              SizedBox(height: 16.h),
            ] else if (_isDoubleSelector) ...[
              Text(
                'Left parameter',
                style: TextStyle(
                  fontFamily: AppFonts.geistMono,
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.75),
                ),
              ),
              SizedBox(height: 8.h),
              _buildSelectionGrid(
                options: ParameterOptionSets.doubleParameterLeftOptions,
                selectedValue: _selectedLeftValue,
                onSelected: (value) {
                  setState(() {
                    _selectedLeftValue = value;
                    _controllers[0].text = value;
                    _showError = false;
                  });
                },
              ),
              SizedBox(height: 16.h),
              Text(
                'Right parameter',
                style: TextStyle(
                  fontFamily: AppFonts.geistMono,
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.75),
                ),
              ),
              SizedBox(height: 8.h),
              _buildSelectionGrid(
                options: ParameterOptionSets.doubleParameterRightOptions,
                selectedValue: _selectedRightValue,
                onSelected: (value) {
                  setState(() {
                    _selectedRightValue = value;
                    if (_controllers.length > 1) {
                      _controllers[1].text = value;
                    }
                    _showError = false;
                  });
                },
              ),
              SizedBox(height: 16.h),
            ],
            if (!_isSingleSelector && !_isDoubleSelector)
              ...List.generate(
                _fieldCount,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: index == _fieldCount - 1 ? 0 : 12.h),
                  child: _buildInputField(index),
                ),
              ),
            if (_showError) ...[
              SizedBox(height: 8.h),
              Text(
                'Please fill all parameters.',
                style: TextStyle(
                  fontFamily: AppFonts.roboto,
                  fontSize: 12.sp,
                  color: Colors.redAccent,
                ),
              ),
            ],
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _onCancel,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: AppFonts.roboto,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                TextButton(
                  onPressed: _onSubmit,
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      fontFamily: AppFonts.roboto,
                      color: AppColors.textLightBlue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(int index) {
    return TextField(
      controller: _controllers[index],
      autofocus: !_isSingleSelector && index == 0,
      readOnly: _isSingleSelector,
      style: TextStyle(
        fontFamily: AppFonts.geistMono,
        color: AppColors.white,
        fontSize: 13.sp,
      ),
      decoration: InputDecoration(
        labelText: 'Parameter ${index + 1}',
        labelStyle: TextStyle(
          fontFamily: AppFonts.geistMono,
          color: Colors.white.withOpacity(0.6),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: AppColors.textLightBlue,
          ),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
      ),
      onChanged: (_) {
        if (_showError) {
          setState(() => _showError = false);
        }
      },
      onTap: (_isSingleSelector || _isDoubleSelector) ? () {} : null,
    );
  }

  Widget _buildSelectionGrid({
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: options
          .map(
            (value) => _ParameterOption(
              value: value,
              preview: _buildPreviewChip(value),
            ),
          )
          .map((option) => _buildOptionChip(
                option: option,
                isSelected: option.value == selectedValue,
                onSelected: onSelected,
              ))
          .toList(),
    );
  }

  Widget _buildOptionChip({
    required _ParameterOption option,
    required bool isSelected,
    required ValueChanged<String> onSelected,
  }) {
    return GestureDetector(
      onTap: () {
        onSelected(option.value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected
                ? AppColors.textLightBlue
                : Colors.white.withOpacity(0.1),
          ),
          color: isSelected
              ? const Color(0x33273B4F)
              : Colors.white.withOpacity(0.02),
        ),
        child: option.preview,
      ),
    );
  }

  Widget _buildPreviewChip(String value) {
    final String normalized = ParameterOptionSets.normalizeValue(value);
    if (normalized == 'order') {
      return ToolBarOrderChip(text: value);
    }
    if (normalized == 'orders') {
      return ToolBarOrdersChip(text: value);
    }
    if (normalized == 'total') {
      return ToolBarTotalChip(text: value);
    }
    if (RegExp(r'^\d+$').hasMatch(normalized)) {
      return ToolBarDigitChip(text: value);
    }
    return ToolBarOrderChip(text: value);
  }
}

class _ParameterOption {
  final String value;
  final Widget preview;

  const _ParameterOption({
    required this.value,
    required this.preview,
  });
}

