import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../di/pos_composition.dart';
import 'sale_screen.dart';

class ShiftOpenScreen extends StatefulWidget {
  const ShiftOpenScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<ShiftOpenScreen> createState() => _ShiftOpenScreenState();
}

class _ShiftOpenScreenState extends State<ShiftOpenScreen> {
  final _cashController = TextEditingController(text: '0');
  bool _loading = false;

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  Future<void> _openShift() async {
    final raw = _cashController.text.trim();
    final cash = int.tryParse(raw);
    if (cash == null || cash < 0) {
      _showError('Ingrese un monto inicial válido en pesos.');
      return;
    }
    setState(() => _loading = true);
    final result = await widget.composition.shiftService.openShift(
      widget.composition.requireStoreId,
      OpenShiftRequest(openingCashClp: cash),
    );
    if (!mounted) return;
    setState(() => _loading = false);
    switch (result) {
      case ApiSuccess<OpenShiftResponse>():
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => SaleScreen(composition: widget.composition),
          ),
        );
      case ApiFailure<OpenShiftResponse>(error: final e):
        _showError(e.message);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Abrir turno')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ingrese el efectivo inicial en caja antes de vender.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('shift_open_cash_field'),
              controller: _cashController,
              decoration: const InputDecoration(
                labelText: 'Efectivo inicial (CLP)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('shift_open_button'),
              onPressed: _loading ? null : _openShift,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Abrir turno'),
            ),
          ],
        ),
      ),
    );
  }
}