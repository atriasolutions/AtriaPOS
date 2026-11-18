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