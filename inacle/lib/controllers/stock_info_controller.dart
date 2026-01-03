import 'dart:developer';

import 'package:get/get.dart';
import 'package:inacle_app/models/consolidates_model.dart';
import 'package:inacle_app/repositories/consolidate_repository.dart';
import 'package:inacle_app/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockInfoController extends GetxController {
  bool _consolidateLoading = false;

  bool get consolidateLoading => _consolidateLoading;

  List<ConsolidateResponse> _consolidateList = [];
  List<ConsolidateResponse> get consolidateList => _consolidateList;

  List<HoldingResponse> _holdingsList = [];
  List<HoldingResponse> get holdingsList => _holdingsList;

  List<ConsolidateResponse> _displayedConsolidateList = [];
  List<ConsolidateResponse> get displayedConsolidateList =>
      _displayedConsolidateList;

  List<HoldingResponse> _displayedHoldingsList = [];
  List<HoldingResponse> get displayedHoldingsList => _displayedHoldingsList;

  @override
  void onInit() {
    super.onInit();
    log('come inside report screen');
    String? report = Get.arguments as String?;
    if (report != null) {
      if (report == "soa") {
        fetchConsolidateList();
      } else if (report == "holdings") {
        fetchHoldingsList();
      }
    } else {
// Handle the case where no arguments are passed
      print('No arguments passed');
    }
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

  fetchHoldingsList() async {
    _consolidateLoading = true;
    update();
    final List<dynamic> value =
        await ConsolidateRepository().fetchHoldingsList();
    _holdingsList = value
        .map((item) => HoldingResponse.fromJson(item as Map<String, dynamic>))
        .toList();
    _displayedHoldingsList = _holdingsList;
    _consolidateLoading = false;
    update();
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

  holdingListSearchScheme(String searchText) {
    List<HoldingResponse> searchResults = [];

    for (var dish in _holdingsList) {
      if (dish.schemeName!.toLowerCase().contains(searchText.toLowerCase())) {
        searchResults.add(dish);
      }
    }
    _displayedHoldingsList = searchResults;
    update();
  }

  Future<Map<String, dynamic>> fetchHoldings({arn, folio, prod}) async {
    dynamic holdingsList = await ConsolidateRepository().fetchHoldingsList();

// Simulate a delay
    await Future.delayed(const Duration(seconds: 2));

// Create a map with data and total
    Map<String, dynamic> result = {
      'data': holdingsList['data'],
      'total': holdingsList['total'] ?? [],
    };

    return result;
  }

  Future<List<Map<String, dynamic>>> fetchData({arn, folio, prod}) async {
    // This is your data

    List<Map<String, dynamic>> data = await ConsolidateRepository()
        .fetchConsolidateDetails(arn: arn, folio: folio, prod: prod);
    // Simulate a delay
    await Future.delayed(const Duration(seconds: 2));

    return data;
  }

  Future<List<Map<String, dynamic>>> fetchStatementData(
      {arn, folio, prod}) async {
    // This is your data

    List<Map<String, dynamic>> data = await ConsolidateRepository()
        .fetchStatementDetails(arn: arn, folio: folio, prod: prod);
    // Simulate a delay
    await Future.delayed(const Duration(seconds: 2));

    return data;
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAllNamed(AppRoutes.login);
  }
}
