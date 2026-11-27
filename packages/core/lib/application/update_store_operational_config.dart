import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'get_store_operational_config.dart';
import 'ports/dte_queue_repository.dart';
import 'ports/session_provider.dart';
import 'ports/store_config_event_repository.dart';
import 'ports/store_repository.dart';

class UpdateStoreOperationalConfigInput {
  const UpdateStoreOperationalConfigInput({
    required this.storeId,
    required this.patch,
  });

  final StoreId storeId;
  final StoreOperationalOverrides patch;
}

class UpdateStoreOperationalConfig {
  UpdateStoreOperationalConfig(
    this._stores,
    this._sessions,
    this._dteQueue,
    this._configEvents,
  );

  final StoreRepository _stores;
  final SessionProvider _sessions;
  final DteQueueRepository _dteQueue;
  final StoreConfigEventRepository _configEvents;

  Future<StoreOperationalConfigResult> call(
    UpdateStoreOperationalConfigInput input,
  ) async {
    final session = requireActiveSession(_sessions);
    AuthPolicy.require(session, Permission.gestionarConfigTienda);

    final store = await _stores.findById(input.storeId);
    if (store == null) {
      throw NotFoundFailure(
        'Tienda no encontrada',
        details: {'storeId': input.storeId},
      );
    }

    final current = store.operationalOverrides ?? StoreOperationalOverrides.empty;
    final merged = current.merge(input.patch);

    if (input.patch.dteEnabled == false) {
      final pending = await _dteQueue.listPending(input.storeId);
      if (pending.isNotEmpty) {
        throw const ValidationFailure(
          'No puede desactivar DTE con documentos pendientes en cola',
        );
      }
    }

    final updated = store.withOperationalOverrides(merged);
    await _stores.save(updated);

    final event = StoreConfigEvent(
      id: 'cfg_${DateTime.now().microsecondsSinceEpoch}',
      storeId: input.storeId,
      actorUserId: session.userId,
      occurredAt: DateTime.now().toUtc(),
      summary: 'Configuración operativa actualizada',
    );
    await _configEvents.append(event);

    return StoreOperationalConfigResult(
      templateId: updated.posTemplateId,
      overrides: merged,
      effectiveTemplate: StoreOperationalConfigResolver.effectiveTemplate(updated),
    );
  }
}