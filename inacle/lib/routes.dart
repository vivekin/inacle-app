import 'package:get/get.dart';
import 'package:inacle_app/bindings/home_screen_bindings.dart';
import 'package:inacle_app/bindings/login_screen_bindings.dart';
import 'package:inacle_app/bindings/otp_screen_bindings.dart';
import 'package:inacle_app/bindings/report_screen_bindings.dart';
import 'package:inacle_app/bindings/splash_screen_bindings.dart';
import 'package:inacle_app/bindings/stock_info_screen_bindings.dart';
import 'package:inacle_app/views/home_screen_view.dart';
import 'package:inacle_app/views/login_screen_view.dart';
import 'package:inacle_app/views/otp_screen_view.dart';
import 'package:inacle_app/views/report_screen_view.dart';
import 'package:inacle_app/views/splash_screen_view.dart';
import 'package:inacle_app/views/reports_screen_view.dart';

class AppRoutes {

  static const String initial = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String stockInfo = '/stockInfo';
  static const String report = '/report';
  static const String holdings = '/holdings';

  static final routes = [
    GetPage(name: splash, page: () => const SplashScreenView(), binding: SplashBinding()),
    GetPage(name: login, page: () => const LoginPage(), binding: LoginBinding()),
    GetPage(name: otp, page: () => const OTPScreen(), binding: OTPBinding()),
    GetPage(name: home, page: () => const HomeScreen(), binding: HomeBinding()),
    GetPage(name: stockInfo, page: () => const StockSummaryScreen(), binding: StockInfoBinding()),
    GetPage(name: report, page: () => const ReportScreen(), binding: ReportScreenBinding()),
    GetPage(name: holdings, page: () => const StockHoldingsScreen(), binding: ReportScreenBinding()),
    // GetPage(name: '/home', page: () => HomeView()),
  ];
}
