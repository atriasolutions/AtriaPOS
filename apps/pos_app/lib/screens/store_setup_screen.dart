import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../di/pos_composition.dart';
import '../widgets/atria_text_formatters.dart';

class StoreSetupScreen extends StatefulWidget {
  const StoreSetupScreen({
    super.key,
    required this.composition,
    required this.onCompleted,
  });

  final PosComposition composition;
  final VoidCallback onCompleted;

  @override
  State<StoreSetupScreen> createState() => _StoreSetupScreenState();
}

class _StoreSetupScreenState extends State<StoreSetupScreen> {
  final _rutController = TextEditingController();
  final _legalNameController = TextEditingController();
  final _businessLineController = TextEditingController();
  final _ownerFirstNameController = TextEditingController();
  final _ownerLastNameController = TextEditingController();
  final _ownerUsernameController = TextEditingController();
  final _ownerRutController = TextEditingController();
  final _pinController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _rutController.dispose();
    _legalNameController.dispose();
    _businessLineController.dispose();
    _ownerFirstNameController.dispose();
    _ownerLastNameController.dispose();
    _ownerUsernameController.dispose();
    _ownerRutController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    final result = await widget.composition.storeService.bootstrap(
      BootstrapStoreRequest(
        rut: _rutController.text.trim(),
        legalName: _legalNameController.text.trim(),
        businessLine: _businessLineController.text.trim(),
        ownerFirstName: _ownerFirstNameController.text.trim(),
        ownerLastName: _ownerLastNameController.text.trim(),
        ownerUsername: _ownerUsernameController.text.trim(),
        ownerRut: _ownerRutController.text.trim(),
        ownerPin: _pinController.text.trim(),
      ),
    );
    if (!mounted) return;
    setState(() => _loading = false);
    switch (result) {
      case ApiSuccess<BootstrapStoreResponse>(data: final data):
        await widget.composition.refreshActiveStore();
        widget.composition.sessionProvider.current;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: const Key('store_setup_success_snackbar'),
            content: Text('Tienda creada. Bienvenido, ${data.role}.'),
          ),
        );
        widget.onCompleted();
      case ApiFailure<BootstrapStoreResponse>(error: final e):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar tienda')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            const Text(
              'Registre su negocio para comenzar a vender.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('store_setup_rut_field'),
              controller: _rutController,
              decoration: const InputDecoration(
                labelText: 'RUT empresa (sin puntos)',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [RutChileEntryFormatter()],
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('store_setup_legal_name_field'),
              controller: _legalNameController,
              decoration: const InputDecoration(
                labelText: 'Razón social',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('store_setup_giro_field'),
              controller: _businessLineController,
              decoration: const InputDecoration(
                labelText: 'Giro',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Dueño de la tienda'),
            const SizedBox(height: 8),
            TextField(
              key: const Key('store_setup_owner_first_name_field'),
              controller: _ownerFirstNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('store_setup_owner_last_name_field'),
              controller: _ownerLastNameController,
              decoration: const InputDecoration(
                labelText: 'Apellido',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('store_setup_owner_username_field'),
              controller: _ownerUsernameController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [LatinNWithoutEnyeFormatter()],
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('store_setup_owner_rut_field'),
              controller: _ownerRutController,
              decoration: const InputDecoration(
                labelText: 'RUT dueño (sin puntos)',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [RutChileEntryFormatter()],
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('store_setup_pin_field'),
              controller: _pinController,
              decoration: const InputDecoration(
                labelText: 'PIN (mínimo 4 dígitos)',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('store_setup_submit_button'),
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar y continuar'),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}