/// Fallos de dominio / aplicación mapeables a API (DEC-006).
sealed class PosFailure implements Exception {
  const PosFailure(this.message);

  final String message;

  String get code;
}

class ValidationFailure extends PosFailure {
  const ValidationFailure(super.message);

  @override
  String get code => 'VALIDACION';
}

class ConflictFailure extends PosFailure {
  const ConflictFailure(super.message, {this.details});

  final Map<String, Object?>? details;

  @override
  String get code => 'CONFLICTO';
}

class NotFoundFailure extends PosFailure {
  const NotFoundFailure(super.message, {this.details});

  final Map<String, Object?>? details;

  @override
  String get code => 'NO_ENCONTRADO';
}

class InsufficientStockFailure extends PosFailure {
  const InsufficientStockFailure(super.message, {this.details});

  final Map<String, Object?>? details;

  @override
  String get code => 'STOCK_INSUFICIENTE';
}

class TurnClosedFailure extends PosFailure {
  const TurnClosedFailure(super.message);

  @override
  String get code => 'TURNO_CERRADO';
}

class CredentialFailure extends PosFailure {
  const CredentialFailure(super.message);

  @override
  String get code => 'CREDENCIAL_INVALIDA';
}

class ForbiddenFailure extends PosFailure {
  const ForbiddenFailure(super.message);

  @override
  String get code => 'PERMISO_DENEGADO';
}

class SessionExpiredFailure extends PosFailure {
  const SessionExpiredFailure(super.message);

  @override
  String get code => 'SESION_EXPIRADA';
}

class CertificateNotConfiguredFailure extends PosFailure {
  const CertificateNotConfiguredFailure(super.message);

  @override
  String get code => 'CERT_NO_CONFIGURADO';
}

class CertificateExpiredFailure extends PosFailure {
  const CertificateExpiredFailure(super.message);

  @override
  String get code => 'CERT_VENCIDO';
}