import 'package:flutter/material.dart';
import '../../../core/styles/styles.dart';

class StyledTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final void Function(String) onSubmitted;

  const StyledTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSubmitted,
  });

  @override
  State<StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<StyledTextField> {
  bool _hovering = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool active = _hovering || _focusNode.hasFocus;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: AppAnimation.duration,
        curve: Curves.easeInOut,
        height: 48,
        decoration: BoxDecoration(
          color: active ? AppColors.primaryLight : AppColors.background,
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
          border: Border.all(
            color: active ? AppColors.primary : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.large),
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onSubmitted: widget.onSubmitted,
          cursorColor: AppColors.primary,
          style: const TextStyle(fontSize: 16),
          textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              hintText: widget.hintText,
              filled: false,
            )
        ),
      ),
    );
  }
}
