import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../di/pos_composition.dart';

class UserEditScreen extends StatefulWidget {
  const UserEditScreen({
    super.key,
    required this.composition,
    required this.user,
  });

  final PosComposition composition;
  final UserProfileResponse user;

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _rutController;
  late final TextEditingController _pinController;
  late UserRole _role;
  bool _submitting = false;

  bool get _isDueno => widget.user.role == UserRole.dueno.apiValue;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _rutController = TextEditingController(text: widget.user.rut);
    _pinController = TextEditingController();
    _role = UserRole.fromApi(widget.user.role);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _rutController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final pin = _pinController.text.trim();
    if (pin.isNotEmpty && pin.length < 4) {
      _snack('El PIN debe tener al menos 4 dígitos.');
      return;
    }

    setState(() => _submitting = true);
    final result = await widget.composition.authService.updateUser(
      widget.composition.requireStoreId,
      widget.user.id,
      UpdateUserRequest(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        rut: _rutController.text.trim(),
        role: _role.apiValue,
        newPin: pin.isEmpty ? null : pin,
      ),
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    switch (result) {
      case ApiSuccess<UserProfileResponse>(data: final data):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: const Key('user_edit_success_snackbar'),
            content: Text('Usuario actualizado: ${data.displayName}'),
          ),
        );
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true);
        }
      case ApiFailure<UserProfileResponse>(error: final e):
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
      appBar: AppBar(title: const Text('Editar usuario')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('user_edit_username_field'),
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Usuario',
                border: const OutlineInputBorder(),
                hintText: widget.user.username,
              ),
              controller: TextEditingController(text: widget.user.username),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('user_edit_first_name_field'),
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('user_edit_last_name_field'),
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Apellido',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('user_edit_rut_field'),
              controller: _rutController,
              decoration: const InputDecoration(
                labelText: 'RUT',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (_isDueno)
              TextField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: 'Dueño'),
              )
            else
              DropdownButtonFormField<UserRole>(
                key: const Key('user_edit_role_field'),
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
              key: const Key('user_edit_pin_field'),
              controller: _pinController,
              decoration: const InputDecoration(
                labelText: 'PIN nuevo (opcional)',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('user_edit_submit_button'),
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}