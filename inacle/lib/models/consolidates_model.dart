class ConsolidateResponse {
  final String? arn;
  final String? clientId;
  final String? clientName;
  final String? schemeName;
  final String? folioNumber;
  final String? investmentsSwitchIns;
  final String? noOfUnits;
  final String? marketValue;
  final String? currentNAV;
  final String? gainLoss;
  final String? xirr;
  final String? prodCode;

  ConsolidateResponse({
    this.arn,
    this.clientId,
    this.clientName,
    this.schemeName,
    this.folioNumber,
    this.investmentsSwitchIns,
    this.noOfUnits,
    this.marketValue,
    this.currentNAV,
    this.gainLoss,
    this.xirr,
    this.prodCode,
  });

  factory ConsolidateResponse.fromJson(Map<String, dynamic> json) {
    return ConsolidateResponse(
      arn: json['ARN'] as String?,
      clientId: json['Client_Id'],
      clientName: json['Client_Name'],
      schemeName: json['Scheme_Name'],
      folioNumber: json['Folio_Number'],
      investmentsSwitchIns: json['Investments_Switch_Ins'],
      noOfUnits: json['No_Of_Units'],
      marketValue: json['Market_Value'],
      currentNAV: json['Current_NAV'],
      gainLoss: json['Gain_Loss'],
      xirr: json['XIRR'],
      prodCode: json['ProdCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ARN': arn,
      'Client_Id': clientId,
      'Client_Name': clientName,
      'Scheme_Name': schemeName,
      'Folio_Number': folioNumber,
      'Investments_Switch_Ins': investmentsSwitchIns,
      'No_Of_Units': noOfUnits,
      'Market_Value': marketValue,
      'Current_NAV': currentNAV,
      'Gain_Loss': gainLoss,
      'XIRR': xirr,
      'ProdCode': prodCode,
    };
  }
}

//--------------------------------------------------

class ConsolidateDetails {
  final String? clientId;
  final String? clientName;
  final String? schemeName;
  final String? folioNumber;
  final String? prodCode;
  final String? category;
  final String? isin;
  final String? arn;
  final String? invSince;
  final String? dividendReinvest;
  final String? dividend;
  final String? redemption;
  final String? avgCost;
  final String? avgValue;
  final String? absRetPer;
  final String? noOfDays;
  final String? wpPer;

  ConsolidateDetails({
    this.clientId,
    this.clientName,
    this.schemeName,
    this.folioNumber,
    this.prodCode,
    this.category,
    this.isin,
    this.arn,
    this.invSince,
    this.dividendReinvest,
    this.dividend,
    this.redemption,
    this.avgCost,
    this.avgValue,
    this.absRetPer,
    this.noOfDays,
    this.wpPer,
  });

  factory ConsolidateDetails.fromJson(Map<String, dynamic> json) {
    return ConsolidateDetails(
      clientId: json['Client_Id'],
      clientName: json['Client_Name'],
      schemeName: json['Scheme_Name'],
      folioNumber: json['Folio_Number'],
      prodCode: json['ProdCode'],
      category: json['Category'],
      isin: json['ISIN'],
      arn: json['ARN'],
      invSince: json['Inv_Since'],
      dividendReinvest: json['Dividend_Reinvest'],
      dividend: json['Dividend'],
      redemption: json['Redemption'],
      avgCost: json['Avg_Cost'],
      avgValue: json['Avg_Value'],
      absRetPer: json['Abs_Ret_PER'],
      noOfDays: json['No_Of_Days'],
      wpPer: json['WP_PER'],
    );
  }
}

//---------------------------------------------------------------

class HoldingResponse {
  final String? arn;
  final String? category;
  final String? schemeName;
  final String? folioNumber;
  final String? invSince;
  final String? investmentsSwitchIns;
  final String? dividendReinvest;
  final String? dividend;
  final String? redemption;
  final String? noOfUnits;
  final String? avgCost;
  final String? currentNav;
  final String? avgValue;
  final String? marketValue;
  final String? gainLoss;
  final String? absRet;
  final String? noOfDays;
  final String? xirr;
  final String? wp;

  HoldingResponse({
    this.arn,
    this.category,
    this.schemeName,
    this.folioNumber,
    this.invSince,
    this.investmentsSwitchIns,
    this.dividendReinvest,
    this.dividend,
    this.redemption,
    this.noOfUnits,
    this.avgCost,
    this.currentNav,
    this.avgValue,
    this.marketValue,
    this.gainLoss,
    this.absRet,
    this.noOfDays,
    this.xirr,
    this.wp,
  });

  factory HoldingResponse.fromJson(Map<String, dynamic> json) {
    return HoldingResponse(
      arn: json['ARN'] as String?,
      category: json['Category'] as String?,
      schemeName: json['Scheme Name'] as String?,
      folioNumber: json['Folio Number'] as String?,
      invSince: json['Inv. Since'] as String?,
      investmentsSwitchIns:
          (json['Investments & Switch Ins (INR.)'] as String?),
      dividendReinvest: (json['Dividend Reinvest'] as String?),
      dividend: (json['Dividend (INR.)'] as String?),
      redemption: (json['Redemption'] as String?),
      noOfUnits: (json['No. of Units'] as String?),
      avgCost: (json['Avg. Cost (INR.)'] as String?),
      currentNav: (json['Current NAV (INR.)'] as String?),
      avgValue: (json['Avg. Value (INR.)'] as String?),
      marketValue: (json['Market Value (INR.)'] as String?),
      gainLoss: (json['Gain/Loss (INR.)'] as String?),
      absRet: (json['Abs. Ret(%)'] as String?),
      noOfDays: json['No. of Days'] as String?,
      xirr: (json['XIRR (%)'] as String?),
      wp: (json['W.P. (%)'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ARN': arn,
      'Category': category,
      'Scheme Name': schemeName,
      'Folio Number': folioNumber,
      'Inv. Since': invSince,
      'Investments & Switch Ins (INR.)': investmentsSwitchIns,
      'Dividend Reinvest': dividendReinvest,
      'Dividend (INR.)': dividend,
      'Redemption': redemption,
      'No. of Units': noOfUnits,
      'Avg. Cost (INR.)': avgCost,
      'Current NAV (INR.)': currentNav,
      'Avg. Value (INR.)': avgValue,
      'Market Value (INR.)': marketValue,
      'Gain/Loss (INR.)': gainLoss,
      'Abs. Ret(%)': absRet,
      'No. of Days': noOfDays,
      'XIRR (%)': xirr,
      'W.P. (%)': wp,
    };
  }
}
