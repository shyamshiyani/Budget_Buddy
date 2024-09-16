import 'package:budget_buddy/controllers/intro_controller.dart';
import 'package:budget_buddy/controllers/theme_controller.dart'; // Import ThemeController
import 'package:budget_buddy/views/screens/Home_screen.dart';
import 'package:budget_buddy/views/screens/Splash_screen.dart';
import 'package:budget_buddy/views/screens/Welcome_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences saveData = await SharedPreferences.getInstance();
  bool isVisted = saveData.getBool('StartedScrrenVistited') ?? false;

  final ThemeController themeController = Get.put(ThemeController());

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(
          ThemeData.light().textTheme,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.robotoTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      themeMode: themeController.themeMode,
      initialRoute: isVisted ? '/SplashScreen' : '/WelcomeScreen',
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/SplashScreen', page: () => const SplashScreen()),
        GetPage(name: '/WelcomeScreen', page: () => WelcomeScreen()),
        GetPage(name: '/HomeScreen', page: () => HomeScreen()),
      ],
    ),
  );
}
