abstract class LogService {
  Future<void> logEvent(String eventName, [Map<String, dynamic>? parameters]);
  Future<void> logMetric(String metricName, double value, [Map<String, dynamic>? tags]);
}
