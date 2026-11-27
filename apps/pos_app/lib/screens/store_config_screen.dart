import 'dart:async';

import 'package:core/api/api.dart';
import 'package:flutter/material.dart';

import '../config/store_config_sections.dart';
import '../di/pos_composition.dart';
import '../theme/atria_touch_targets.dart';
import '../widgets/section_header.dart';

class StoreConfigScreen extends StatefulWidget {
  const StoreConfigScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<StoreConfigScreen> createState() => _StoreConfigScreenState();
}

class _StoreConfigScreenState extends State<StoreConfigScreen> {
  StoreOperationalConfigResponse? _config;
  String? _error;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await widget.composition.storeService.getStoreOperationalConfig(
      widget.composition.requireStoreId,
    );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<StoreOperationalConfigResponse>(data: final data):
        setState(() {
          _config = data;
          _loading = false;
        });
      case ApiFailure<StoreOperationalConfigResponse>(error: final e):
        setState(() {
          _error = e.message;
          _loading = false;
        });
    }
  }

  Future<void> _patch(PatchStoreOperationalConfigRequest patch) async {
    setState(() => _saving = true);
    final result = await widget.composition.storeService.patchStoreOperationalConfig(
      widget.composition.requireStoreId,
      patch,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    switch (result) {
      case ApiSuccess<StoreOperationalConfigResponse>(data: final data):
        setState(() => _config = data);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Configuración guardada')),
        );
      case ApiFailure<StoreOperationalConfigResponse>(error: final e):
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
    }
  }

  bool _flag(String feature) =>
      _config?.effectiveFeatures.contains(feature) ?? false;

  Widget _toggle({
    required StoreConfigToggleDef def,
    required bool value,
    required bool? customized,
    required Future<void> Function(bool) onChanged,
  }) {
    final subtitle = customized != null
        ? '${def.subtitle}\nPersonalizado respecto a plantilla.'
        : def.subtitle;

    return SizedBox(
      height: kMinTouchHeight * (customized != null ? 2.4 : 2.2),
      child: SwitchListTile(
        key: def.key,
        title: Text(def.title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: _saving
            ? null
            : (next) async {
                await onChanged(next);
              },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sections = groupStoreConfigToggles();
    final overrides = _config?.overrides;
    final templateLabel = templateDisplayName(_config?.templateId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de tienda'),
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        templateLabel.isEmpty
                            ? 'Plantilla base: ${_config?.templateId ?? ''}'
                            : 'Plantilla base: $templateLabel',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      for (final entry in sections.entries) ...[
                        AtriaSectionHeader.forStoreSection(
                          section: entry.key,
                          key: Key('store_config_section_${entry.key.name}'),
                        ),
                        ...entry.value.map((def) {
                          return _toggle(
                            def: def,
                            value: _flag(def.feature),
                            customized: def.overrideValue(overrides),
                            onChanged: (next) => _patch(def.patch(next)),
                          );
                        }),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
    );
  }
}