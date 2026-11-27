import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:flutter/material.dart';

import 'di/pos_composition.dart';
import 'screens/login_screen.dart';
import 'screens/sale_screen.dart';
import 'screens/shift_open_screen.dart';
import 'screens/store_setup_screen.dart';
import 'widgets/pos_status_strip.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.composition,
    this.showStatusStrip = true,
  });

  final PosComposition composition;
  final bool showStatusStrip;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _checking = true;
  Widget? _home;

  @override
  void initState() {
    super.initState();
    widget.composition.onSessionExpired = _goLogin;
    _resolveStart();
  }

  @override
  void dispose() {
    widget.composition.onSessionExpired = null;
    super.dispose();
  }

  void _goLogin() {
    if (!mounted) return;
    setState(() {
      _home = LoginScreen(
        composition: widget.composition,
        onLoggedIn: _resolveStart,
      );
      _checking = false;
    });
  }

  bool _hasSession() {
    final session = widget.composition.sessionProvider.current;
    return session != null && session.isActive;
  }

  Future<void> _resolveStart() async {
    setState(() => _checking = true);
    await widget.composition.refreshActiveStore();

    if (widget.composition.activeStoreId == null) {
      if (!mounted) return;
      setState(() {
        _home = StoreSetupScreen(
          composition: widget.composition,
          onCompleted: _resolveStart,
        );
        _checking = false;
      });
      return;
    }

    if (!_hasSession()) {
      _goLogin();
      return;
    }

    final storeId = widget.composition.requireStoreId;
    final result = await widget.composition.shiftService.getOpenShift(storeId);
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
    return _wrapWithStatusStrip(_home!);
  }

  Widget _wrapWithStatusStrip(Widget home) {
    if (!widget.showStatusStrip) {
      return home;
    }
    if (home is SaleScreen) {
      return home;
    }
    return PosStatusStrip(
      clock: widget.composition.trustedClock,
      child: home,
    );
  }
}