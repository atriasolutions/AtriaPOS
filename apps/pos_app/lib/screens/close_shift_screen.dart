import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../di/pos_composition.dart';
import 'shift_open_screen.dart';

class CloseShiftScreen extends StatefulWidget {
  const CloseShiftScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<CloseShiftScreen> createState() => _CloseShiftScreenState();
}

class _CloseShiftScreenState extends State<CloseShiftScreen> {
  final _countedController = TextEditingController();
  OpenShiftStatusResponse? _openShift;
  bool _loadingShift = true;
  bool _closing = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadOpenShift();
  }

  @override
  void dispose() {
    _countedController.dispose();
    super.dispose();
  }

  Future<void> _loadOpenShift() async {
    final result =
        await widget.composition.shiftService.getOpenShift(widget.composition.requireStoreId);
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<OpenShiftStatusResponse>(data: final data):
        setState(() {
          _openShift = data;
          _loadingShift = false;
        });
      case ApiFailure<OpenShiftStatusResponse>(error: final e):
        setState(() {
          _loadError = e.message;
          _loadingShift = false;
        });
    }
  }

  Future<void> _closeShift() async {
    final shift = _openShift;
    if (shift == null) return;
    final raw = _countedController.text.trim();
    final counted = int.tryParse(raw);
    if (counted == null || counted < 0) {
      _snack('Ingrese el efectivo contado en pesos.');
      return;
    }
    setState(() => _closing = true);
    final result = await widget.composition.shiftService.closeShift(
      widget.composition.requireStoreId,
      shift.shiftId,
      CloseShiftRequest(countedCashClp: counted),
    );
    if (!mounted) return;
    setState(() => _closing = false);
    switch (result) {
      case ApiSuccess<CloseShiftResponse>(data: final report):
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            key: const Key('close_shift_report_dialog'),
            title: const Text('Cierre de caja'),
            content: Text(
              'Efectivo esperado: \$${report.expectedCashClp}\n'
              'Efectivo contado: \$${report.countedCashClp}\n'
              'Diferencia: \$${report.differenceClp}\n'
              'Total ventas: \$${report.salesTotalClp}',
            ),
            actions: [
              TextButton(
                key: const Key('close_shift_report_ok'),
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Listo'),
              ),
            ],
          ),
        );
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => ShiftOpenScreen(composition: widget.composition),
          ),
          (_) => false,
        );
      case ApiFailure<CloseShiftResponse>(error: final e):
        _snack(e.message);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingShift) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cerrar caja')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_loadError != null || _openShift == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cerrar caja')),
        body: Center(child: Text(_loadError ?? 'Sin turno abierto.')),
      );
    }
    final shift = _openShift!;
    return Scaffold(
      appBar: AppBar(title: const Text('Cerrar caja')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Turno: ${shift.shiftId}'),
            Text('Apertura: \$${shift.openingCashClp}'),
            const SizedBox(height: 16),
            TextField(
              key: const Key('close_shift_counted_field'),
              controller: _countedController,
              decoration: const InputDecoration(
                labelText: 'Efectivo contado (CLP)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('close_shift_confirm_button'),
              onPressed: _closing ? null : _closeShift,
              child: _closing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Confirmar cierre'),
            ),
          ],
        ),
      ),
    );
  }
}