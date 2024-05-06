
import 'notePaper.dart';

class APIResponse<T> {
  final String message;
  final List<T> payload;
  final String status;
  final DateTime creationDate;

  APIResponse({
    required this.message,
    required this.payload,
    required this.status,
    required this.creationDate,
  });

  factory APIResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return APIResponse(
      message: json['message'],
      payload: List<T>.from(json['payload'].map((x) => fromJsonT(x))),
      status: json['status'],
      creationDate: DateTime.tryParse(json['creationDate']) ?? DateTime.now(),
    );
  }
}

class Payload {
  final List<Notepaper> notes;

  Payload({
    required this.notes,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      // Here, you parse the 'notes' field from the JSON and convert each item to a Notepaper object
      notes: (json['notes'] as List<dynamic>)
          .map((noteJson) => Notepaper.fromJson(noteJson))
          .toList(),
    );
  }
}
