import 'package:flutter/material.dart';

import 'app_palette.dart';

class CustomButton2 extends StatelessWidget {
  final String label;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final double? height;
  final double? width;
  final EdgeInsets padding;
  final double borderRadius;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final double? borderWidth;
  final Widget? customWidget; // prefer for icons
  final Widget? prefixIcon; // prefer for icons

  const CustomButton2({
    super.key,
    required this.label,
    this.textStyle,
    this.backgroundColor = JasaraPalette.primary,
    this.height,
    this.width,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius = 8.0,
    this.onPressed,
    this.customWidget,
    this.borderColor,
    this.borderWidth,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          height: height,
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? Colors.grey.shade300,
              width: borderWidth ?? 1.0,
            ),
          ),
          child: Center(
            child:
                customWidget ??
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (prefixIcon != null) prefixIcon!,
                    Flexible(
                      child: Text(
                        label,
                        style:
                            textStyle ??
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
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
