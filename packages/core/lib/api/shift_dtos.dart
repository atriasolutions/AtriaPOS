class OpenShiftRequest {
  const OpenShiftRequest({required this.openingCashClp});

  final int openingCashClp;
}

class OpenShiftResponse {
  const OpenShiftResponse({
    required this.shiftId,
    required this.openingCashClp,
    required this.openedAt,
  });

  final String shiftId;
  final int openingCashClp;
  final String openedAt;
}

class OpenShiftStatusResponse {
  const OpenShiftStatusResponse({
    required this.shiftId,
    required this.openingCashClp,
    required this.openedAt,
  });

  final String shiftId;
  final int openingCashClp;
  final String openedAt;
}

class CloseShiftRequest {
  const CloseShiftRequest({required this.countedCashClp});

  final int countedCashClp;
}

class CloseShiftResponse {
  const CloseShiftResponse({
    required this.expectedCashClp,
    required this.countedCashClp,
    required this.differenceClp,
    required this.salesTotalClp,
    required this.openedAt,
    required this.closedAt,
  });

  final int expectedCashClp;
  final int countedCashClp;
  final int differenceClp;
  final int salesTotalClp;
  final String openedAt;
  final String closedAt;
}