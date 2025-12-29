class GrandTotalModel {
  final String? clientAppUnid;
  final String? clientName;
  final String? arn;
  final String? clientId;
  final String? clientNameFull;
  final String? investmentsSwitchIns;
  final String? marketValue;
  final String? dividend;
  final String? dividendReinvest;
  final String? gainLoss;
  final String? absRetPer;
  final String? xirr;

  GrandTotalModel({
    this.clientAppUnid,
    this.clientName,
    this.arn,
    this.clientId,
    this.clientNameFull,
    this.investmentsSwitchIns,
    this.marketValue,
    this.dividend,
    this.dividendReinvest,
    this.gainLoss,
    this.absRetPer,
    this.xirr,
  });

  factory GrandTotalModel.fromJson(Map<String, dynamic> json) {
    return GrandTotalModel(
      clientAppUnid: json['client_app_unid'] as String?,
      clientName: json['client_name'] as String?,
      arn: json['ARN'] as String?,
      clientId: json['Client_Id'] as String?,
      clientNameFull: json['Client_Name'] as String?,
      investmentsSwitchIns: json['Investments_Switch_Ins'] as String?,
      marketValue: json['Market_Value'] as String?,
      dividend: json['Dividend'] as String?,
      dividendReinvest: json['Dividend_Reinvest'] as String?,
      gainLoss: json['Gain_Loss'] as String?,
      absRetPer: json['Abs_Ret_PER'] as String?,
      xirr: json['XIRR'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_app_unid': clientAppUnid,
      'client_name': clientName,
      'ARN': arn,
      'Client_Id': clientId,
      'Client_Name': clientNameFull,
      'Investments_Switch_Ins': investmentsSwitchIns,
      'Market_Value': marketValue,
      'Dividend': dividend,
      'Dividend_Reinvest': dividendReinvest,
      'Gain_Loss': gainLoss,
      'Abs_Ret_PER': absRetPer,
      'XIRR': xirr,
    };
  }
}
