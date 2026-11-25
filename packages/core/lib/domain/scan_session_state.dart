enum ScanSessionState {
  draft('draft'),
  confirmed('confirmed'),
  cancelled('cancelled');

  const ScanSessionState(this.apiValue);

  final String apiValue;
}