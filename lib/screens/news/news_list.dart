import 'package:flutter/material.dart';
import 'package:univ_go/main.dart';
import 'news_detail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/const/theme_color.dart';

class NewsListScreen extends StatelessWidget {
  final List<Map<String, String>> newsItems = [
    {
      "title": "Pendaftar Terus Meningkat, Bukti IISMA menyita Perhatian.",
      "date": "16 September 2024 - 12:50",
      "detail":
          "Jakarta Kemendikbudristek - Program beasiswa IISMA terus menunjukkan popularitasnya dengan lonjakan peserta yang signifikan. "
              "Tercerminkan dari tingginya antusiasme di kalangan mahasiswa, perguruan tinggi dalam negeri dan orang tua terhadap program prestisius ini. Program IISMA adalah hasil kerja sama antara Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi (Kemendikbudristek) dengan Lembaga Pengelola Dana Pendidikan (LPDP) serta Kementerian Keuangan.\n\nDibuka pada tahun 2021, sebanyak 2.551 mahasiswa dengan semangat tinggi mendaftar untuk bergabung dalam program IISMA. Menuju tahun 2022, program ini terus berkembang dengan penambahan jalur program vokasi. Jumlah pendaftar pun meningkat tiga kali lipat, di mana sebanyak 7.522 mahasiswa mendaftar untuk jalur sarjana dan 3.506 mahasiswa bergabung dalam jalur vokasi. \n\nMelangkah ke tahun 2023, antusiasme tetap tinggi dengan 7.714 mahasiswa mendaftar untuk jalur sarjana dan 1.456 mahasiswa bergabung dalam jalur vokasi. Puncaknya, pada tahun 2024 ini, jumlah pendaftar mengalami peningkatan fantastis yaitu sejumlah 15.211 yang terdiri dari 12.268 mahasiswa pendaftar untuk jalur sarjana dan 2.943 mahasiswa pendaftar untuk jalur vokasi. Peningkatan yang pesat ini menegaskan daya tarik dan relevansi program IISMA yang terus memberikan peluang pendidikan berkualitas untuk mahasiswa sarjana maupun vokasi. \n\nProgram IISMA tidak hanya menjadi pilihan utama, tetapi juga menjadi salah satu fondasi dalam memperkuat hubungan bilateral antara pemerintah Indonesia dan negara tujuan perguruan tinggi. Hal ini membuktikan kontribusi IISMA tak terbantahkan dalam memajukan pendidikan Indonesia. Program IISMA akan terus membuktikan kesuksesannya dalam mencapai tujuan dan tetap menjadi pilihan utama bagi mahasiswa Indonesia yang ingin menjelajahi peluang belajar di tingkat internasional. Dengan dukungan penuh dari berbagai pihak, IISMA menjadi landasan krusial dalam mempersiapkan generasi muda Indonesia menghadapi berbagai tantangan global dan revolusi industri 4.0.",
    },
    {
      "title": "Pendaftar Terus Meningkat, Bukti IISMA menyita Perhatian.",
      "date": "16 September 2024 - 12:50",
      "detail":
          "Jakarta Kemendikbudristek - Program beasiswa IISMA terus menunjukkan popularitasnya dengan lonjakan peserta yang signifikan. "
              "Tercerminkan dari tingginya antusiasme di kalangan mahasiswa, perguruan tinggi dalam negeri dan orang tua terhadap program prestisius ini. Program IISMA adalah hasil kerja sama antara Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi (Kemendikbudristek) dengan Lembaga Pengelola Dana Pendidikan (LPDP) serta Kementerian Keuangan.\n\nDibuka pada tahun 2021, sebanyak 2.551 mahasiswa dengan semangat tinggi mendaftar untuk bergabung dalam program IISMA. Menuju tahun 2022, program ini terus berkembang dengan penambahan jalur program vokasi. Jumlah pendaftar pun meningkat tiga kali lipat, di mana sebanyak 7.522 mahasiswa mendaftar untuk jalur sarjana dan 3.506 mahasiswa bergabung dalam jalur vokasi. \n\nMelangkah ke tahun 2023, antusiasme tetap tinggi dengan 7.714 mahasiswa mendaftar untuk jalur sarjana dan 1.456 mahasiswa bergabung dalam jalur vokasi. Puncaknya, pada tahun 2024 ini, jumlah pendaftar mengalami peningkatan fantastis yaitu sejumlah 15.211 yang terdiri dari 12.268 mahasiswa pendaftar untuk jalur sarjana dan 2.943 mahasiswa pendaftar untuk jalur vokasi. Peningkatan yang pesat ini menegaskan daya tarik dan relevansi program IISMA yang terus memberikan peluang pendidikan berkualitas untuk mahasiswa sarjana maupun vokasi. \n\nProgram IISMA tidak hanya menjadi pilihan utama, tetapi juga menjadi salah satu fondasi dalam memperkuat hubungan bilateral antara pemerintah Indonesia dan negara tujuan perguruan tinggi. Hal ini membuktikan kontribusi IISMA tak terbantahkan dalam memajukan pendidikan Indonesia. Program IISMA akan terus membuktikan kesuksesannya dalam mencapai tujuan dan tetap menjadi pilihan utama bagi mahasiswa Indonesia yang ingin menjelajahi peluang belajar di tingkat internasional. Dengan dukungan penuh dari berbagai pihak, IISMA menjadi landasan krusial dalam mempersiapkan generasi muda Indonesia menghadapi berbagai tantangan global dan revolusi industri 4.0.",
    },
    {
      "title": "Pendaftar Terus Meningkat, Bukti IISMA menyita Perhatian.",
      "date": "16 September 2024 - 12:50",
      "detail":
          "Jakarta Kemendikbudristek - Program beasiswa IISMA terus menunjukkan popularitasnya dengan lonjakan peserta yang signifikan. "
              "Tercerminkan dari tingginya antusiasme di kalangan mahasiswa, perguruan tinggi dalam negeri dan orang tua terhadap program prestisius ini. Program IISMA adalah hasil kerja sama antara Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi (Kemendikbudristek) dengan Lembaga Pengelola Dana Pendidikan (LPDP) serta Kementerian Keuangan.\n\nDibuka pada tahun 2021, sebanyak 2.551 mahasiswa dengan semangat tinggi mendaftar untuk bergabung dalam program IISMA. Menuju tahun 2022, program ini terus berkembang dengan penambahan jalur program vokasi. Jumlah pendaftar pun meningkat tiga kali lipat, di mana sebanyak 7.522 mahasiswa mendaftar untuk jalur sarjana dan 3.506 mahasiswa bergabung dalam jalur vokasi. \n\nMelangkah ke tahun 2023, antusiasme tetap tinggi dengan 7.714 mahasiswa mendaftar untuk jalur sarjana dan 1.456 mahasiswa bergabung dalam jalur vokasi. Puncaknya, pada tahun 2024 ini, jumlah pendaftar mengalami peningkatan fantastis yaitu sejumlah 15.211 yang terdiri dari 12.268 mahasiswa pendaftar untuk jalur sarjana dan 2.943 mahasiswa pendaftar untuk jalur vokasi. Peningkatan yang pesat ini menegaskan daya tarik dan relevansi program IISMA yang terus memberikan peluang pendidikan berkualitas untuk mahasiswa sarjana maupun vokasi. \n\nProgram IISMA tidak hanya menjadi pilihan utama, tetapi juga menjadi salah satu fondasi dalam memperkuat hubungan bilateral antara pemerintah Indonesia dan negara tujuan perguruan tinggi. Hal ini membuktikan kontribusi IISMA tak terbantahkan dalam memajukan pendidikan Indonesia. Program IISMA akan terus membuktikan kesuksesannya dalam mencapai tujuan dan tetap menjadi pilihan utama bagi mahasiswa Indonesia yang ingin menjelajahi peluang belajar di tingkat internasional. Dengan dukungan penuh dari berbagai pihak, IISMA menjadi landasan krusial dalam mempersiapkan generasi muda Indonesia menghadapi berbagai tantangan global dan revolusi industri 4.0.",
    },
    {
      "title": "Pendaftar Terus Meningkat, Bukti IISMA menyita Perhatian.",
      "date": "16 September 2024 - 12:50",
      "detail":
          "Jakarta Kemendikbudristek - Program beasiswa IISMA terus menunjukkan popularitasnya dengan lonjakan peserta yang signifikan. "
              "Tercerminkan dari tingginya antusiasme di kalangan mahasiswa, perguruan tinggi dalam negeri dan orang tua terhadap program prestisius ini. Program IISMA adalah hasil kerja sama antara Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi (Kemendikbudristek) dengan Lembaga Pengelola Dana Pendidikan (LPDP) serta Kementerian Keuangan.\n\nDibuka pada tahun 2021, sebanyak 2.551 mahasiswa dengan semangat tinggi mendaftar untuk bergabung dalam program IISMA. Menuju tahun 2022, program ini terus berkembang dengan penambahan jalur program vokasi. Jumlah pendaftar pun meningkat tiga kali lipat, di mana sebanyak 7.522 mahasiswa mendaftar untuk jalur sarjana dan 3.506 mahasiswa bergabung dalam jalur vokasi. \n\nMelangkah ke tahun 2023, antusiasme tetap tinggi dengan 7.714 mahasiswa mendaftar untuk jalur sarjana dan 1.456 mahasiswa bergabung dalam jalur vokasi. Puncaknya, pada tahun 2024 ini, jumlah pendaftar mengalami peningkatan fantastis yaitu sejumlah 15.211 yang terdiri dari 12.268 mahasiswa pendaftar untuk jalur sarjana dan 2.943 mahasiswa pendaftar untuk jalur vokasi. Peningkatan yang pesat ini menegaskan daya tarik dan relevansi program IISMA yang terus memberikan peluang pendidikan berkualitas untuk mahasiswa sarjana maupun vokasi. \n\nProgram IISMA tidak hanya menjadi pilihan utama, tetapi juga menjadi salah satu fondasi dalam memperkuat hubungan bilateral antara pemerintah Indonesia dan negara tujuan perguruan tinggi. Hal ini membuktikan kontribusi IISMA tak terbantahkan dalam memajukan pendidikan Indonesia. Program IISMA akan terus membuktikan kesuksesannya dalam mencapai tujuan dan tetap menjadi pilihan utama bagi mahasiswa Indonesia yang ingin menjelajahi peluang belajar di tingkat internasional. Dengan dukungan penuh dari berbagai pihak, IISMA menjadi landasan krusial dalam mempersiapkan generasi muda Indonesia menghadapi berbagai tantangan global dan revolusi industri 4.0.",
    },
    {
      "title": "Pendaftar Terus Meningkat, Bukti IISMA menyita Perhatian.",
      "date": "16 September 2024 - 12:50",
      "detail":
          "Jakarta Kemendikbudristek - Program beasiswa IISMA terus menunjukkan popularitasnya dengan lonjakan peserta yang signifikan. "
              "Tercerminkan dari tingginya antusiasme di kalangan mahasiswa, perguruan tinggi dalam negeri dan orang tua terhadap program prestisius ini. Program IISMA adalah hasil kerja sama antara Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi (Kemendikbudristek) dengan Lembaga Pengelola Dana Pendidikan (LPDP) serta Kementerian Keuangan.\n\nDibuka pada tahun 2021, sebanyak 2.551 mahasiswa dengan semangat tinggi mendaftar untuk bergabung dalam program IISMA. Menuju tahun 2022, program ini terus berkembang dengan penambahan jalur program vokasi. Jumlah pendaftar pun meningkat tiga kali lipat, di mana sebanyak 7.522 mahasiswa mendaftar untuk jalur sarjana dan 3.506 mahasiswa bergabung dalam jalur vokasi. \n\nMelangkah ke tahun 2023, antusiasme tetap tinggi dengan 7.714 mahasiswa mendaftar untuk jalur sarjana dan 1.456 mahasiswa bergabung dalam jalur vokasi. Puncaknya, pada tahun 2024 ini, jumlah pendaftar mengalami peningkatan fantastis yaitu sejumlah 15.211 yang terdiri dari 12.268 mahasiswa pendaftar untuk jalur sarjana dan 2.943 mahasiswa pendaftar untuk jalur vokasi. Peningkatan yang pesat ini menegaskan daya tarik dan relevansi program IISMA yang terus memberikan peluang pendidikan berkualitas untuk mahasiswa sarjana maupun vokasi. \n\nProgram IISMA tidak hanya menjadi pilihan utama, tetapi juga menjadi salah satu fondasi dalam memperkuat hubungan bilateral antara pemerintah Indonesia dan negara tujuan perguruan tinggi. Hal ini membuktikan kontribusi IISMA tak terbantahkan dalam memajukan pendidikan Indonesia. Program IISMA akan terus membuktikan kesuksesannya dalam mencapai tujuan dan tetap menjadi pilihan utama bagi mahasiswa Indonesia yang ingin menjelajahi peluang belajar di tingkat internasional. Dengan dukungan penuh dari berbagai pihak, IISMA menjadi landasan krusial dalam mempersiapkan generasi muda Indonesia menghadapi berbagai tantangan global dan revolusi industri 4.0.",
    },
    {
      "title": "Pendaftar Terus Meningkat, Bukti IISMA menyita Perhatian.",
      "date": "16 September 2024 - 12:50",
      "detail":
          "Jakarta Kemendikbudristek - Program beasiswa IISMA terus menunjukkan popularitasnya dengan lonjakan peserta yang signifikan. "
              "Tercerminkan dari tingginya antusiasme di kalangan mahasiswa, perguruan tinggi dalam negeri dan orang tua terhadap program prestisius ini. Program IISMA adalah hasil kerja sama antara Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi (Kemendikbudristek) dengan Lembaga Pengelola Dana Pendidikan (LPDP) serta Kementerian Keuangan.\n\nDibuka pada tahun 2021, sebanyak 2.551 mahasiswa dengan semangat tinggi mendaftar untuk bergabung dalam program IISMA. Menuju tahun 2022, program ini terus berkembang dengan penambahan jalur program vokasi. Jumlah pendaftar pun meningkat tiga kali lipat, di mana sebanyak 7.522 mahasiswa mendaftar untuk jalur sarjana dan 3.506 mahasiswa bergabung dalam jalur vokasi. \n\nMelangkah ke tahun 2023, antusiasme tetap tinggi dengan 7.714 mahasiswa mendaftar untuk jalur sarjana dan 1.456 mahasiswa bergabung dalam jalur vokasi. Puncaknya, pada tahun 2024 ini, jumlah pendaftar mengalami peningkatan fantastis yaitu sejumlah 15.211 yang terdiri dari 12.268 mahasiswa pendaftar untuk jalur sarjana dan 2.943 mahasiswa pendaftar untuk jalur vokasi. Peningkatan yang pesat ini menegaskan daya tarik dan relevansi program IISMA yang terus memberikan peluang pendidikan berkualitas untuk mahasiswa sarjana maupun vokasi. \n\nProgram IISMA tidak hanya menjadi pilihan utama, tetapi juga menjadi salah satu fondasi dalam memperkuat hubungan bilateral antara pemerintah Indonesia dan negara tujuan perguruan tinggi. Hal ini membuktikan kontribusi IISMA tak terbantahkan dalam memajukan pendidikan Indonesia. Program IISMA akan terus membuktikan kesuksesannya dalam mencapai tujuan dan tetap menjadi pilihan utama bagi mahasiswa Indonesia yang ingin menjelajahi peluang belajar di tingkat internasional. Dengan dukungan penuh dari berbagai pihak, IISMA menjadi landasan krusial dalam mempersiapkan generasi muda Indonesia menghadapi berbagai tantangan global dan revolusi industri 4.0.",
    },
    {
      "title": "Pendaftar Terus Meningkat, Bukti IISMA menyita Perhatian.",
      "date": "16 September 2024 - 12:50",
      "detail":
          "Jakarta Kemendikbudristek - Program beasiswa IISMA terus menunjukkan popularitasnya dengan lonjakan peserta yang signifikan. "
              "Tercerminkan dari tingginya antusiasme di kalangan mahasiswa, perguruan tinggi dalam negeri dan orang tua terhadap program prestisius ini. Program IISMA adalah hasil kerja sama antara Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi (Kemendikbudristek) dengan Lembaga Pengelola Dana Pendidikan (LPDP) serta Kementerian Keuangan.\n\nDibuka pada tahun 2021, sebanyak 2.551 mahasiswa dengan semangat tinggi mendaftar untuk bergabung dalam program IISMA. Menuju tahun 2022, program ini terus berkembang dengan penambahan jalur program vokasi. Jumlah pendaftar pun meningkat tiga kali lipat, di mana sebanyak 7.522 mahasiswa mendaftar untuk jalur sarjana dan 3.506 mahasiswa bergabung dalam jalur vokasi. \n\nMelangkah ke tahun 2023, antusiasme tetap tinggi dengan 7.714 mahasiswa mendaftar untuk jalur sarjana dan 1.456 mahasiswa bergabung dalam jalur vokasi. Puncaknya, pada tahun 2024 ini, jumlah pendaftar mengalami peningkatan fantastis yaitu sejumlah 15.211 yang terdiri dari 12.268 mahasiswa pendaftar untuk jalur sarjana dan 2.943 mahasiswa pendaftar untuk jalur vokasi. Peningkatan yang pesat ini menegaskan daya tarik dan relevansi program IISMA yang terus memberikan peluang pendidikan berkualitas untuk mahasiswa sarjana maupun vokasi. \n\nProgram IISMA tidak hanya menjadi pilihan utama, tetapi juga menjadi salah satu fondasi dalam memperkuat hubungan bilateral antara pemerintah Indonesia dan negara tujuan perguruan tinggi. Hal ini membuktikan kontribusi IISMA tak terbantahkan dalam memajukan pendidikan Indonesia. Program IISMA akan terus membuktikan kesuksesannya dalam mencapai tujuan dan tetap menjadi pilihan utama bagi mahasiswa Indonesia yang ingin menjelajahi peluang belajar di tingkat internasional. Dengan dukungan penuh dari berbagai pihak, IISMA menjadi landasan krusial dalam mempersiapkan generasi muda Indonesia menghadapi berbagai tantangan global dan revolusi industri 4.0.",
    },
    // Add more news items here if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: const Color(blueTheme),
          centerTitle: true,
          title: Text(
            "Berita",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xffffffff),
            ),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MyApp())))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.separated(
          itemCount: newsItems.length, //jumlah item dari data
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              trailing: Image.asset(
                  'assets/images/iisma_detail.png'), // Move image to the right
              title: Text(
                newsItems[index]['title']!,
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w700),
              ),
              subtitle: Text(newsItems[index]['date']!,
                  style: GoogleFonts.poppins(fontSize: 12)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailScreen(
                      title: newsItems[index]['title']!,
                      date: newsItems[index]['date']!,
                      detail: newsItems[index]['detail']!,
                    ),
                  ),
                );
              },
            );
          },
          separatorBuilder: (context, index) => Divider(
            color: Color(greyTheme),
          ), // Add separator line
        ),
      ),
    );
  }
}
