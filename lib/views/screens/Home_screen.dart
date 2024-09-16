import 'package:budget_buddy/controllers/theme_controller.dart';
import 'package:budget_buddy/views/components/Add_Category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/Add_Spendings.dart';
import '../components/Show_Cat_Spen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 3, vsync: this);
  final ThemeController themeController = Get.find();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: const Text(
            "Budget Tracker App",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF7BB8B1),
        // actions: [
        //   IconButton(
        //     icon: Obx(() => Icon(
        //           themeController.isDarkMode.value
        //               ? Icons.dark_mode
        //               : Icons.light_mode,
        //         )),
        //     onPressed: themeController.toggleTheme,
        //     tooltip: 'Toggle Dark Mode',
        //   ),
        // ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFF7F7F0),
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFFF7F7F0),
          labelStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: "Category"),
            Tab(text: "Spending"),
            Tab(text: "All Spending"),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFFF7F7F0),
        child: TabBarView(
          controller: _tabController,
          children: const [
            CategoryComponent(),
            SpendingComponent(),
            ShowSpendingComponent(),
          ],
        ),
      ),
    );
  }
}
