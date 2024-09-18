import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB3DAD4),
              Color(0xFFE6E6E1),
              Color(0xFFF7F7F0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Image-removebg-preview.png',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome to Budget Tracker!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(
                      0xFF7BB8B1), // Match text color with progress indicator
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Track your expenses and manage your budget efficiently.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(
                      0xFF7BB8B1), // Match text color with progress indicator
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences saveData =
                      await SharedPreferences.getInstance();

                  await saveData.setBool('StartedScrrenVistited', true);

                  await Navigator.of(context).pushNamed('/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xFF7BB8B1), // Match button color with progress indicator
                ),
                child: const Text("Get Started"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
