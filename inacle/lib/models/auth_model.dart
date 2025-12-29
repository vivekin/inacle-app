class LoginResponse {
  final int? status;
  final String? message;
  final dynamic clientAppUnid;
  final String? token;
   String? emailID;
  

  LoginResponse({
    this.status,
    this.message,
    this.clientAppUnid,
    this.token,
    this.emailID
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] as int?,
      message: json['message'] as String?,
      clientAppUnid: json['client_app_unid'] as dynamic,
      token: json['token'] as String?,
      emailID: json['emailID'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'client_app_unid': clientAppUnid,
      'token': token,
      'emailID': emailID
    };
  }
}
