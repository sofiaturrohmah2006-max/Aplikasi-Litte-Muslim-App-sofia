import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';


void main() {
  runApp(const LittleMuslimApp());
}

class LittleMuslimApp extends StatelessWidget {
  const LittleMuslimApp({super.key});

  @override
   Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Little Muslim',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.bubblegumSansTextTheme().copyWith(
          bodyMedium: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
          bodyLarge: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF72EFDD),
          primary: const Color(0xFF48BFE3),
          secondary: Colors.orangeAccent,
        ),
      ),
      home: const SplashScreen(),
    );
  }
} 

// --- SCREEN: SPLASH SCREEN ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()), 
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF48BFE3), Color(0xFF72EFDD)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20)],
                ),
                child: const Text("🌙", style: TextStyle(fontSize: 80)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Little Muslim",
              style: GoogleFonts.bubblegumSans(
                fontSize: 45,
                color: Colors.white,
                shadows: [const Shadow(color: Colors.black, blurRadius: 10, offset: Offset(2, 2))],
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Halaman Utama (Minggu 2)")));
 }
}
