class ResponseDefault {
  const ResponseDefault({
    required this.resp,
    required this.message,
  });

  final bool resp;
  final String message;

  factory ResponseDefault.fromJson(Map<String, dynamic> json) {
    return ResponseDefault(
      resp: json["resp"] ?? false, // Default to false if resp is null
      message: json["message"] ?? "No message", // Default message if null
    );
  }
}
