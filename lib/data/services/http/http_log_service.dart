import '../api/log_service.dart';
import 'api_client.dart';

class HttpLogService implements LogService {
  HttpLogService({ApiClient? client}) : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  @override
  Future<void> logEvent(String eventName, [Map<String, dynamic>? parameters]) async {
    try {
      final uri = Uri.parse('${ApiClient.logServiceUrl}/api/v1/logs');
      await _client.post(uri, body: {
        'events': [
          {
            'type': 'event',
            'name': eventName,
            'parameters': parameters ?? {},
            'timestamp': DateTime.now().toUtc().toIso8601String(),
          }
        ]
      });
    } catch (_) {}
  }

  @override
  Future<void> logMetric(String metricName, double value, [Map<String, dynamic>? tags]) async {
    try {
      final uri = Uri.parse('${ApiClient.logServiceUrl}/api/v1/logs');
      await _client.post(uri, body: {
        'events': [
          {
            'type': 'metric',
            'name': metricName,
            'value': value,
            'parameters': tags ?? {},
            'timestamp': DateTime.now().toUtc().toIso8601String(),
          }
        ]
      });
    } catch (_) {}
  }
}
