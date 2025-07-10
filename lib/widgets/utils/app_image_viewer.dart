import 'package:flutter/material.dart';

class AppImageViewer extends StatelessWidget {
  final String imagePath;
  final EdgeInsets padding;
  final double borderRadius;
  final AlignmentGeometry alignment;
  final double imageWidth;
  final double imageHeight;
  final BoxFit fit;

  const AppImageViewer({
    super.key,
    required this.imagePath,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius = 16.0,
    this.alignment = const AlignmentDirectional(0.0, -1.0),
    this.imageWidth = 137.0,
    this.imageHeight = 31.0,
    this.fit = BoxFit.fill,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        alignment: alignment,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius / 2),
          child: Image.asset(
            imagePath,
            width: imageWidth,
            height: imageHeight,
            fit: fit,
          ),
        ),
      ),
    );
  }
}
