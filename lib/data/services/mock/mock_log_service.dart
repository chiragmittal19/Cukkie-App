import 'package:flutter/foundation.dart';
import '../api/log_service.dart';

class MockLogService implements LogService {
  final List<Map<String, dynamic>> _eventsLog = [];
  final List<Map<String, dynamic>> _metricsLog = [];

  List<Map<String, dynamic>> get eventsLog => List.unmodifiable(_eventsLog);
  List<Map<String, dynamic>> get metricsLog => List.unmodifiable(_metricsLog);

  @override
  Future<void> logEvent(String eventName, [Map<String, dynamic>? parameters]) async {
    final entry = {
      'event': eventName,
      'timestamp': DateTime.now().toIso8601String(),
      'parameters': parameters ?? {},
    };
    _eventsLog.add(entry);
    debugPrint('📊 [EVENT] $eventName: $parameters');
  }

  @override
  Future<void> logMetric(String metricName, double value, [Map<String, dynamic>? tags]) async {
    final entry = {
      'metric': metricName,
      'value': value,
      'timestamp': DateTime.now().toIso8601String(),
      'tags': tags ?? {},
    };
    _metricsLog.add(entry);
    debugPrint('📈 [METRIC] $metricName = $value ($tags)');
  }
}
