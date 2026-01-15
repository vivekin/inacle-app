import 'dart:convert';

import 'package:get/get.dart';
import 'package:inacle_app/constants/app_constants.dart';

import '../services/api_service.dart';

class ConsolidateRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<dynamic> fetchConsolidateList() async {
    // try {
    final response = await _apiService.post('consolidate', body: {
      "unid": AppConstants.user.clientAppUnid ?? '',
      "arn": AppConstants.agentList[0].arn
    });
    return jsonDecode(response);
    // } catch (e) {
    //   throw Exception('Failed to load user: $e');
    // }
  }

  fetchHoldingsList() async {
    // try {
    final response = await _apiService.post('consolidate_with_total_rpt',
        body: {
          "unid": AppConstants.user.clientAppUnid ?? ''
        }); //AppConstants.user.clientAppUnid??''
    //consolidate_rpt
    // return jsonDecode(response);
    return jsonDecode(response);
    // } catch (e) {
    //   throw Exception('Failed to load user: $e');
    // }
  }

  fetchConsolidateDetails(
      {String? arn, required String folio, required String prod}) async {
    try {
      final response = await _apiService.post('consolidateselected', body: {
        "unid": AppConstants.user.clientAppUnid ?? '',
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

  fetchStatementDetails(
      {String? arn, required String folio, required String prod}) async {
    try {
      final response = await _apiService.post('soa', body: {
        "unid": AppConstants.user.clientAppUnid ?? '',
        "folio_no": folio,
        "prodcode": prod,
        "arn_no": arn ?? ''
      });
      return List<Map<String, dynamic>>.from(jsonDecode(response));

      //jsonDecode(response);
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }
}
