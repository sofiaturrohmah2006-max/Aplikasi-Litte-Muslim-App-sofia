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

class VoiceServise {
  static final FlutterTts _tts = FlutterTts();

  static Future<void> speak(String text) async {
    var languages = await _tts.getLanguages;
    if (languages.contains ("ar-SA")) {
      await _tts.setLanguage("ar_SA");
    } else {
      await _tts.setLanguage("en-US");
    }
    await _tts.setPitch(1.3);
    await _tts.setSpeechRate(0.4);
    await _tts.speak(text);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String namaAnak = "Sofia";

  @override
  void initState() {
    super.initState();
    _loadNama();
  }

  void _loadNama() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      namaAnak = prefs.getString('nama_user') ?? "Sofia";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Color(0xFFFFFFFF), Color(0xFFFFF9C4)],
          ),
        ),  
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 15)],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundColor: Color(0xFFFFD166),
                        child: Text("👦", style: TextStyle(fontSize: 40)),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Halo Teman Pintar!", style: GoogleFonts.quicksand(fontSize: 14, color: Colors.blueGrey)),
                            Text(namaAnak, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold,color: Color(0xFF0077B6))),
                          ],
                        ),
                      ),
                      const Icon(Icons.auto_awesome, color: Colors.orangeAccent, size:35),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _menuCard(context, "Hijaiyah", "🌈", const Color(0xFF48BFE3), const HijaiyahScreen()),
                    _menuCard(context, "Doa Harian","🤲", const Color(0xFFFF9E00), const DoaScreen()),
                    _menuCard(context, "Kuis Pintar", "🎁", const Color (0xFF4CAF50), const QuizScreen()),
                    _menuCard(context, "Ganti Nama", "🎨", const Color(0xFFF72585), null),
                  ],
                ),
              ),
            ],
          ),
        ),
       ),
     );
    }


  Widget _menuCard(BuildContext context, String title, String emoji, Color color, Widget? target) {
    return InkWell(
      onTap: () {
        if (target != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => target));
        } else {
          _showNameDialog();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: color.withOpacity(0.4), width: 5),
          boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 8))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 55)),
            const SizedBox(height: 10),
            Text(emoji, style: GoogleFonts.bubblegumSans(fontSize: 22, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  void _showNameDialog() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        title: Text("Siapa namamu?", textAlign: TextAlign.center, style: GoogleFonts.bubblegumSans(fontSize: 26)),
        content: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: "Ketik di sini...",
            filled: true,
            fillColor: Colors.blue[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, shape: const StadiumBorder()),
                onPressed: () async {
                  if (controller.text.isNotEmpty) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('nama_user', controller.text);
                    _loadNama();
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: const Text("Simpan 🚀", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      );
    }
  }