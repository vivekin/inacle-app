import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:inacle_app/common/hex_color.dart';
import 'package:inacle_app/constants/app_constants.dart';
import 'package:inacle_app/constants/images.dart';
import 'package:inacle_app/controllers/stock_info_controller.dart';
import 'package:inacle_app/models/consolidates_model.dart';
import 'package:inacle_app/repositories/consolidate_repository.dart';
import 'package:inacle_app/widgets/custom_searchbar.dart';
import 'package:inacle_app/widgets/zoomable_widget.dart';
import 'package:intl/intl.dart';

class StockSummaryScreen extends GetView<StockInfoController> {
  const StockSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ConsolidateRepository());
    Get.put(StockInfoController()); // Initialize the controller here
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Image.asset(
              Images.logo,
              height: 36.h,
              width: 120.w,
            ),
          ),
          actions: const [],
        ),
        body: GetBuilder<StockInfoController>(builder: (stockInfoController) {
          return stockInfoController.consolidateLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      child: CustomSearchBar(
                        onSearch: (value) {
                          stockInfoController.searchScheme(value);
                        },
                      ),
                    ),
                    Expanded(
                      child: stockInfoController
                              .displayedConsolidateList.isEmpty
                          ? const Center(
                              child: Text("No data found",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                  )),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: stockInfoController
                                  .displayedConsolidateList.length,
                              itemBuilder: (context, index) {
                                ConsolidateResponse consolidate =
                                    stockInfoController
                                        .displayedConsolidateList[index];
                                return InkWell(
                                  onTap: () {
                                    // showDataTableDialog(context);
                                    showMyDialog(context, stockInfoController,
                                        consolidate);
                                  },
                                  child: Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          RichText(
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      '${consolidate.schemeName} ',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '(${consolidate.folioNumber})',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DataTable(
                                            headingRowHeight: 40,
                                            headingTextStyle: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                            dataRowHeight: 30,
                                            dataTextStyle: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            columns: const <DataColumn>[
                                              DataColumn(
                                                label: Text(
                                                  '',
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '',
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                            ],
                                            rows: <DataRow>[
                                              DataRow(
                                                cells: <DataCell>[
                                                  const DataCell(
                                                      Text('Invested')),
                                                  DataCell(Text(
                                                    consolidate
                                                            .investmentsSwitchIns ??
                                                        '',
                                                    style: const TextStyle(
                                                        fontFamily: 'Roboto'),
                                                  )),
                                                ],
                                              ),
                                              DataRow(
                                                cells: <DataCell>[
                                                  const DataCell(
                                                      Text('No of Units')),
                                                  DataCell(Text(
                                                    consolidate.noOfUnits ?? '',
                                                    style: const TextStyle(
                                                        fontFamily: 'Roboto'),
                                                  )),
                                                ],
                                              ),
                                              DataRow(
                                                cells: <DataCell>[
                                                  const DataCell(
                                                      Text('Market Value')),
                                                  DataCell(Text(
                                                    consolidate.marketValue ??
                                                        '',
                                                    style: const TextStyle(
                                                        fontFamily: 'Roboto'),
                                                  )),
                                                ],
                                              ),
                                              DataRow(
                                                cells: <DataCell>[
                                                  const DataCell(Text('Nav')),
                                                  DataCell(Text(
                                                    consolidate.currentNAV ??
                                                        '',
                                                    style: const TextStyle(
                                                        fontFamily: 'Roboto'),
                                                  )),
                                                ],
                                              ),
                                              DataRow(
                                                cells: <DataCell>[
                                                  const DataCell(
                                                      Text('Gain/Loss')),
                                                  DataCell(Text(
                                                    formatGainLoss(
                                                        consolidate.gainLoss),
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _getDynamicColor(
                                                          consolidate.gainLoss),
                                                    ),
                                                  )),
                                                ],
                                              ),
                                              DataRow(
                                                cells: <DataCell>[
                                                  const DataCell(
                                                      Text('XIRR(%)')),
                                                  DataCell(Text(
                                                    formatPercentage(
                                                        consolidate.xirr),
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _getDynamicColor(
                                                          consolidate.xirr),
                                                    ),
                                                  )),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(),
                                                InkWell(
                                                  onTap: () {
                                                    log('View Statement for ${consolidate.schemeName}');
                                                    showSOSDialog(
                                                      context,
                                                      stockInfoController,
                                                      arn:
                                                          consolidate.arn ?? '',
                                                      folio: consolidate
                                                              .folioNumber ??
                                                          '',
                                                      prod: consolidate
                                                              .prodCode ??
                                                          '',
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: const Text(
                                                      'Statement',
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: Get.width * 0.25),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    )
                  ],
                );
        }),
      ),
    );
  }

  String formatGainLoss(String? gainLoss) {
    if (gainLoss == null || gainLoss.isEmpty) return '₹0.00';

    double amount = double.tryParse(gainLoss) ?? 0.0;
    String formattedValue = '₹${amount.abs().toStringAsFixed(2)}';

    return amount >= 0 ? '+$formattedValue' : '-$formattedValue';
  }

  String formatPercentage(String? value) {
    if (value == null || value.isEmpty) return '0.00%';

    double percentage = double.tryParse(value) ?? 0.0;
    String formattedValue = '${percentage.abs().toStringAsFixed(2)}%';

    return percentage >= 0 ? '+$formattedValue' : '-$formattedValue';
  }

// Function to determine text color dynamically
  Color _getDynamicColor(String? value) {
    double parsedValue =
        double.tryParse(value?.replaceAll(RegExp(r'[^0-9.-]'), '') ?? '0') ??
            0.0;
    return parsedValue < 0 ? Colors.red : Colors.green;
  }

  void showMyDialog(
      BuildContext context,
      StockInfoController stockInfoController,
      ConsolidateResponse consolidate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]);
          },
          child: Material(
            type: MaterialType
                .transparency, // makes the dialog background transparent
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 60,
                        right: 0), // Adjust padding to avoid close button area
                    child: SizedBox(
                      height:
                          MediaQuery.of(context).size.height, // Screen height
                      width: MediaQuery.of(context).size.width, // Screen width
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: stockInfoController.fetchData(
                          arn: AppConstants.agentList[0].arn,
                          folio: consolidate.folioNumber,
                          prod: consolidate.prodCode,
                        ), // Your function to fetch data
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}',
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                ));
                          } else {
                            return ZoomableWidget(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(Colors
                                        .blue), // Set header background color to blue
                                    columns: snapshot.data![0].keys.map((key) {
                                      return DataColumn(
                                        label: Text(
                                          convertFieldName(key),
                                          style: const TextStyle(
                                              fontFamily: 'Roboto',
                                              color: Colors
                                                  .white), // Set header text color to white for contrast
                                        ),
                                      );
                                    }).toList(),
                                    rows: snapshot.data!.map((row) {
                                      List<DataCell> cells = row.values
                                          .map((value) => DataCell(
                                                Text(value.toString(),
                                                    style: const TextStyle(
                                                      fontFamily: 'Roboto',
                                                    )),
                                              ))
                                          .toList();
                                      return DataRow(cells: cells);
                                    }).toList(),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.screen_rotation,
                              color: Colors.black),
                          onPressed: () {
                            if (MediaQuery.of(context).orientation ==
                                Orientation.portrait) {
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.landscapeLeft,
                                DeviceOrientation.landscapeRight,
                              ]);
                            } else {
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.portraitUp,
                                DeviceOrientation.portraitDown,
                              ]);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            Navigator.of(context).pop();
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.portraitUp,
                              DeviceOrientation.portraitDown,
                            ]);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showSOSDialog(
      BuildContext context, StockInfoController stockInfoController,
      {required String arn, required String folio, required String prod}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
            canPop: true,
            onPopInvoked: (didPop) {},
            child: Material(
              type: MaterialType
                  .transparency, // makes the dialog background transparent
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40,
                          right:
                              0), // Adjust padding to avoid close button area
                      child: SizedBox(
                        height:
                            MediaQuery.of(context).size.height, // Screen height
                        width:
                            MediaQuery.of(context).size.width, // Screen width
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: stockInfoController.fetchStatementData(
                            arn: arn,
                            folio: folio,
                            prod: prod,
                          ), // Your function to fetch data
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<Map<String, dynamic>> data = snapshot.data!;
                              Map<String, dynamic>? lastRow =
                                  data.isNotEmpty ? data.removeLast() : null;

                              return Column(
                                children: [
                                  const SizedBox(
                                      height:
                                          20), // Padding on top of the folio number section
                                  Container(
                                    width: double.infinity,
                                    color: Colors.blue.shade100,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Folio No.: $folio', //\nStatement Date: ${data.isNotEmpty ? DateFormat('dd-MM-yyyy').format(DateTime.parse(data[0]['traddate'])) : 'N/A'
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade900,
                                        fontFamily: 'Roboto',
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    color: Colors.blue.shade100,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      data.isNotEmpty
                                          ? data[0]['scheme_name'] ?? ''
                                          : '',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade900,
                                        fontFamily: 'Roboto',
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  const SizedBox(
                                      height:
                                          10), // Padding on top of the DataTable
                                  Expanded(
                                    child: ZoomableWidget(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: DataTable(
                                            headingRowColor: WidgetStateProperty
                                                .resolveWith<Color>(
                                              (Set<WidgetState> states) {
                                                return Colors
                                                    .blue; // Change the heading row color to blue
                                              },
                                            ),
                                            columns: const [
                                              DataColumn(
                                                  label: Text('Date',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text(
                                                      'Transaction Desc',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('Trns Type',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('Amount in INR',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('NAV',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('Number of Units',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('Balance Units',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                            ],
                                            rows: data.map((row) {
                                              return DataRow(cells: [
                                                DataCell(Text(
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(DateTime.parse(
                                                          row['traddate'])),
                                                  style: const TextStyle(
                                                    fontFamily: 'Roboto',
                                                  ),
                                                )),
                                                DataCell(Text(
                                                    row['trxn_natur'] ?? '',
                                                    style: const TextStyle(
                                                      fontFamily: 'Roboto',
                                                    ))),
                                                DataCell(
                                                    Text(row['trxn_type'] ?? '',
                                                        style: const TextStyle(
                                                          fontFamily: 'Roboto',
                                                        ))),
                                                DataCell(
                                                    Text(row['amount'] ?? '',
                                                        style: const TextStyle(
                                                          fontFamily: 'Roboto',
                                                        ))),
                                                DataCell(
                                                    Text(row['purprice'] ?? '',
                                                        style: const TextStyle(
                                                          fontFamily: 'Roboto',
                                                        ))),
                                                DataCell(
                                                    Text(row['units'] ?? '',
                                                        style: const TextStyle(
                                                          fontFamily: 'Roboto',
                                                        ))),
                                                DataCell(
                                                    Text(row['bal_units'] ?? '',
                                                        style: const TextStyle(
                                                          fontFamily: 'Roboto',
                                                        ))),
                                              ]);
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (lastRow != null) ...[
                                    const SizedBox(
                                        height:
                                            20), // Padding below the DataTable
                                    Container(
                                      width: double.infinity,
                                      color: Colors.blue.shade100,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Market Value of Balance Units at NAV of ${lastRow['curr_nav']} on ${DateFormat('dd-MM-yyyy').format(DateTime.parse(lastRow['curr_nav_date']))} (INR): ${lastRow['curr_val']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade900,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.screen_rotation,
                                color: Colors.black),
                            onPressed: () {
                              if (MediaQuery.of(context).orientation ==
                                  Orientation.portrait) {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.landscapeLeft,
                                  DeviceOrientation.landscapeRight,
                                ]);
                              } else {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.portraitUp,
                                  DeviceOrientation.portraitDown,
                                ]);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.black),
                            onPressed: () {
                              Navigator.of(context).pop();
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.portraitUp,
                                DeviceOrientation.portraitDown,
                              ]);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  //-------------------------------------------------------->

  String convertFieldName(String fieldName) {
    String header = fieldName;
    // Split the field name by underscore
    if (fieldName == 'Category') {
      header = 'Category';
    } else if (fieldName == 'Scheme_Name') {
      header = 'Scheme Name';
    } else if (fieldName == 'Client_Id') {
      header = 'Client Id';
    } else if (fieldName == 'Client_Name') {
      header = 'Client Name';
    } else if (fieldName == 'Folio_Number') {
      header = 'Folio Number';
    } else if (fieldName == 'ProdCode') {
      header = 'Product Code';
    } else if (fieldName == 'ISIN') {
      header = 'Investments Switch Ins(INR.)';
    } else if (fieldName == 'Inv_Since') {
      header = 'Inv.Since';
    } else if (fieldName == 'Dividend_Reinvest') {
      header = 'Dividend Reinvest';
    } else if (fieldName == 'Dividend') {
      header = 'Dividend(INR.)';
    } else if (fieldName == 'Avg_Cost') {
      header = 'Avg. Cost(INR.)';
    } else if (fieldName == 'No_Of_Days') {
      header = 'No. Of Days';
    } else if (fieldName == 'Abs_Ret_PER') {
      header = 'Abs. Ret.(%)';
    } else if (fieldName == 'WP_PER') {
      header = 'W.P(%)';
    }

    return header;
  }

  String convertSosName(String fieldName) {
    String header = fieldName;
    // Split the field name by underscore
    if (fieldName == 'arn_no') {
      header = 'ARN No.';
    } else if (fieldName == 'client_id') {
      header = 'Client Id';
    } else if (fieldName == 'client_name') {
      header = 'Client Name';
    } else if (fieldName == 'pan_no') {
      header = 'Client Name';
    } else if (fieldName == 'Folio_Number') {
      header = 'Pan No.';
    } else if (fieldName == 'folio_no') {
      header = 'Folio No.';
    } else if (fieldName == 'amc_name') {
      header = 'AMC Name';
    } else if (fieldName == 'schme_name') {
      header = 'Scheme Name';
    } else if (fieldName == 'prodcode') {
      header = 'Product Code';
    } else if (fieldName == 'traddate') {
      header = 'Trade Date';
    } else if (fieldName == 'trxn_natur') {
      header = 'Trxn. Nature';
    } else if (fieldName == 'trxn_type') {
      header = 'Trxn. Type';
    } else if (fieldName == 'amount') {
      header = 'Amount(INR.)';
    } else if (fieldName == 'purprice') {
      header = 'Pur. Price(INR.)';
    } else if (fieldName == 'units') {
      header = 'Units';
    } else if (fieldName == 'bal_units') {
      header = 'Bal. Units';
    } else if (fieldName == 'curr_nav') {
      header = 'Curr. NAV(INR.)';
    } else if (fieldName == 'curr_unit') {
      header = 'Curr. Unit';
    } else if (fieldName == 'curr_nav_date') {
      header = 'Curr. Nav. Date';
    } else if (fieldName == 'curr_val') {
      header = 'Curr. Val(INR.)';
    }

    return header;
  }
}

// ------------------------------Holding Details-----------------------

class StockHoldingsScreen extends GetView<StockInfoController> {
  const StockHoldingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ConsolidateRepository());
    Get.lazyPut(() => StockInfoController());
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Image.asset(
              Images.logo,
              height: 36.h,
              width: 120.w,
            ),
          ),
          actions: const [],
        ),
        body: GetBuilder<StockInfoController>(builder: (stockInfoController) {
          return stockInfoController.consolidateLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      child: CustomSearchBar(
                        onSearch: (value) {
                          stockInfoController.holdingListSearchScheme(value);
                        },
                      ),
                    ),
                    Expanded(
                      child: stockInfoController.displayedHoldingsList.isEmpty
                          ? const Center(
                              child: Text("No data found",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                  )),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: stockInfoController
                                  .displayedHoldingsList.length,
                              itemBuilder: (context, index) {
                                HoldingResponse consolidate =
                                    stockInfoController
                                        .displayedHoldingsList[index];
                                return InkWell(
                                  onTap: () {
                                    // showDataTableDialog(context);
                                    // showMyDialog(context, stockInfoController,
                                    //     consolidate);
                                  },
                                  child: Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          RichText(
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      '${consolidate.schemeName} ',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '(${consolidate.folioNumber})',
                                                  style: const TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DataTable(
                                            headingRowHeight: 40,
                                            headingTextStyle: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                            dataRowHeight: 30,
                                            dataTextStyle: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            columns: const <DataColumn>[
                                              DataColumn(
                                                label: Text(
                                                  '',
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '',
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                            ],
                                            rows: <DataRow>[
                                              DataRow(
                                                cells: <DataCell>[
                                                  const DataCell(Text('Invested',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                      ))),
                                                  DataCell(Text(
                                                      consolidate
                                                              .investmentsSwitchIns ??
                                                          '',
                                                      style: const TextStyle(
                                                        fontFamily: 'Roboto',
                                                      ))),
                                                ],
                                              ),
                                              DataRow(
                                                cells: <DataCell>[
                                                  const DataCell(
                                                      Text('No of Units',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                          ))),
                                                  DataCell(Text(
                                                      consolidate.noOfUnits ??
                                                          '',
                                                      style: const TextStyle(
                                                        fontFamily: 'Roboto',
                                                      ))),
                                                ],
                                              ),
                                              DataRow(
                                                cells: <DataCell>[
                                                  const DataCell(
                                                      Text('Market Value',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                          ))),
                                                  DataCell(Text(
                                                      consolidate.marketValue ??
                                                          '',
                                                      style: const TextStyle(
                                                        fontFamily: 'Roboto',
                                                      ))),
                                                ],
                                              ),
                                              DataRow(
                                                cells: <DataCell>[
                                                  const DataCell(Text('Nav',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                      ))),
                                                  DataCell(Text(
                                                      consolidate.currentNav ??
                                                          '',
                                                      style: const TextStyle(
                                                        fontFamily: 'Roboto',
                                                      ))),
                                                ],
                                              ),
                                              DataRow(
                                                cells: <DataCell>[
                                                  const DataCell(
                                                      Text('Gain/Loss',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                          ))),
                                                  DataCell(Text(
                                                      consolidate.gainLoss ??
                                                          '',
                                                      style: const TextStyle(
                                                        fontFamily: 'Roboto',
                                                      ))),
                                                ],
                                              ),
                                              DataRow(
                                                cells: <DataCell>[
                                                  const DataCell(Text('XIRR(%)',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                      ))),
                                                  DataCell(Text(
                                                      consolidate.xirr ?? '',
                                                      style: const TextStyle(
                                                        fontFamily: 'Roboto',
                                                      ))),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    )
                  ],
                );
        }),
      ),
    );
  }

  void showMyDialog(BuildContext context,
      StockInfoController stockInfoController, HoldingResponse consolidate) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Return your dialog here
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]);
          },
          child: Material(
            type: MaterialType
                .transparency, // makes the dialog background transparent
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              child: SizedBox(
                height: MediaQuery.of(context).size.height, // Screen width
                width: MediaQuery.of(context).size.width, // Screen height
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: stockInfoController.fetchData(
                      arn: AppConstants.agentList[0].arn,
                      folio: consolidate.folioNumber,
                      prod: ''),
                  //consolidate.prodCode), // Your function to fetch data
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                          ));
                    } else {
                      return ZoomableWidget(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              columns: snapshot.data![0].keys
                                  .map((key) => DataColumn(
                                        label: Text(convertFieldName(key)),
                                      ))
                                  .toList(),
                              rows: snapshot.data!
                                  .map((row) => DataRow(
                                        cells: row.values
                                            .map((value) =>
                                                DataCell(Text(value.toString(),
                                                    style: const TextStyle(
                                                      fontFamily: 'Roboto',
                                                    ))))
                                            .toList(),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //-------------------------------------------------------->

  String convertFieldName(String fieldName) {
    String header = fieldName;
    // Split the field name by underscore
    if (fieldName == 'Category') {
      header = 'Category';
    } else if (fieldName == 'Scheme_Name') {
      header = 'Scheme Name';
    } else if (fieldName == 'Client_Id') {
      header = 'Client Id';
    } else if (fieldName == 'Client_Name') {
      header = 'Client Name';
    } else if (fieldName == 'Folio_Number') {
      header = 'Folio Number';
    } else if (fieldName == 'ProdCode') {
      header = 'Product Code';
    } else if (fieldName == 'ISIN') {
      header = 'Investments Switch Ins(INR.)';
    } else if (fieldName == 'Inv_Since') {
      header = 'Inv.Since';
    } else if (fieldName == 'Dividend_Reinvest') {
      header = 'Dividend Reinvest';
    } else if (fieldName == 'Dividend') {
      header = 'Dividend(INR.)';
    } else if (fieldName == 'Avg_Cost') {
      header = 'Avg. Cost(INR.)';
    } else if (fieldName == 'No_Of_Days') {
      header = 'No. Of Days';
    } else if (fieldName == 'Abs_Ret_PER') {
      header = 'Abs. Ret.(%)';
    } else if (fieldName == 'WP_PER') {
      header = 'W.P(%)';
    }

    return header;
  }

  String convertSosName(String fieldName) {
    String header = fieldName;
    // Split the field name by underscore
    if (fieldName == 'arn_no') {
      header = 'ARN No.';
    } else if (fieldName == 'client_id') {
      header = 'Client Id';
    } else if (fieldName == 'client_name') {
      header = 'Client Name';
    } else if (fieldName == 'pan_no') {
      header = 'Client Name';
    } else if (fieldName == 'Folio_Number') {
      header = 'Pan No.';
    } else if (fieldName == 'folio_no') {
      header = 'Folio No.';
    } else if (fieldName == 'amc_name') {
      header = 'AMC Name';
    } else if (fieldName == 'schme_name') {
      header = 'Scheme Name';
    } else if (fieldName == 'prodcode') {
      header = 'Product Code';
    } else if (fieldName == 'traddate') {
      header = 'Trade Date';
    } else if (fieldName == 'trxn_natur') {
      header = 'Trxn. Nature';
    } else if (fieldName == 'trxn_type') {
      header = 'Trxn. Type';
    } else if (fieldName == 'amount') {
      header = 'Amount(INR.)';
    } else if (fieldName == 'purprice') {
      header = 'Pur. Price(INR.)';
    } else if (fieldName == 'units') {
      header = 'Units';
    } else if (fieldName == 'bal_units') {
      header = 'Bal. Units';
    } else if (fieldName == 'curr_nav') {
      header = 'Curr. NAV(INR.)';
    } else if (fieldName == 'curr_unit') {
      header = 'Curr. Unit';
    } else if (fieldName == 'curr_nav_date') {
      header = 'Curr. Nav. Date';
    } else if (fieldName == 'curr_val') {
      header = 'Curr. Val(INR.)';
    }

    return header;
  }
}
