import 'package:json_annotation/json_annotation.dart';

class TimestampConverter
    implements JsonConverter<DateTime, Map<String, dynamic>> {
  const TimestampConverter();

  @override
  DateTime fromJson(Map<String, dynamic> json) {
    // Expects { "__tipo__": "timestamp", "valor": "2025-11-06T12:00:00Z" }
    if (json['__tipo__'] == 'timestamp' && json['valor'] is String) {
      return DateTime.parse(json['valor'] as String);
    }
    throw FormatException('Invalid timestamp format: $json');
  }

  @override
  Map<String, dynamic> toJson(DateTime object) {
    return {'__tipo__': 'timestamp', 'valor': object.toIso8601String()};
  }
}

class TimestampNullableConverter
    implements JsonConverter<DateTime?, Map<String, dynamic>?> {
  const TimestampNullableConverter();

  @override
  DateTime? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    if (json['__tipo__'] == 'timestamp' && json['valor'] is String) {
      return DateTime.parse(json['valor'] as String);
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(DateTime? object) {
    if (object == null) return null;
    return {'__tipo__': 'timestamp', 'valor': object.toIso8601String()};
  }
}
