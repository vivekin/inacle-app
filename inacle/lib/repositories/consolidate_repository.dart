import 'dart:convert';

import 'package:get/get.dart';
import 'package:inacle_app/constants/app_constants.dart';

import '../services/api_service.dart';

class ConsolidateRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<dynamic> fetchConsolidateList() async {
    // try {
      final response = await _apiService
          .post('consolidate', body: {"unid": AppConstants.user.clientAppUnid??'', "arn": AppConstants.agentList[0].arn});
      return jsonDecode(response);
    // } catch (e) {
    //   throw Exception('Failed to load user: $e');
    // }
  }

  fetchHoldingsList() async {
    // try {
      final response = await _apiService
          .post('consolidate_with_total_rpt', body: {"unid": AppConstants.user.clientAppUnid??''});//AppConstants.user.clientAppUnid??''
          //consolidate_rpt
      // return jsonDecode(response);

    var dummyResp = {
    "data": [
        {
            "ARN": "ARN-25984",
            "Category": "Equity",
            "Client Name": "Prakash B R  ",
            "Scheme Name": "360 ONE FLEXICAP FUND-REGULAR PLAN- GROWTH",
            "Folio Number": "393623/09",
            "Inv. Since": "2024-05-15",
            "Investments & Switch Ins (INR.)": "102654",
            "Dividend Reinvest": "0",
            "Dividend (INR.)": "0",
            "Redemption": "0",
            "No. of Units": "7741.91",
            "Avg. Cost (INR.)": "13.26",
            "Current NAV (INR.)": "15.0129",
            "Avg. Value (INR.)": "102658",
            "Market Value (INR.)": "116229",
            "Gain/Loss (INR.)": "13575",
            "Abs. Ret(%)": "13.2241",
            "No. of Days": "90",
            "XIRR (%)": "94.7678",
            "W.P. (%)": "1.68"
        },
        {
            "ARN": "ARN-25984",
            "Category": "Equity",
            "Client Name": "Prakash B R  ",
            "Scheme Name": "Aditya Birla Sun Life Multi-Cap Fund-Regular Growth",
            "Folio Number": "1037717141",
            "Inv. Since": "2022-05-04",
            "Investments & Switch Ins (INR.)": "62527.2",
            "Dividend Reinvest": "0",
            "Dividend (INR.)": "0",
            "Redemption": "0",
            "No. of Units": "5376.38",
            "Avg. Cost (INR.)": "11.63",
            "Current NAV (INR.)": "19.17",
            "Avg. Value (INR.)": "62527.2",
            "Market Value (INR.)": "103065",
            "Gain/Loss (INR.)": "40538",
            "Abs. Ret(%)": "64.8325",
            "No. of Days": "832",
            "XIRR (%)": "25.2572",
            "W.P. (%)": "1.49"
        }
    ],
    "total": [
        {
            "ARN": "ARN-25984",
            "Category": null,
            "Client Name": "Prakash B R",
            "Scheme Name": null,
            "Folio Number": null,
            "Inv. Since": null,
            "Investments & Switch Ins (INR.)": "3938600",
            "Dividend Reinvest": "0",
            "Dividend (INR.)": "0",
            "Redemption": "38772",
            "No. of Units": null,
            "Avg. Cost (INR.)": null,
            "Current NAV (INR.)": null,
            "Avg. Value (INR.)": "3882070",
            "Market Value (INR.)": "7203900",
            "Gain/Loss (INR.)": "3304080",
            "Abs. Ret(%)": "83.89",
            "No. of Days": "1089",
            "XIRR (%)": "24.1879",
            "W.P. (%)": "100"
        }
    ]
};
      //return List<Map<String, dynamic>>.from(dummyResp); //jsonDecode(dummyResp)
      return jsonDecode(response);
    // } catch (e) {
    //   throw Exception('Failed to load user: $e');
    // }
  }

   fetchConsolidateDetails({String ? arn , required String  folio, required String  prod}) async {
    try {
      final response = await _apiService.post('consolidateselected', body: {
        "unid": AppConstants.user.clientAppUnid??'',
        "arn": AppConstants.agentList[0].arn,
        "folio_number": folio,
        "prodcode": prod
      });
      return List<Map<String, dynamic>>.from(jsonDecode(response));
     
      //jsonDecode(response);
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }


  fetchStatementDetails({String ? arn , required String  folio, required String  prod}) async {
    try {
      final response = await _apiService.post('soa', body: {
     
    "unid" : AppConstants.user.clientAppUnid??'',
  	"folio_no" : folio,
        "prodcode" : prod,
        "arn_no" : arn??''

      });
      return List<Map<String, dynamic>>.from(jsonDecode(response));
     
      //jsonDecode(response);
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }
}
