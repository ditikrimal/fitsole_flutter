class ResponseAuth {
  ResponseAuth({
    required this.resp,
    required this.message,
    required this.messageStatus,
    required this.token,
  });

  final bool resp;
  final String message;
  final String messageStatus;
  final String token;

  factory ResponseAuth.fromJson(Map<String, dynamic> json) => ResponseAuth(
        resp: json["resp"],
        message: json["message"],
        messageStatus: json["messageStatus"],
        token: json["token"],
      );
}
