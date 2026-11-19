class AuditTrailItemResponse {
  const AuditTrailItemResponse({
    required this.occurredAt,
    required this.type,
    required this.summary,
    required this.refId,
    this.actorUserId,
  });

  final String occurredAt;
  final String type;
  final String? actorUserId;
  final String summary;
  final String refId;
}

class AuditTrailResponse {
  const AuditTrailResponse({
    required this.date,
    required this.items,
  });

  final String date;
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