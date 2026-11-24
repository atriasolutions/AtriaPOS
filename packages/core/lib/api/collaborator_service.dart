import '../application/application.dart';
import '../domain/domain.dart';
import 'api_error.dart';
import 'api_result.dart';
import 'collaborator_dtos.dart';
import 'sale_dtos.dart';

class CollaboratorService {
  factory CollaboratorService({
    CollaboratorRepository? repository,
    SessionProvider? sessionProvider,
  }) {
    final repo = repository ?? InMemoryCollaboratorRepository();
    final sessions = sessionProvider ?? InMemorySessionProvider.dueno();
    return CollaboratorService._(
      repo,
      sessions,
      CreateCollaborator(repo, sessions),
      UpdateCollaborator(repo, sessions),
      DeactivateCollaborator(repo, sessions),
      ListCollaborators(repo, sessions),
      ListActiveCollaborators(repo, sessions),
    );
  }

  CollaboratorService._(
    this._repo,
    this._sessions,
    this._create,
    this._update,
    this._deactivate,
    this._list,
    this._listActive,
  );

  final CollaboratorRepository _repo;
  final SessionProvider _sessions;
  final CreateCollaborator _create;
  final UpdateCollaborator _update;
  final DeactivateCollaborator _deactivate;
  final ListCollaborators _list;
  final ListActiveCollaborators _listActive;

  Future<ApiResult<ListActiveCollaboratorsResponse>> listActiveForSale(
    StoreId storeId,
  ) async {
    try {
      final items = await _listActive(storeId);
      return ApiSuccess(
        ListActiveCollaboratorsResponse(
          items: items
              .map(
                (c) => ActiveCollaboratorResponse(
                  id: c.id,
                  sellerCode: c.sellerCode,
                  firstName: c.firstName,
                  lastName: c.lastName,
                ),
              )
              .toList(),
        ),
        statusCode: 200,
      );
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    }
  }

  Future<ApiResult<CollaboratorResponse>> create(
    StoreId storeId,
    CreateCollaboratorRequest request,
  ) async {
    try {
      final c = await _create(
        CreateCollaboratorInput(
          storeId: storeId,
          sellerCode: request.sellerCode,
          firstName: request.firstName,
          lastName: request.lastName,
        ),
      );
      return ApiSuccess(_toResponse(c), statusCode: 201);
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    } on ConflictFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 409,
      );
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    }
  }

  Future<ApiResult<ListCollaboratorsResponse>> list(StoreId storeId) async {
    try {
      final items = await _list(storeId);
      return ApiSuccess(
        ListCollaboratorsResponse(
          items: items.map(_toResponse).toList(),
        ),
        statusCode: 200,
      );
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    }
  }

  Future<ApiResult<CollaboratorResponse>> update(
    StoreId storeId,
    CollaboratorId id,
    UpdateCollaboratorRequest request,
  ) async {
    try {
      final c = await _update(
        UpdateCollaboratorInput(
          storeId: storeId,
          collaboratorId: id,
          sellerCode: request.sellerCode,
          firstName: request.firstName,
          lastName: request.lastName,
          active: request.active,
        ),
      );
      return ApiSuccess(_toResponse(c), statusCode: 200);
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 404,
      );
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    } on ConflictFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 409,
      );
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    }
  }

  Future<ApiResult<CollaboratorResponse>> deactivate(
    StoreId storeId,
    CollaboratorId id,
  ) async {
    try {
      final c = await _deactivate(storeId, id);
      return ApiSuccess(_toResponse(c), statusCode: 200);
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 404,
      );
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    }
  }

  CollaboratorResponse _toResponse(Collaborator c) => CollaboratorResponse(
        id: c.id,
        sellerCode: c.sellerCode,
        firstName: c.firstName,
        lastName: c.lastName,
        active: c.active,
      );

  /// Expuesto para tests con repositorio compartido.
  CollaboratorRepository get repository => _repo;
  SessionProvider get sessionProvider => _sessions;
}