import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hint;
  final String? label;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;
  final bool readOnly;
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final VoidCallback? onSuffixPressed;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    this.controller,
    required this.hint,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
    this.onSuffixPressed,
    this.onChanged,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool obscure;

  @override
  void initState() {
    super.initState();
    obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      maxLines: obscure ? 1 : widget.maxLines,
      obscureText: obscure,
      style: AppTextStyles.body.copyWith(
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,

        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon)
            : null,

        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
              )
            : widget.suffixIcon != null
                ? IconButton(
                    icon: Icon(widget.suffixIcon),
                    onPressed: widget.onSuffixPressed,
                  )
                : null,

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
      ),
    );
  }
}