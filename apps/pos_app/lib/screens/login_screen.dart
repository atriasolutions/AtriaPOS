import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../di/pos_composition.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.composition, required this.onLoggedIn});

  final PosComposition composition;
  final VoidCallback onLoggedIn;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userIdController = TextEditingController(text: 'usr_cajero');
  final _pinController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _userIdController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    final result = await widget.composition.authService.login(
      widget.composition.requireStoreId,
      LoginRequest(
        username: _userIdController.text.trim(),
        pin: _pinController.text.trim(),
      ),
    );
    if (!mounted) return;
    setState(() => _loading = false);
    switch (result) {
      case ApiSuccess<LoginResponse>():
        widget.onLoggedIn();
      case ApiFailure<LoginResponse>(error: final e):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            TextField(
              key: const Key('login_user_id_field'),
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('login_pin_field'),
              controller: _pinController,
              decoration: const InputDecoration(
                labelText: 'PIN',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('login_button'),
              onPressed: _loading ? null : _login,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Entrar'),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}