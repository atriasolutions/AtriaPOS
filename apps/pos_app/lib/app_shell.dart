import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:flutter/material.dart';

import 'config/store_config.dart';
import 'di/pos_composition.dart';
import 'screens/login_screen.dart';
import 'screens/sale_screen.dart';
import 'screens/shift_open_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _checking = true;
  Widget? _home;

  @override
  void initState() {
    super.initState();
    _resolveStart();
  }

  bool _hasSession() {
    final session = widget.composition.sessionProvider.current;
    return session != null && session.isActive;
  }

  Future<void> _resolveStart() async {
    if (!_hasSession()) {
      if (!mounted) return;
      setState(() {
        _home = LoginScreen(
          composition: widget.composition,
          onLoggedIn: _resolveStart,
        );
        _checking = false;
      });
      return;
    }

    setState(() => _checking = true);
    final result =
        await widget.composition.shiftService.getOpenShift(kDemoStoreId);
    Widget home;
    switch (result) {
      case ApiSuccess<OpenShiftStatusResponse>():
        home = SaleScreen(composition: widget.composition);
      case ApiFailure<OpenShiftStatusResponse>():
        home = ShiftOpenScreen(composition: widget.composition);
    }
    if (!mounted) return;
    setState(() {
      _home = home;
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return _home!;
  }
}