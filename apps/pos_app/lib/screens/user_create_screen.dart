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
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _rutController = TextEditingController();
  final _pinController = TextEditingController();
  UserRole _role = UserRole.cajero;
  bool _submitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _rutController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final username = _usernameController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final rut = _rutController.text.trim();
    final pin = _pinController.text.trim();

    if (username.isEmpty) {
      _snack('Ingrese un nombre de usuario.');
      return;
    }
    if (firstName.isEmpty || lastName.isEmpty) {
      _snack('Ingrese nombre y apellido.');
      return;
    }
    if (rut.isEmpty) {
      _snack('Ingrese el RUT.');
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
        username: username,
        firstName: firstName,
        lastName: lastName,
        rut: rut,
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
              key: const Key('user_create_username_field'),
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Usuario (sin ñ)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('user_create_first_name_field'),
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('user_create_last_name_field'),
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Apellido',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('user_create_rut_field'),
              controller: _rutController,
              decoration: const InputDecoration(
                labelText: 'RUT',
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