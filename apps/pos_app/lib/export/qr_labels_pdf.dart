import 'dart:typed_data';

import 'package:core/api/api.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// DEC-051: A4, grilla 3×5.
const _cols = 3;
const _rows = 5;
const _labelsPerPage = _cols * _rows;

Future<Uint8List> buildQrLabelsPdfBytes(List<ProductResponse> products) async {
  final pdf = pw.Document();
  var pagesAdded = 0;
  for (var i = 0; i < products.length; i += _labelsPerPage) {
    final chunk = products.sublist(
      i,
      i + _labelsPerPage > products.length ? products.length : i + _labelsPerPage,
    );
    final tiles = <pw.Widget>[];
    for (final product in chunk) {
      final payload = product.qrPayload;
      if (payload == null || payload.isEmpty) continue;
      final name = product.name.length > 28
          ? '${product.name.substring(0, 25)}...'
          : product.name;
      tiles.add(
        pw.Container(
          padding: const pw.EdgeInsets.all(6),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 0.5),
          ),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(name, style: pw.TextStyle(fontSize: 9)),
              pw.SizedBox(height: 4),
              pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: payload,
                width: 72,
                height: 72,
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                _shortPayload(payload),
                style: const pw.TextStyle(fontSize: 6),
              ),
            ],
          ),
        ),
      );
    }
    if (tiles.isEmpty) continue;
    while (tiles.length < _labelsPerPage) {
      tiles.add(pw.SizedBox());
    }
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (ctx) => pw.GridView(
          crossAxisCount: _cols,
          childAspectRatio: 1.15,
          children: tiles,
        ),
      ),
    );
    pagesAdded++;
  }

  if (pagesAdded == 0) {
    pdf.addPage(
      pw.Page(
        build: (ctx) => pw.Center(child: pw.Text('Sin etiquetas QR')),
      ),
    );
  }
  return pdf.save();
}

Future<void> exportQrLabelsPdf(
  BuildContext context,
  List<ProductResponse> products,
) async {
  final bytes = await buildQrLabelsPdfBytes(products);
  if (!context.mounted) return;
  final location = await getSaveLocation(
    suggestedName: 'etiquetas_qr.pdf',
    acceptedTypeGroups: const [
      XTypeGroup(
        label: 'PDF',
        extensions: ['pdf'],
        mimeTypes: ['application/pdf'],
      ),
    ],
  );
  if (location == null) return;
  final xFile = XFile.fromData(bytes, mimeType: 'application/pdf', name: 'etiquetas_qr.pdf');
  await xFile.saveTo(location.path);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF guardado.')),
    );
  }
}

String _shortPayload(String payload) {
  if (payload.length <= 24) return payload;
  return '${payload.substring(0, 21)}...';
}