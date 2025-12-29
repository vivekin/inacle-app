import 'dart:developer';
import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:inacle_app/common/hex_color.dart';
import 'package:inacle_app/constants/images.dart';
import 'package:inacle_app/controllers/home_controller.dart';
import 'package:inacle_app/controllers/stock_info_controller.dart';
import 'package:inacle_app/repositories/consolidate_repository.dart';
import 'package:inacle_app/routes.dart';
import 'package:inacle_app/widgets/zoomable_widget.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ConsolidateRepository());
    Get.lazyPut(() => HomeController());
    Get.put(() => StockInfoController());
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
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      HexColor("#ffe2d0").withOpacity(0.8),
                      HexColor("#a98d7c").withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              title: Container(
                margin: EdgeInsets.only(top: 16.h, left: 16.w),
                child: Image.asset(
                  Images.logo,
                  height: 45.58.h,
                  width: 145.03.w,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.black, size: 20.sp),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Logout'),
                          content:
                              const Text('Are you sure you want to logout?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();

                                Get.find<HomeController>().logout();
                              },
                              child: const Text('Logout'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ]),
          body: GetBuilder<HomeController>(builder: (homeController) {
            return homeController.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Client : ${homeController.clientName}',
                        style: const TextStyle(fontFamily: 'Roboto'),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 2.0),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await homeController.fetchDashboardDetails();
                          },
                          child: FutureBuilder<List<GridItem>>(
                            future: homeController.dashboardFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: Container(
                                    color: Colors.yellow,
                                    width: Get.width,
                                    height: Get.height * 0.5,
                                    child: const Center(
                                        child: Text(
                                      'Failed to Load Data',
                                      style: TextStyle(fontFamily: 'Roboto'),
                                    )),
                                  ),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('No data available',
                                        style:
                                            TextStyle(fontFamily: 'Roboto')));
                              } else {
                                return GridView.count(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.5, //1.8,
                                  children: snapshot.data!.map((item) {
                                    return GridItem(
                                      header: item.header,
                                      value: item.value,
                                      color: item.color,
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.2, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (Get.isRegistered<StockInfoController>()) {
                                  Get.delete<StockInfoController>();
                                }

                                Get.toNamed(AppRoutes.stockInfo,
                                    arguments: 'summary');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0XFF514c6a), // Button background color
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 12.0),
                                textStyle: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                foregroundColor: Colors.white, // Font color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Reduced border radius
                                ),
                                elevation: 10.0, // Increased elevation
                              ),
                              child: Text(
                                'Summary',
                                style: TextStyle(
                                    fontSize: 20.0.sp, fontFamily: 'Roboto'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.2, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (!Get.isRegistered<StockInfoController>()) {
                                  Get.put(StockInfoController());
                                }
                                showHoldingsDialog(
                                    context, Get.find<StockInfoController>());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0XFF514c6a), // Button background color
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 12.0),
                                textStyle: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                foregroundColor: Colors.white, // Font color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Reduced border radius
                                ),
                                elevation: 10.0, // Increased elevation
                              ),
                              child: Text(
                                'Holdings',
                                style: TextStyle(
                                    fontSize: 20.0.sp, fontFamily: 'Roboto'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.2, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewScreen(
                                        url:
                                            homeController.clientResponse.url ??
                                                ''),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0XFF514c6a), // Button background color
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 12.0),
                                textStyle: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                foregroundColor: Colors.white, // Font color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Reduced border radius
                                ),
                                elevation: 10.0, // Increased elevation
                              ),
                              child: Text(
                                'My Portal',
                                style: TextStyle(
                                    fontSize: 20.0.sp, fontFamily: 'Roboto'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]);
          })),
    );
  }

  void showHoldingsDialog(
    BuildContext context,
    StockInfoController stockInfoController,
  ) {
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
              type: MaterialType.transparency,
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 60,
                          right:
                              0), // Adjust padding to avoid close button area
                      child: SizedBox(
                        height:
                            MediaQuery.of(context).size.height, // Screen height
                        width:
                            MediaQuery.of(context).size.width, // Screen width
                        child: FutureBuilder<Map<String, dynamic>>(
                          future: stockInfoController
                              .fetchHoldings(), // Your function to fetch data
                          builder: (BuildContext context,
                              AsyncSnapshot<Map<String, dynamic>> snapshot) {
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
                              return Text(
                                'Error: ${snapshot.error}',
                                style: const TextStyle(fontFamily: 'Roboto'),
                              );
                            } else {
                              List<Map<String, dynamic>> data =
                                  List<Map<String, dynamic>>.from(
                                      snapshot.data!['data']);
                              List<Map<String, dynamic>> total =
                                  List<Map<String, dynamic>>.from(
                                      snapshot.data!['total']);

                              String clientName = data.isNotEmpty
                                  ? data[0]['Client Name'] ?? ''
                                  : '';

                              return ZoomableWidget(
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      color: Colors.blue.shade100,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Client Name: $clientName',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade900,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: DataTable(
                                            headingRowColor:
                                                WidgetStateProperty.all(
                                                    Colors.blue), // Blue header
                                            columns: const [
                                              DataColumn(
                                                  label: Text('Category',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('Scheme Name',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('Folio Number',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('Ref',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('Inv. Since',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text(
                                                      'Investments & Switch Ins (INR.)',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text(
                                                      'Dividend Reinvest',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('Dividend (INR.)',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('Redemption',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('No of Units',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text(
                                                      'Current NAV (INR.)',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text(
                                                      'Avg Value (INR.)',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text(
                                                      'Market Value (INR.)',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text(
                                                      'Gain/Loss (INR.)',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('Abs. Ret (%)',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('No of Days',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('XIRR (%)',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('W.P (%)',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Colors.white))),
                                            ],
                                            rows: [
                                              ...data.map((row) {
                                                return DataRow(cells: [
                                                  DataCell(Text(
                                                      row['Category'] ?? '',
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Roboto'))),
                                                  DataCell(Text(
                                                      row['Scheme Name'] ?? '',
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Roboto'))),
                                                  DataCell(Text(
                                                      row['Folio Number'] ?? '',
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Roboto'))),
                                                  DataCell(Text(
                                                      row['ARN'] ?? '',
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Roboto'))),
                                                  DataCell(Text(
                                                      formatDate(
                                                          row['Inv. Since'] ??
                                                              ''),
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Roboto'))),
                                                  DataCell(Text(
                                                      formatValue(
                                                          row['Investments & Switch Ins (INR.)'] ??
                                                              '0'),
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Roboto'))),
                                                  DataCell(Text(
                                                      formatValue(
                                                          row['Dividend Reinvest'] ??
                                                              '0'),
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Roboto'))),
                                                  DataCell(Text(
                                                      formatValue(
                                                          row['Dividend (INR.)'] ??
                                                              '0'),
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Roboto'))),
                                                  DataCell(Text(
                                                      formatValue(
                                                          row['Redemption'] ??
                                                              '0'),
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Roboto'))),
                                                  DataCell(Text(
                                                      formatValue(
                                                          row['No. of Units'] ??
                                                              '0'),
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Roboto'))),
                                                  DataCell(Text(
                                                      formatValue(
                                                          row['Current NAV (INR.)'] ??
                                                              '0'),
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Roboto'))),
                                                  DataCell(Text(
                                                      formatValue(
                                                          row['Avg Value (INR.)'] ??
                                                              '0'),
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Roboto'))),
                                                  DataCell(Text(
                                                      formatValue(
                                                          row['Market Value (INR.)'] ??
                                                              '0'),
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Roboto'))),

                                                  // Gain/Loss (Dynamically Colored)
                                                  DataCell(Text(
                                                    formatGainLossValue(
                                                        row['Gain/Loss (INR.)'] ??
                                                            '0'),
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _getDynamicColor(row[
                                                          'Gain/Loss (INR.)']),
                                                    ),
                                                  )),

                                                  // Abs. Ret (%) (Dynamically Colored)
                                                  DataCell(Text(
                                                    formatPercentage(
                                                        row['Abs. Ret(%)']),
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _getDynamicColor(
                                                          row['Abs. Ret(%)']),
                                                    ),
                                                  )),

                                                  DataCell(Text(
                                                      formatValue(
                                                          row['No. of Days'] ??
                                                              '0'),
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Roboto'))),

                                                  // XIRR (%) (Dynamically Colored)
                                                  DataCell(Text(
                                                    formatPercentage(
                                                        row['XIRR (%)']),
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _getDynamicColor(
                                                          row['XIRR (%)']),
                                                    ),
                                                  )),

                                                  DataCell(Text(
                                                      formatValue(
                                                          row['W.P. (%)'] ??
                                                              '0'),
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Roboto'))),
                                                ]);
                                              }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    // ],
                    // ),
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

//   String formatValue(String? value) {
//   if (value == null || value.isEmpty) return '₹0.00';
//   return '₹${double.tryParse(value)?.toStringAsFixed(2) ?? '0.00'}';
// }

  String formatPercentage(String? value) {
    if (value == null || value.isEmpty) return '0.00%';

    double percentage = double.tryParse(value) ?? 0.0;
    String formattedValue = '${percentage.abs().toStringAsFixed(2)}%';

    return percentage >= 0 ? '+$formattedValue' : '-$formattedValue';
  }

// Function to determine dynamic text color
  Color _getDynamicColor(String? value) {
    double parsedValue =
        double.tryParse(value?.replaceAll(RegExp(r'[^0-9.-]'), '') ?? '0') ??
            0.0;
    return parsedValue < 0 ? Colors.red : Colors.green;
  }

  String formatValue(String value) {
// Remove any non-numeric characters except the decimal point
    String numericString = value.replaceAll(RegExp(r'[^\d.]'), '');

// Convert to double and format to two decimal places
    double? numericValue = double.tryParse(numericString);
    if (numericValue == null) {
// Handle the case where the string could not be parsed
      return '0.00';
    }
    return numericValue.toStringAsFixed(2);
  }

  String formatGainLossValue(String? value) {
    if (value == null || value.isEmpty) return '₹0.00';

    // Keep numbers, decimal points, and signs (+ or -)
    String cleanedValue = value.replaceAll(RegExp(r'[^0-9+-.]'), '');

    // Convert to double
    double numericValue = double.tryParse(cleanedValue) ?? 0.0;

    // Format to two decimal places
    String formattedValue = '₹${numericValue.abs().toStringAsFixed(2)}';

    // Append '+' or '-' sign
    return numericValue >= 0 ? '+$formattedValue' : '-$formattedValue';
  }

  String formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return 'Invalid date';
    }
  }
}

String formatValue(String value) {
// Check if the value contains the currency symbol
  bool containsCurrencySymbol = value.contains('₹');

// Remove any non-numeric characters except the decimal point
  String numericString = value.replaceAll(RegExp(r'[^\d.]'), '');

// Convert to double and format to two decimal places
  double? numericValue = double.tryParse(numericString);
  if (numericValue == null) {
// Handle the case where the string could not be parsed
    log(value);
    return value;
  }
  String formattedValue = numericValue.toStringAsFixed(2);

// Add the currency prefix if it was present in the original value
  return containsCurrencySymbol ? '₹$formattedValue' : formattedValue;
}

class GridItem extends StatelessWidget {
  final String header;
  final String value;
  final Color color;

  const GridItem({
    super.key,
    required this.header,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Default text color (White for all fields except specific ones)
    Color textColor = Colors.white;

    // Check if the header is one of the 3 fields that need color formatting
    if (header == 'Total Gain/Loss' || header == 'Abs Rtn. / XIRR') {
      if (header == 'Total Gain/Loss') {
        textColor = _getDynamicColor(value); // Apply color change for Gain/Loss
      }
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              header,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
                fontFamily: 'Roboto',
                color: Colors.white, // Header remains white
              ),
            ),
            const SizedBox(height: 8.0),

            // Handling Abs Rtn. / XIRR separately as it has two values
            if (header == 'Abs Rtn. / XIRR') _buildAbsXirrRow(value),
            if (header != 'Abs Rtn. / XIRR')
              AutoSizeText(
                value,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  fontSize: 18.0,
                  color: textColor, // Apply dynamic color only where required
                ),
                maxLines: 2,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbsXirrRow(String value) {
    List<String> values = value.split(' / ');
    String absReturn = values.isNotEmpty ? values[0] : '0.00%';
    String xirr = values.length > 1 ? values[1] : '0.00%';

    Color absReturnColor = _getDynamicColor(absReturn);
    Color xirrColor = _getDynamicColor(xirr);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // Keeps alignment as before
      children: [
        // Abs Return with Flexible to prevent overflow
        Flexible(
          child: AutoSizeText(
            absReturn,
            maxLines: 1,
            minFontSize: 12,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              fontSize: 18.0,
              color: absReturnColor, // Dynamic color for Abs Return
            ),
          ),
        ),

        const SizedBox(width: 4.0), // Keeps spacing consistent

        // Separator "/"
        const Text(
          '/',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            fontSize: 18.0,
            color: Colors.white, // Keeps separator white
          ),
        ),

        const SizedBox(width: 4.0), // Keeps spacing consistent

        // XIRR with Flexible to prevent overflow
        Flexible(
          child: AutoSizeText(
            xirr,
            maxLines: 1,
            minFontSize: 12,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              fontSize: 18.0,
              color: xirrColor, // Dynamic color for XIRR
            ),
          ),
        ),
      ],
    );
  }

  // Function to determine text color dynamically for numeric values
  Color _getDynamicColor(String value) {
    double parsedValue =
        double.tryParse(value.replaceAll(RegExp(r'[^0-9.-]'), '')) ?? 0.0;
    return parsedValue < 0 ? Colors.red : Colors.green;
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
