class ScoreCaptureResult {
  const ScoreCaptureResult({
    required this.value,
    this.details = const {},
  });

  final double value;
  final Map<String, dynamic> details;
}
