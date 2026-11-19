import 'package:core/api/api.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';

class CertificateStatusScreen extends StatefulWidget {
  const CertificateStatusScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<CertificateStatusScreen> createState() =>
      _CertificateStatusScreenState();
}

class _CertificateStatusScreenState extends State<CertificateStatusScreen> {
  CertificateStatusResponse? _status;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await widget.composition.fiscalService.getCertificate(
      widget.composition.requireStoreId,
    );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<CertificateStatusResponse>(data: final data):
        setState(() {
          _status = data;
          _loading = false;
        });
      case ApiFailure<CertificateStatusResponse>(error: final e):
        setState(() {
          _error = e.message;
          _loading = false;
        });
    }
  }

  String _statusLabel(String status) => switch (status) {
        'VALIDO' => 'Válido',
        'VENCIDO' => 'Vencido',
        'NO_CONFIGURADO' => 'No configurado',
        _ => status,
      };

  Color _statusColor(BuildContext context, String status) => switch (status) {
        'VALIDO' => Colors.green.shade700,
        'VENCIDO' => Colors.red.shade700,
        _ => Colors.orange.shade800,
      };

  String _formatValidTo(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) return iso;
    final local = parsed.toLocal();
    final d = local.day.toString().padLeft(2, '0');
    final m = local.month.toString().padLeft(2, '0');
    final y = local.year;
    return '$d-$m-$y';
  }

  @override
  Widget build(BuildContext context) {
    final status = _status;
    return Scaffold(
      appBar: AppBar(title: const Text('Certificado SII')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (_loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(48),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_error != null)
              Center(child: Text(_error!))
            else if (status != null) ...[
              Text(
                key: const Key('certificate_status_badge'),
                _statusLabel(status.status),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: _statusColor(context, status.status),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              if (status.subject != null && status.subject!.isNotEmpty)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Titular'),
                  subtitle: Text(status.subject!),
                ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Vigente hasta'),
                subtitle: Text(
                  key: const Key('certificate_valid_to'),
                  _formatValidTo(status.validTo),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Para emitir con el SII, configure el certificado en el '
                'dispositivo (variable SII_CERT_PATH o runbook de piloto). '
                'No cargue archivos .pfx ni claves desde esta pantalla.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}