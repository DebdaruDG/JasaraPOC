import 'dart:html' as html;

import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';

import 'dart:ui' as ui; // only available on web

class PDFViewerWeb extends StatelessWidget {
  final String base64PDF;

  const PDFViewerWeb({super.key, required this.base64PDF});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return const Center(child: Text("PDF preview only supported on web."));
    }

    final String viewId = 'pdf-viewer-${DateTime.now().millisecondsSinceEpoch}';

    // ✅ Only register view if running on web
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewId, (int _) {
      final element =
          html.IFrameElement()
            ..src = 'data:application/pdf;base64,$base64PDF'
            ..style.border = 'none'
            ..width = '100%'
            ..height = '100%';
      return element;
    });

    return HtmlElementView(viewType: viewId);
  }
}
