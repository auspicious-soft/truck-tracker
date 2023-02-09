class UnableJsonParseException implements Exception {
  String? message;

  UnableJsonParseException({this.message});

  @override
  String toString() => message != null
      ? "[UnableJsonParseException: $message]"
      : "[UnableJsonParseException]";
}