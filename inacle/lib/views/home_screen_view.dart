import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:inacle_app/constants/images.dart';
import 'package:inacle_app/controllers/home_controller.dart';
import 'package:inacle_app/controllers/stock_info_controller.dart';
import 'package:inacle_app/repositories/consolidate_repository.dart';
import 'package:inacle_app/routes.dart';
import 'package:inacle_app/theme.dart';
import 'package:inacle_app/widgets/app_loader.dart';
import 'package:inacle_app/widgets/zoomable_widget.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  // Icon and color mapping for each tile
  static const Map<String, IconData> _tileIcons = {
    'Total Investment': Icons.account_balance_outlined,
    'Market Value': Icons.trending_up_rounded,
    'Total Gain/Loss': Icons.bar_chart_rounded,
    'Abs. Rtn. / XIRR': Icons.percent_rounded,
    'No. of Folios': Icons.folder_outlined,
    'As on Date': Icons.calendar_today_outlined,
  };

  static const Map<String, Color> _tileIconColors = {
    'Total Investment': Color(0xFF5C6BC0),
    'Market Value': Color(0xFF26A69A),
    'Total Gain/Loss': Color(0xFFEF5350),
    'Abs. Rtn. / XIRR': Color(0xFFFF7043),
    'No. of Folios': Color(0xFF7E57C2),
    'As on Date': Color(0xFF42A5F5),
  };

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
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: Image.asset(
                  Images.logo,
                  height: 40.h,
                  width: 100.w,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                icon: const Icon(Icons.logout_rounded, color: AppTheme.textSecondary, size: 22),
                onPressed: () => _showLogoutDialog(context),
              ),
            ),
          ],
        ),
        body: GetBuilder<HomeController>(builder: (homeController) {
          if (homeController.isLoading) {
            return const Center(child: AppLoader());
          }

          return RefreshIndicator(
            color: AppTheme.primaryColor,
            onRefresh: () async {
              await homeController.fetchDashboardDetails();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IFA line
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                    color: Colors.white,
                    child: Image.asset(
                      Images.ifa1,
                      height: 55.h,
                      // width: 100.w,
                    ),
                  ),
                  // Welcome Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(15, 6, 15, 6),
                    color: Colors.white,
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                'Welcome, ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              Text(
                                homeController.clientName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Portfolio Overview Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Portfolio Overview',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Dashboard Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: FutureBuilder<List<GridItem>>(
                      future: homeController.dashboardFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox(
                            height: 200,
                            child: Center(child: AppLoader(size: 32)),
                          );
                        } else if (snapshot.hasError) {
                          return _buildErrorState();
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return _buildEmptyState();
                        }
                  
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            const crossAxisCount = 2;
                            const spacing = 5.0;
                  
                            // Calculate item width based on available space
                            final itemWidth =
                                (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                                    crossAxisCount;
                  
                            // Enforce a minimum height so content fits
                            final itemHeight = 115.0;
                            final aspectRatio = itemWidth / itemHeight;
                  
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: aspectRatio,
                                mainAxisSpacing: spacing,
                                crossAxisSpacing: spacing,
                              ),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final item = snapshot.data![index];
                                return _buildDashboardTile(item);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // const SizedBox(height: 6),

                  // Quick Actions Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Action Tiles
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildActionTile(
                            'SoA Report',
                            Icons.analytics_outlined,
                            const Color(0xFF5C6BC0),
                            () {
                              if (Get.isRegistered<StockInfoController>()) {
                                Get.delete<StockInfoController>();
                              }
                              Get.toNamed(AppRoutes.stockInfo, arguments: 'soa');
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: _buildActionTile(
                            'Portfolio Summary',
                            Icons.account_balance_wallet_outlined,
                            const Color(0xFF26A69A),
                            () {
                              if (!Get.isRegistered<StockInfoController>()) {
                                Get.put(StockInfoController());
                              }
                              showHoldingsDialog(context, Get.find<StockInfoController>());
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: _buildActionTile(
                            'My Portal',
                            Icons.open_in_browser_outlined,
                            const Color(0xFFFF7043),
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                    url: homeController.clientResponse.url ?? '',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),
                  
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDashboardTile(GridItem item) {
    final iconData = _tileIcons[item.header] ?? Icons.info_outline;
    final iconColor = _tileIconColors[item.header] ?? AppTheme.primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(iconData, color: iconColor, size: 14),
              ),
              const Spacer(),
              if (item.header == 'Total Gain/Loss' || item.header == 'Abs. Rtn. / XIRR')
                Icon(
                  _isPositiveValue(item.value) ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                  color: _isPositiveValue(item.value) ? AppTheme.successColor : AppTheme.errorColor,
                  size: 16,
                ),
            ],
          ),
          // const Spacer(),
          const SizedBox(height: 8),
          Text(
            item.header,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          if (item.header == 'Abs. Rtn. / XIRR')
            _buildAbsXirrValue(item.value)
          else
            AutoSizeText(
              item.value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: item.header == 'Total Gain/Loss'
                    ? (_isPositiveValue(item.value) ? AppTheme.successColor : AppTheme.errorColor)
                    : AppTheme.textPrimary,
              ),
              maxLines: 1,
            ),
        ],
      ),
    );
  }

  Widget _buildAbsXirrValue(String value) {
    List<String> values = value.split(' / ');
    String absReturn = values.isNotEmpty ? values[0] : '0.00%';
    String xirr = values.length > 1 ? values[1] : '0.00%';

    return Row(
      children: [
        Flexible(
          child: Text(
            absReturn,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _isPositiveValue(absReturn) ? AppTheme.successColor : AppTheme.errorColor,
            ),
          ),
        ),
        Text(
          ' / ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            xirr,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _isPositiveValue(xirr) ? AppTheme.successColor : AppTheme.errorColor,
            ),
          ),
        ),
      ],
    );
  }

  bool _isPositiveValue(String value) {
    double parsedValue = double.tryParse(value.replaceAll(RegExp(r'[^0-9.-]'), '')) ?? 0.0;
    return parsedValue >= 0;
  }

  Widget _buildActionTile(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh_rounded, size: 40, color: AppTheme.textLight),
            const SizedBox(height: 12),
            Text(
              'Failed to load data',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Pull down to refresh',
              style: TextStyle(color: AppTheme.textLight, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'No data available',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.find<HomeController>().logout();
              },
              child: const Text('Logout', style: TextStyle(color: AppTheme.errorColor)),
            ),
          ],
        );
      },
    );
  }

  void showHoldingsDialog(BuildContext context, StockInfoController stockInfoController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          },
          child: Material(
            type: MaterialType.transparency,
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 56),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: FutureBuilder<Map<String, dynamic>>(
                        future: stockInfoController.fetchHoldings(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: AppLoader(size: 32));
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}',
                                  style: const TextStyle(color: AppTheme.errorColor)),
                            );
                          }

                          List<Map<String, dynamic>> data =
                              List<Map<String, dynamic>>.from(snapshot.data!['data']);
                          String clientName = data.isNotEmpty ? data[0]['Client Name'] ?? '' : '';

                          return ZoomableWidget(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: AppTheme.primaryColor.withOpacity(0.08),
                                  padding: const EdgeInsets.all(14),
                                  child: Text(
                                    'Client: $clientName',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: _buildDataTable(data),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Row(
                      children: [
                        _buildDialogIconButton(Icons.screen_rotation_rounded, () {
                          if (MediaQuery.of(context).orientation == Orientation.portrait) {
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
                        }),
                        const SizedBox(width: 8),
                        _buildDialogIconButton(Icons.close_rounded, () {
                          Navigator.of(context).pop();
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                            DeviceOrientation.portraitDown,
                          ]);
                        }),
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

  Widget _buildDialogIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: AppTheme.textPrimary, size: 20),
        onPressed: onPressed,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
      ),
    );
  }

  DataTable _buildDataTable(List<Map<String, dynamic>> data) {
    const headerStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 12,
    );

    const cellStyle = TextStyle(fontSize: 12, color: AppTheme.textPrimary);
    const numericCellStyle = TextStyle(fontSize: 12, color: AppTheme.textPrimary);

    return DataTable(
      headingRowColor: WidgetStateProperty.all(AppTheme.primaryColor),
      dataRowMinHeight: 44,
      dataRowMaxHeight: 52,
      horizontalMargin: 12,
      columnSpacing: 16,
      columns: const [
        DataColumn(label: Text('Category', style: headerStyle)),
        DataColumn(label: Text('Scheme Name', style: headerStyle)),
        DataColumn(label: Text('Folio Number', style: headerStyle)),
        DataColumn(label: Text('Ref.', style: headerStyle)),
        DataColumn(label: Text('Inv. Since', style: headerStyle)),
        DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('Invested ₹', style: headerStyle))),
        DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('Div. Reinvested ₹', style: headerStyle))),
        DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('Dividend ₹', style: headerStyle))),
        DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('Redemption ₹', style: headerStyle))),
        DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('No. of Units', style: headerStyle))),
        DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('Current NAV ₹', style: headerStyle))),
        DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('Avg Value ₹', style: headerStyle))),
        DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('Market Value ₹', style: headerStyle))),
        DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('Gain/Loss ₹', style: headerStyle))),
        DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('Abs. Rtn (%)', style: headerStyle))),
        DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('No. of Days', style: headerStyle))),
        DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('XIRR (%)', style: headerStyle))),
        DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('W.P (%)', style: headerStyle))),
      ],
      rows: data.map((row) {
        return DataRow(cells: [
          DataCell(Text(row['Category'] ?? '', style: cellStyle)),
          DataCell(Text(row['Scheme Name'] ?? '', style: cellStyle)),
          DataCell(Text(row['Folio Number'] ?? '', style: cellStyle)),
          DataCell(Text(row['ARN'] ?? '', style: cellStyle)),
          DataCell(Text(formatDate(row['Inv. Since'] ?? ''), style: cellStyle)),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(formatValue(row['Investments & Switch Ins (INR.)'] ?? '0'), style: numericCellStyle))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(formatValue(row['Dividend Reinvest'] ?? '0'), style: numericCellStyle))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(formatValue(row['Dividend (INR.)'] ?? '0'), style: numericCellStyle))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(formatValue(row['Redemption'] ?? '0'), style: numericCellStyle))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(formatValue(row['No. of Units'] ?? '0'), style: numericCellStyle))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(formatValue(row['Current NAV (INR.)'] ?? '0'), style: numericCellStyle))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(formatValue(row['Avg. Value (INR.)'] ?? '0'), style: numericCellStyle))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(formatValue(row['Market Value (INR.)'] ?? '0'), style: numericCellStyle))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(
            formatGainLossValue(row['Gain/Loss (INR.)'] ?? '0'),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: _getDynamicColor(row['Gain/Loss (INR.)']),
            ),
          ))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(
            formatPercentage(row['Abs. Ret(%)']),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: _getDynamicColor(row['Abs. Ret(%)']),
            ),
          ))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(formatValue(row['No. of Days'] ?? '0'), style: numericCellStyle))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(
            formatPercentage(row['XIRR (%)']),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: _getDynamicColor(row['XIRR (%)']),
            ),
          ))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(formatValue(row['W.P. (%)'] ?? '0'), style: numericCellStyle))),
        ]);
      }).toList(),
    );
  }

  String formatPercentage(String? value) {
    if (value == null || value.isEmpty) return '0.00%';
    double percentage = double.tryParse(value) ?? 0.0;
    String formattedValue = '${percentage.abs().toStringAsFixed(2)}%';
    return percentage >= 0 ? '+$formattedValue' : '-$formattedValue';
  }

  Color _getDynamicColor(String? value) {
    double parsedValue =
        double.tryParse(value?.replaceAll(RegExp(r'[^0-9.-]'), '') ?? '0') ?? 0.0;
    return parsedValue < 0 ? AppTheme.errorColor : AppTheme.successColor;
  }

  String formatValue(String value) {
    String numericString = value.replaceAll(RegExp(r'[^\d.]'), '');
    double? numericValue = double.tryParse(numericString);
    if (numericValue == null) return '0.00';
    return numericValue.toStringAsFixed(2);
  }

  String formatGainLossValue(String? value) {
    if (value == null || value.isEmpty) return '0.00';
    String cleanedValue = value.replaceAll(RegExp(r'[^0-9+-.]'), '');
    double numericValue = double.tryParse(cleanedValue) ?? 0.0;
    String formattedValue = numericValue.abs().toStringAsFixed(2);
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
  bool containsCurrencySymbol = value.contains('₹');
  String numericString = value.replaceAll(RegExp(r'[^\d.]'), '');
  double? numericValue = double.tryParse(numericString);
  if (numericValue == null) {
    log(value);
    return value;
  }
  String formattedValue = numericValue.toStringAsFixed(2);
  return containsCurrencySymbol ? '₹$formattedValue' : formattedValue;
}

class GridItem extends StatelessWidget {
  final String header;
  final String value;
  // final Color color;

  const GridItem({
    super.key,
    required this.header,
    required this.value,
    // required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 20, color: AppTheme.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'My Portal',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(child: AppLoader()),
          ],
        ),
      ),
    );
  }
}
