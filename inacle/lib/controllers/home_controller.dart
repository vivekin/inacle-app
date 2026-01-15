import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inacle_app/constants/app_constants.dart';
import 'package:inacle_app/models/agent_model.dart';
import 'package:inacle_app/models/client_portal_response_model.dart';
import 'package:inacle_app/models/client_response_model.dart';
import 'package:inacle_app/models/consolidates_model.dart';
import 'package:inacle_app/models/dashboard_model.dart';
import 'package:inacle_app/repositories/consolidate_repository.dart';
import 'package:inacle_app/repositories/home_repository.dart';
import 'package:inacle_app/routes.dart';
import 'package:inacle_app/views/home_screen_view.dart';
import 'package:inacle_app/widgets/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  bool _consolidateLoading = false;

  bool get consolidateLoading => _consolidateLoading;

  List<ConsolidateResponse> _consolidateList = [];
  List<AgentModel> _agentsList = [];
  List<GrandTotalModel> _grandTotalList = [];

  List<GrandTotalModel> get grandTotalList => _grandTotalList;

  List<ConsolidateResponse> get consolidateList => _consolidateList;
  List<AgentModel> get clientList => _agentsList;

  List<ConsolidateResponse> _displayedConsolidateList = [];
  List<ConsolidateResponse> get displayedConsolidateList =>
      _displayedConsolidateList;
  late Future<List<GridItem>> _dashboardFuture;
  Future<List<GridItem>> get dashboardFuture => _dashboardFuture;
  ClientResponse _clientResponse = ClientResponse();
  ClientResponse get clientResponse => _clientResponse;

  ClientDetailsResponse _clientDetailsResponse = ClientDetailsResponse();
  ClientDetailsResponse get clientDetailsResponse => _clientDetailsResponse;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _clientName = "";
  String get clientName => _clientName;

  String _agentLogoBase64 = "";
  String get agentLogoBase64 => _agentLogoBase64;

  bool _isLogoLoading = false;
  bool get isLogoLoading => _isLogoLoading;

  @override
  void onInit() async {
    super.onInit();

    _initializeData();
    // await fetchAgentList();
    // _dashboardFuture = fetchDashboardDetails();
    // fetchClienPortal();

    //fetchConsolidateList();
  }

  Future<void> _initializeData() async {
    _isLoading = true;
    await fetchAgentList();
    _dashboardFuture = fetchDashboardDetails();
    await fetchClienDetails();
    await fetchClienPortal();
    await fetchAgentLogo();
    // _isLoading = false;
    // update();
  }

  fetchConsolidateList() async {
    _consolidateLoading = true;
    update();
    final List<dynamic> value =
        await ConsolidateRepository().fetchConsolidateList();
    _consolidateList = value
        .map((item) =>
            ConsolidateResponse.fromJson(item as Map<String, dynamic>))
        .toList();
    _displayedConsolidateList = _consolidateList;
    _consolidateLoading = false;
    update();
  }

  fetchClienPortal() async {
    final dynamic value = await HomeRepository().fetchClentPortalLink();
    if (value != null) {
      ClientResponse clientPortal = ClientResponse.fromJson(value);
      _clientResponse = clientPortal;
      update();
    } else {
      CustomSnackbar.showError();
      update();
    }
  }

  fetchClienDetails() async {
    if ((AppConstants.clientDetails.name ?? '').isNotEmpty) {
      log('already fetched');
      return;
    }
    final dynamic value = await HomeRepository().fetchClentDetails();
    if (value != null) {
      ClientDetailsResponse clientDetailsResponse =
          ClientDetailsResponse.fromJson(value);
      _clientDetailsResponse = clientDetailsResponse;
      AppConstants.clientDetails = _clientDetailsResponse;
      update();
    } else {
      CustomSnackbar.showError();
      update();
    }
  }

  fetchAgentList() async {
    // _consolidateLoading = true;
    // update();
    if (AppConstants.agentList.isNotEmpty) {
      //fetchConsolidateList();
      return;
    } else {
      final List<dynamic> value = await HomeRepository().fetchAgentList();
      _agentsList = value
          .map((item) => AgentModel.fromJson(item as Map<String, dynamic>))
          .toList();
      AppConstants.agentList = _agentsList;
      //fetchConsolidateList();
      HomeRepository().saveAgentsList(_agentsList);
      update();
    }
  }

  Future<List<GridItem>> fetchDashboardDetails() async {
    // _isLoading =true;
    // update();
    final List<dynamic> value = await HomeRepository().fetchDashboardDetails();
    _grandTotalList = value
        .map((item) => GrandTotalModel.fromJson(item as Map<String, dynamic>))
        .toList();
    _isLoading = false;
    update();
    if (value.isEmpty) {
      return [];
    } else {
      _clientName = _grandTotalList.first.clientNameFull ?? '';
      update();
      return [
        GridItem(
          header: 'Total Investment',
          value: '₹${_grandTotalList.first.investmentsSwitchIns}',
        ),
        GridItem(
          header: 'Total Valuation',
          value: '₹${_grandTotalList.first.marketValue}',
        ),
        GridItem(
          header: 'Total Div. Paid',
          value: '₹${_grandTotalList.first.dividend}',
        ),
        GridItem(
          header: 'Total Div. Reinvested',
          value: '₹${_grandTotalList.first.dividendReinvest}',
        ),
        GridItem(
          header: 'Total Gain/Loss',
          value: formatGainLoss(_grandTotalList
              .first.gainLoss), //'₹${_grandTotalList.first.gainLoss}',
        ),
        GridItem(
          header: 'Abs. Rtn. / XIRR',
          value:
              '${formatPercentage(_grandTotalList.first.absRetPer)} / ${formatPercentage(_grandTotalList.first.xirr)}',
          //'${double.parse(_grandTotalList.first.absRetPer??'0').toStringAsFixed(2)} / ${double.parse(_grandTotalList.first.xirr??'0').toStringAsFixed(2)}',
          //'${_grandTotalList.first.absRetPer} / ${_grandTotalList.first.xirr}',
        ),
      ];
    }
  }

  String formatGainLoss(String? gainLoss) {
    if (gainLoss == null || gainLoss.isEmpty) return '₹0.00';

    double amount = double.tryParse(gainLoss) ?? 0.0;
    String formattedValue =
        '₹${amount.abs().toStringAsFixed(2)}'; // Absolute value for display

    return amount >= 0 ? '+$formattedValue' : '-$formattedValue';
  }

  String formatPercentage(String? value) {
    if (value == null || value.isEmpty) return '0.00%';

    double percentage = double.tryParse(value) ?? 0.0;
    String formattedValue = '${percentage.abs().toStringAsFixed(2)}%';

    return percentage >= 0 ? '+$formattedValue' : '-$formattedValue';
  }

  searchScheme(String searchText) {
    List<ConsolidateResponse> searchResults = [];

    for (var dish in _consolidateList) {
      if (dish.schemeName!.toLowerCase().contains(searchText.toLowerCase())) {
        searchResults.add(dish);
      }
    }
    _displayedConsolidateList = searchResults;
    update();
  }

  Future<List<Map<String, dynamic>>> fetchData({arn, folio, prod}) async {
    // This is your data

    List<Map<String, dynamic>> data = await ConsolidateRepository()
        .fetchConsolidateDetails(arn: arn, folio: folio, prod: prod);
    // Simulate a delay
    await Future.delayed(const Duration(seconds: 2));

    return data;
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAllNamed(AppRoutes.login);
  }

  fetchAgentLogo() async {
    _isLogoLoading = true;
    update();
    try {
      final dynamic value = await HomeRepository().fetchAgentLogo();
      if (value != null &&
          value['logo_base64'] != null &&
          (value['logo_base64'] as String).isNotEmpty) {
        String logoBase64 = value['logo_base64'];
        // Validate base64 can be decoded
        try {
          base64Decode(logoBase64);
          _agentLogoBase64 = logoBase64;
          update();
        } catch (decodeError) {
          log('Error decoding base64: $decodeError');
          _agentLogoBase64 = "";
          update();
        }
      } else {
        _agentLogoBase64 = "";
        update();
      }
    } catch (e) {
      log('Error fetching agent logo: $e');
      _agentLogoBase64 = "";
      update();
    } finally {
      _isLogoLoading = false;
      update();
    }
  }
}
