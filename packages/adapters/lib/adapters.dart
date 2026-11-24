library;

import 'package:core/atria_pos_core.dart';

export 'pos_database.dart';
export 'dte_gateway_factory.dart';
export 'drift_dte_queue_repository.dart';
export 'file_certificate_store.dart';
export 'sii_boleta_builder.dart';
export 'sii_cert_replay_dte_gateway.dart';
export 'sii_live_dte_gateway.dart';
export 'sii_transport.dart';
export 'fake_sii_transport.dart';
export 'http_sii_transport.dart';
export 'folio_allocator.dart';
export 'in_memory_folio_allocator.dart';
export 'drift_folio_allocator.dart';
export 'caf_file.dart';
export 'sii_emisor_config.dart';
export 'sii_dte_xml_builder.dart';
export 'drift_user_repository.dart';
export 'drift_store_repository.dart';
export 'drift_product_repository.dart';
export 'drift_sale_repository.dart';
export 'drift_shift_repository.dart';
export 'drift_stock_movement_repository.dart';
export 'drift_clock_state_repository.dart';
export 'ntp_shoa_clock.dart';
export 'src/database.dart';

/// Placeholder SLICE-0: valida enlace con [core].
String adaptersBuildLabel() => '$kAppName-adapters';