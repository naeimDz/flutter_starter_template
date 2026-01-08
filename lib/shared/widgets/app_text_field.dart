import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_starter_template/core/constants/app_sizes.dart';

/// Reusable text input field with consistent styling.
///
/// Features:
/// - Label and hint text
/// - Prefix and suffix icons
/// - Validation support
/// - Password visibility toggle
/// - Character counter
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool showPasswordToggle;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool showCounter;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsets? contentPadding;
  final bool autofocus;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.showCounter = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.inputFormatters,
    this.contentPadding,
    this.autofocus = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSizes.spacing8),
        ],

        // Text Field
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          inputFormatters: widget.inputFormatters,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          buildCounter: widget.showCounter
              ? null
              : (context,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
          decoration: InputDecoration(
            hintText: widget.hint,
            helperText: widget.helperText,
            contentPadding: widget.contentPadding,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.showPasswordToggle && widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    return widget.suffixIcon;
  }
}

/// Email text field with email keyboard and validation hint.
class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const EmailTextField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: 'Email',
      hint: 'Enter your email',
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      prefixIcon: const Icon(Icons.email_outlined),
    );
  }
}

/// Password text field with visibility toggle.
class PasswordTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? label;
  final String? hint;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  const PasswordTextField({
    super.key,
    this.controller,
    this.validator,
    this.label,
    this.hint,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label ?? 'Password',
      hint: hint ?? 'Enter your password',
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      obscureText: true,
      showPasswordToggle: true,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      prefixIcon: const Icon(Icons.lock_outlined),
    );
  }
}
