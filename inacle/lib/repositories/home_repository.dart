import 'dart:convert';

import 'package:get/get.dart';
import 'package:inacle_app/constants/app_constants.dart';
import 'package:inacle_app/models/agent_model.dart';
import 'package:inacle_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepository {
  final ApiService _apiService = Get.find<ApiService>();

  fetchAgentList() async {
    try {
      final response = await _apiService.post('agentlist', body: {
        "unid": AppConstants.user.clientAppUnid ?? '',
      });
      return List<Map<String, dynamic>>.from(jsonDecode(response));
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  // Function to save the list of agents
  Future<bool> saveAgentsList(List<AgentModel> agents) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> jsonList =
        agents.map((agent) => agent.toJson()).toList();
    String jsonString = jsonEncode(jsonList);

    return prefs.setString('agents_list', jsonString);
  }

// Function to get the list of agents
  Future<List<AgentModel>?> getAgentsList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString('agents_list');
    if (jsonString == null) {
      return null;
    }

    List<dynamic> jsonList = jsonDecode(jsonString);
    List<AgentModel> agents =
        jsonList.map((json) => AgentModel.fromJson(json)).toList();

    return agents;
  }

//grand total

  fetchDashboardDetails() async {
    try {
      final response = await _apiService.post('grand_total', body: {
        "unid": AppConstants.user.clientAppUnid ?? '',
      });
      return List<Map<String, dynamic>>.from(jsonDecode(response));

      //jsonDecode(response);
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  Future<dynamic> fetchClentPortalLink() async {
    try {
      final response = await _apiService.post('client_login',
          body: {"unid": AppConstants.user.clientAppUnid ?? ''});
      return jsonDecode(response);
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  Future<dynamic> fetchClentDetails() async {
    try {
      final response = await _apiService.post('client',
          body: {"unid": AppConstants.user.clientAppUnid ?? ''});
      return jsonDecode(response);
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }
}
