class AuditTrailItemResponse {
  const AuditTrailItemResponse({
    required this.occurredAt,
    required this.category,
    required this.type,
    required this.summary,
    required this.refId,
    this.actorUserId,
  });

  final String occurredAt;
  final String category;
  final String type;
  final String? actorUserId;
  final String summary;
  final String refId;
}

class AuditTrailResponse {
  const AuditTrailResponse({
    required this.fromDate,
    required this.toDate,
    required this.items,
    this.date,
  });

  /// Legacy RF-070: fecha cuando el rango es un solo día.
  final String? date;
  final String fromDate;
  final String toDate;
  final List<AuditTrailItemResponse> items;
}

class DailySalesReportResponse {
  const DailySalesReportResponse({
    required this.date,
    required this.salesTotalClp,
    required this.transactionCount,
    required this.averageTicketClp,
  });

  final String date;
  final int salesTotalClp;
  final int transactionCount;
  final int averageTicketClp;
}