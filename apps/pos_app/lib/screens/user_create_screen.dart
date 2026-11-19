import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../di/pos_composition.dart';

class UserCreateScreen extends StatefulWidget {
  const UserCreateScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<UserCreateScreen> createState() => _UserCreateScreenState();
}

class _UserCreateScreenState extends State<UserCreateScreen> {
  final _userIdController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _pinController = TextEditingController();
  UserRole _role = UserRole.cajero;
  bool _submitting = false;

  @override
  void dispose() {
    _userIdController.dispose();
    _displayNameController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final userId = _userIdController.text.trim();
    final displayName = _displayNameController.text.trim();
    final pin = _pinController.text.trim();

    if (userId.isEmpty) {
      _snack('Ingrese un identificador de usuario.');
      return;
    }
    if (displayName.isEmpty) {
      _snack('Ingrese el nombre visible.');
      return;
    }
    if (pin.length < 4) {
      _snack('El PIN debe tener al menos 4 dígitos.');
      return;
    }

    setState(() => _submitting = true);
    final result = await widget.composition.authService.createUser(
      widget.composition.requireStoreId,
      CreateUserRequest(
        userId: userId,
        displayName: displayName,
        role: _role.apiValue,
        pin: pin,
      ),
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    switch (result) {
      case ApiSuccess<CreateUserResponse>(data: final data):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: const Key('user_create_success_snackbar'),
            content: Text('Usuario creado: ${data.displayName} (${data.role}).'),
          ),
        );
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true);
        }
      case ApiFailure<CreateUserResponse>(error: final e):
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
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo usuario')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('user_create_id_field'),
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: 'Identificador (ej. usr_cajero2)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('user_create_name_field'),
              controller: _displayNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre visible',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<UserRole>(
              key: const Key('user_create_role_field'),
              initialValue: _role,
              decoration: const InputDecoration(
                labelText: 'Rol',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: UserRole.cajero,
                  child: Text('Cajero'),
                ),
                DropdownMenuItem(
                  value: UserRole.supervisor,
                  child: Text('Supervisor'),
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _role = value);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('user_create_pin_field'),
              controller: _pinController,
              decoration: const InputDecoration(
                labelText: 'PIN (mín. 4 dígitos)',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('user_create_submit_button'),
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Crear usuario'),
            ),
          ],
        ),
      ),
    );
  }
}