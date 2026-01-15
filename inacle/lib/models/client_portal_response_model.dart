class ClientResponse {
  final int? status;
  final String? message;
  final String? url;

  ClientResponse({this.status, this.message, this.url});

  factory ClientResponse.fromJson(Map<String, dynamic> json) {
    return ClientResponse(
      status: json['status'] as int?,
      message: json['message'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'url': url,
    };
  }
}
