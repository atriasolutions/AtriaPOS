class ApiErrorBody {
  const ApiErrorBody({
    required this.code,
    required this.message,
    this.details,
  });

  final String code;
  final String message;
  final Map<String, Object?>? details;

  Map<String, Object?> toJson() => {
        'error': {
          'code': code,
          'message': message,
          if (details != null) 'details': details,
        },
      };
}