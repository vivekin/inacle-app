class AgentModel {
  final String unid;
  final String clientAppUnid;
  final String agentId;
  final String arn;
  final String dbName;
  final String clientId;
  final String? userName;
  final String? password;
  final String? clientName;

  AgentModel({
    required this.unid,
    required this.clientAppUnid,
    required this.agentId,
    required this.arn,
    required this.dbName,
    required this.clientId,
    this.userName,
    this.password,
    this.clientName,
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      unid: json['unid'],
      clientAppUnid: json['client_app_unid'],
      agentId: json['agent_id'],
      arn: json['arn'],
      dbName: json['db_name'],
      clientId: json['client_id'],
      userName: json['user_name'],
      password: json['password'],
      clientName: json['client_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unid': unid,
      'client_app_unid': clientAppUnid,
      'agent_id': agentId,
      'arn': arn,
      'db_name': dbName,
      'client_id': clientId,
      'user_name': userName,
      'password': password,
      'client_name': clientName,
    };
  }
}
