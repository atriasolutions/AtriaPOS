class DteQueueEntryResponse {
  const DteQueueEntryResponse({
    required this.saleId,
    required this.documentType,
    required this.documentId,
    required this.attempts,
    this.lastError,
    required this.createdAt,
  });

  final String saleId;
  final int documentType;
  final String documentId;
  final int attempts;
  final String? lastError;
  final String createdAt;
}

class DteQueueListResponse {
  const DteQueueListResponse({required this.items});

  final List<DteQueueEntryResponse> items;
}

class DteRetryResponse {
  const DteRetryResponse({
    required this.processed,
    required this.failed,
  });

  final int processed;
  final int failed;
}