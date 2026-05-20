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

class VoiceService {
  static final FlutterTts _tts = FlutterTts();

  static Future<void> speak(String text) async {
    var languages = await _tts.getLanguages;
    if (languages.contains("ar-SA")) {
      await _tts.setLanguage("ar-SA");
    } else {
      await _tts.setLanguage("en-US");
    }
    await _tts.setPitch(1.3);
    await _tts.setSpeechRate(0.4);
    await _tts.speak(text);
  }
}

// --- SREEN: HOME ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String namaAnak = "Sholeh";
  bool isDarkMode = false;
  int highScore =0;

  @override
  void initState() {
    super.initState();
    _loadNama();
  }

  void _loadNama() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      namaAnak = prefs.getString('nama_user') ?? "Sholeh";
      highScore =prefs.getInt('high_score') ?? 0;
      isDarkMode = prefs.getBool('dark_mode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
              ? [const Color(0xFF1A1A2E), const Color(0xFF16213E), const Color(0xFF0F3460)]
              : [const Color(0xFFE0F7FA), const Color(0xFFFFFFFF), const Color(0xFFFFF9C4)],
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
                    color: isDarkMode ? Colors.black45 : Colors.white.withOpacity(0.9),
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
                      const SizedBox(height: 5),
                      Text(
                        "🏆 Skor Tertinggi: $highScore",
                        style: GoogleFonts.quicksand(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                      ),
                    ],
                  ),
                ),
              ),

              Switch(
                value: isDarkMode,
                activeColor: Colors.orangeAccent,
                onChanged: (value) async{
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('dark_mode', value);
                  setState(() {
                    isDarkMode = value;
                  });
                },
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
                    _menuCard(context, "Kuis Pintar", "🎁", const Color (0xFF4CAF50), null),
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
      if (title == "Kuis Pintar") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen())
  ).then((_) => _loadNama());
      } else if (target != null) {
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
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2), 
            blurRadius: 10, 
            offset: const Offset(0, 8)
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Menampilkan emoji dengan ukuran pas
          Text(emoji, style: const TextStyle(fontSize: 45)),
          
          // 2. Beri jarak kecil antara emoji dan teks
          const SizedBox(height: 5), 
          
          // 3. Menampilkan judul menu dengan font Bubblegum Sans kesukaanmu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.bubblegumSans(
                fontSize: 20,          // Ukuran huruf pas untuk menu kotak
                color: Colors.black87, // Warna teks abu-abu gelap manis
              ),
            ),
          ),
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


  class HijaiyahScreen extends StatelessWidget {
    const HijaiyahScreen({super.key});

    @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dataHijaiyah = [
      {'h': 'ا', 'n': 'Alif'}, {'h': 'ب', 'n': 'Ba'}, {'h': 'ت', 'n': 'Ta'},
      {'h': 'ت', 'n': 'Tsa'}, {'h': 'ج', 'n': 'Jim'}, {'h': 'ح', 'n': 'Ha'},
      {'h': 'خ', 'n': 'Kho'}, {'h': 'د', 'n': 'Dal'}, {'h': 'ذ', 'n': 'Dzal'},
      {'h': 'ر', 'n': 'Ro'}, {'h': 'ز', 'n': 'Zay'}, {'h': 'س', 'n': 'Sin'},
      {'h': 'ط', 'n': 'Syin'}, {'h': 'ظ', 'n': 'Zho'}, {'h': 'ع', 'n': 'Ain'},
      {'h': 'غ', 'n': 'Ghoin'}, {'h': 'ف', 'n': 'Fa'}, {'h': 'ق', 'n': 'Qof'},
      {'h': 'ك', 'n': 'Kaf'}, {'h': 'ل', 'n': 'Lam'}, {'h': 'م', 'n': 'Mim'},
      {'h': 'ن', 'n': 'Nun'}, {'h': 'و', 'n': 'Wau'}, {'h': 'هـ', 'n': 'Ha'},
      {'h': 'لا', 'n': 'Lam Alif'}, {'h': 'ء', 'n': 'Hamzah'}, {'h': 'ي', 'n': 'Ya'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(title: const Text("Taman Hijaiyah"), backgroundColor: const Color(0xFF48BFE3), foregroundColor: Colors.white),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 15, crossAxisSpacing: 15),
          itemCount: dataHijaiyah.length,
          itemBuilder: (context, i) => InkWell(
            onTap: () => VoiceService.speak(dataHijaiyah[i]['h']!),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                border: Border.all(color: Colors.blue[100]!, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dataHijaiyah[i]['h']!, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF00B4D8))),
                  Text(dataHijaiyah[i]['h']!, style: const TextStyle(fontSize: 14, color: Colors.orange)), 
                ],
              ),
            ),
          ),
        ),
      );
    }
  }



  class DoaScreen extends StatelessWidget {
    const DoaScreen({super.key});

    @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> doaList = [
      {"judul": "Doa Sebelum Makan", "arab": "اللَّهُمَّ بَارِكْ لَنَا فِيمَا رَزَقْتَنَا وَقِنَا عَذَابَ النَّارِ", "latin": "Allahumma barik lana fima razaqtana wa qina 'adzaban nar."},
      {"judul": "Doa Sesudah Makan", "arab": "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ", "latin": "Alhamdulillahilladzi ath' amana wa saqana wa ja' alana muslimin."},
      {"judul": "Doa Sebelum Tidur", "arab": "بِاسْمِكَ اللَّهُمَّ أَحْيَا وَأَمُوتُ", "latin": "Bismika allahummah ahya wa amutu."},
      {"judul": "Doa Bangun Tidur", "arab": "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ", "latin": "Alhamdulillahiladzi ahyana ba'da ma amatana wa ilaihin nusyur."},
      {"judul": "Doa Masuk Kamar Mandi", "arab": "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ", "latin": "Allahummah inni a'udzu bika minal khubutsi wal khabaits."},
      {"judul": "Doa Keluar Kamar Mandi", "arab": "غُفْرَانَكَ الْحَمْدُ لِلَّهِ الَّذِي أَذْهَبَ عَنِّي الْأَذَى وَعَافَانِي", "latin": "Ghufranakal hamdulillahilladzi adza wa 'afani."},
      {"judul": "Doa Berpakaian", "arab": "الْحَمْدُ لِلَّهِ الَّذِي كَسَانِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ", "latin": "Alhamdullahuladzi kasaanii haadzaats-tsauba wa razaqanihi min ghairi haulin minnii wa laa."},
      {"judul": "Doa Bercermin", "arab": "اللَّهُمَّ كَمَا حَسَّنْتَ خَلْقِي فَحَسِّنْ خُلُقِي", "latin": "Allahumma kamaa hassanta khalqi fa hassin khuluqi."},
      {"judul": "Doa Masuk Masjid", "arab": "اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ", "latin": "Allahummaftahli abwaba rahmatika."},
      {"judul": "Doa Keluar Masjid", "arab": "اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ", "latin": "Allahumma innias'aluka min fadlik."},
      {"judul": "Doa Setelah Wudhu", "arab": "أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنْ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ", "latin": "asyhadu alla ilaha illallaahu wahdahu laa syariika lahu,wa asyhadu anna muhammadan'abduhu wa rasuuluhu."},
      {"judul": "Doa Sebelum Belajar", "arab": "رَبِّ زِدْنِي عِلْمًا وَارْزُقْنِي فَهْمًا", "latin": "Rabbi zidni 'ilman warzuqni fahman."},
      {"judul": "Doa Untuk Orang Tua","arab": "رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا", "latin": "Rabbighfirli waliwalidayya warhamhumaa kamaa rabbayaanii shaghiiraa."},
      {"judul": "Doa Kebaikan Dunia Akhirat", "arab": "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ", "latin": "Rabbana aatina fiddunya hasanah wa filakhirati hasanah, wa qinaa adzabannaari."},
      {"judul": "Doa Keluar Rumah", "arab": "بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ", "latin": "Bismillahi tawakkaltu 'alallah,laa hawla wa laa quwwata illaabillaah."},
      {"judul": "Doa Naik Kendaraan", "arab": "سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ", "latin": "Subhaanalladzii sakhkhoro lanaa hadzaa wa maa kunnaa lahu muqriniin, wa innaa ilaa raobbina lamunqolibuun."},
      {"judul": "Doa Ketika Hujan", "arab": "اللَّهُمَّ صَيِّبًا نَافِعًا", "latin": "Allahummah shayyiban nafi'an."},
      {"judul": "Doa Mohon Perlindungan", "arab": "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ", "latin": "A'uudzu bi kalimaatillaahit tammaati min syarri maa khalaq."},
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Hafalan Doa"), backgroundColor: Colors.orangeAccent, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: doaList.length,
        itemBuilder: (context, i) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: const CircleAvatar(backgroundColor: Color(0xFFFFF3E0), child: Text("✨")),
            title: Text(doaList[i]['judul']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0XFFE65100))),
            trailing: const Icon(Icons.play_circle_fill, color: Colors.orangeAccent, size: 30),
            onTap: () {
              VoiceService.speak(doaList[i]['arab']!);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(35))),
                builder: (context) => Container(
                  padding: const EdgeInsets.all(30.3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius:  BorderRadius.circular(10))),
                      const SizedBox(height: 20),
                      Text(doaList[i]['judul']!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
                      const SizedBox(height: 25),
                      Text(doaList[i]['arab']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF40916C))),
                      const SizedBox(height: 20),
                      Text(doaList[i]['latin']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.blueGrey)),
                      const SizedBox(height: 30),
                    ],
                  ),
                ), 
              );
            },
          ),
        ),
      ),
    );
  }
}


class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}
              
class _QuizScreenState extends State<QuizScreen> {
  int skor = 0; 
  int indexSoal = 0;
  final List<Map<String, dynamic>> soal = [
    {"h": "ا", "o": ["Alif", "Ba", "Ta"], "j": "Alif"},
    {"h": "ب", "o": ["Jim", "Ba", "Sin"], "j": "Ba"},
    {"h": "ت", "o": ["Ta", "Tsa", "Alif"],"j": "Ta"},
    {"h": "ج", "o": ["Ha", "Kho", "Jim"], "j": "Jim"},
    {"h": "ي", "o": ["Ya", "Wau", "Nun"], "j": "Ya"},
  ];

  @override
    Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FDF4),
      appBar: AppBar(title: const Text("Main Tebak-tebakan"), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Text("Skor: ⭐ $skor", style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.orange)),
            ),
            const SizedBox(height: 20),
            Text(soal[indexSoal]['h'], style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 30),
            ...soal[indexSoal]['o'].map((opsi) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(18),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green[800],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.green, width: 2))
                  ),
                  onPressed: () {
                    if (opsi == soal[indexSoal]['j']) setState(() { skor += 20; });
                    if (indexSoal < soal.length - 1) {
                      setState(() {indexSoal++; });
                    } else {
                      _showFinishDialog();
                    }
                  },
                  child: Text(opsi, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ),
            )),
          ],
        ),
      ),
    ) ;
  } 

  void _showFinishDialog() async {
    final prefs = await SharedPreferences.getInstance();
    int currentHighScore = prefs.getInt('high_score') ?? 0;

    if (skor > currentHighScore){
      await prefs.setInt('high_score', skor);
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: const Text("Selesai!🎉", textAlign: TextAlign.center),
        content: Text("Skor kamu: $skor\n${skor > currentHighScore ? '🎉 Rekor Baru!' : ''}",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18)
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hebat!"),
            ),
          )
        ],
      ),
    ).then((value) => Navigator.pop(context));
  }
}
