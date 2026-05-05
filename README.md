# 🌙 Litte Muslim App - Roadmap Pengembangan 4 Minggu

Blue print ini merupakan panduan tahap demi tahap untuk membangun aplikasi edukasi anak dari nol hingga siap digunakan dalam waktu satu bulan.

---

## 📅 Minggu 1: Fondasi & UI utama (Branding)
**Fokus:** Menentukan identitas visual dan struktur navigasi dasar.

* **Persiapan Lingkaran:** Setup Flutter project dan instalasi dependensi (`google_fonts`, `shared_preferences`, `flutter_tts`).
* **Branding & Tema:** * Implementasi font **Fredoka**
untuk kesan bulat dan ramah anak.
   * Konfigurasi `ColorScheme` dengan warna utama
   `#72EFDD` (Tosca muda) dan `#48BFE3`.
* **Halaman Utama (HomeScreen):** * Membuat layout dashboart menggunakan `GridView`.
  * Implementasi header statis "Halo Sahabat Kecil!".
* **Fitur Personalisasi (v1):** Membuat logic
`_showNameDialog` dan integrasi `SharedPreferences` agar
aplikasi bisa menyapa pengguna secara personal.

---

## 📅 Minggu 2: Modul Pembelajaran (Hijaiyah & Audio)
**Fokus:** Mwmbangun konten edukasi pertama dan integrasi suara.

* **Modul Hijaiyah:** * Memetakan data 30 huruf Hijaiyah ke dalam `List<Map>`.
   * Membuat `HijaiyahScreen` dengan `GridView.builder` 
   yang reponsis.
* **Integrasi Flutter TTS (VoiceService):** * Membangun kelas layasan suara statis.
   * Konfigurasi bahasa `ar-SA` dan pengaturan *pitch*
   tinggi agar suara terdengar seperti karakter anak anak.
* **Interakvitas:** Menghubungkan setiap kartu Hijaiyah sehingga mengeluarkan suara saat diketuk (Metode lihat-dengar).

---

## 📅 Minggu 3: Modul Hafalan doa & UI Detail
**Fokus:** Menambah konten teks yang lebih padat dan manajemen modal.

* **Database Doa:** Menyusun daftar doa harian lengkap dengan teks Arab, Latin, dan terjemahan.
* **Halaman Doa (DoaScreen):** * Implementasi `ListView.builder` dengan `Card` kustom.
   * Desain palet warna yang berbeda (Warm/Cream) untuk membedakan dengan modul Hijaiyah.
* **Detail View (Modal Bottom Sheet):**
    * Menggunakan `showModalBottomSheet` untuk menampilkan detail doa.
    * Menambahkan tombol "Play" untuk mendengarkan pelafalan doa via TTS.

---

## 📅 Minggu 4: Gamifikasi, Debugging & Finishing
**Fokus:** Menambah elemen permainan dan memastikan aplikasi bebar eror.

* **Modul Kuis Pintar (QuizScreen):** * Membuat logika pengacakan soal (`shuffle`) agar kuis tidak membosankan.
    * Sistem skor sederhana (Bintang ⭐).
    * Implementasi dialog "MasyaAllah!" saat kuis selesai.
* **Perbaikan UI (Fix Overflow):** * Optimasi layout menggunakan `SingleChildScrollView` agar aman di layar HP kecil atau saat keyboard muncul.
* **Final Testing:** * Uji coba fitur simpan nama.
    * Pengecekan performa audio di perangkat fisik.
* **Deployment:** Build APK/Bundle untuk rilis awal.

---




