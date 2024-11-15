import 'dart:async'; // Tambahkan ini untuk Timer
import 'package:flutter/material.dart';
import 'package:univ_go/main.dart';
import '../study_program/list_akuntansi.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const blueTheme = 0xff0059ff;
const greyTheme = 0xff808080;

void main() {
  runApp(ProfileCampus());
}

class ProfileCampus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainPage(),
        routes: {
          '/home': (context) => MyApp(),
        });
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();
  int activeIndex = 0;
  bool _showMore = false;
  Timer? _timer;

  final List<String> images = [
    'assets/images/polines1.jpg',
    'assets/images/polines2.jpg',
    'assets/images/polines3.jpg',
    'assets/images/polines4.jpg',
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (activeIndex < images.length - 1) {
        activeIndex++;
      } else {
        activeIndex = 0;
      }

      _pageController.animateToPage(
        activeIndex,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color(blueTheme),
        centerTitle: true,
        title: Text(
          "Profile Kampus",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: const Color(0xffffffff),
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushReplacementNamed(context, '/home')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    activeIndex = index;
                  });
                },
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      images[index],
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: images.length,
                effect: WormEffect(
                  activeDotColor: Colors.blue,
                  dotColor: Colors.black,
                  dotHeight: 12,
                  dotWidth: 12,
                ),
                onDotClicked: (index) {
                  _pageController.animateToPage(index,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                },
              ),
            ),
            SizedBox(height: 32),
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Politeknik Negeri Semarang',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '\n\n',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text:
                                'Mulanya POLINES bernama Politeknik UNDIP karena berada dalam naungan Universitas Diponegoro.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '\n\n',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text:
                                'Sejak tahun 1997, Politeknik UNDIP resmi menjadi institusi mandiri yang terpisah dari Universitas Diponegoro sehingga namanya berubah menjadi Politeknik Negeri Semarang.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    if (_showMore) ...[
                      InfoRow(
                        title: 'Jenis',
                        value:
                            'Perguruan Tinggi Negeri, Politeknik, Badan Layanan Umum',
                      ),
                      Divider(),
                      InfoRow(
                        title: 'Biaya Kuliah',
                        value: 'Rp 3.000.000 per-kisaran semester',
                      ),
                      Divider(),
                      InfoRow(
                        title: 'Tanggal Berdiri',
                        value:
                            '6 Agustus 1982 (sebagai Politeknik Universitas Diponegoro)\n1997 (sebagai Politeknik Negeri Semarang)',
                      ),
                      Divider(),
                      InfoRow(
                        title: 'Akreditasi',
                        value: 'A',
                      ),
                      Divider(),
                      InfoRow(
                        title: 'Direktur',
                        value: 'Dr. Eni Dwi Wardihani, S.T., M.T.',
                      ),
                      Divider(),
                      InfoRow(
                        title: 'Kontak',
                        value: '024-7473417',
                      ),
                      Divider(),
                      InfoRow(
                        title: 'Email',
                        value: 'sekretariat@polines.ac.id',
                      ),
                      Divider(),
                      InfoRow(
                        title: 'Website',
                        value: 'www.polines.ac.id',
                      ),
                      Divider(),
                      InfoRow(
                        title: 'Alamat',
                        value:
                            'Jalan Prof H Soedarto SH\nTembalang, Semarang,\nKota Semarang, Prov. Jawa Tengah',
                      ),
                    ],
                    SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _showMore = !_showMore;
                          });
                        },
                        child: Text(
                          _showMore ? 'Show Less' : 'Show More',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
            buildMasaStudiTable(),
            SizedBox(height: 32),
            buildFakultasJurusanTable(context),
          ],
        ),
      ),
    );
  }

  Widget buildMasaStudiTable() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Center(
              child: Text(
                'Masa Studi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Table(
            border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            children: [
              _buildTableRow('Jenjang', 'Masa Studi', isHeader: true),
              _buildTableRow('D3', '3 tahun'),
              _buildTableRow('D4', '4 tahun'),
              _buildTableRow('S2', '2.8 tahun'),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String jenjang, String masaStudi,
      {bool isHeader = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.blue.shade100 : Colors.white,
        borderRadius: isHeader ? BorderRadius.circular(0) : null,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Text(
              jenjang,
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
                color: isHeader ? Colors.black87 : Colors.black,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Text(
              masaStudi,
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
                color: isHeader ? Colors.black87 : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFakultasJurusanTable(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Center(
              child: Text(
                'Fakultas/Jurusan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Table(
            border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            children: [
              _buildFakultasJurusanRow('1. Akuntansi', 'details', context),
              _buildFakultasJurusanRow(
                  '2. Administrasi Bisnis', 'details', context),
              _buildFakultasJurusanRow('3. Teknik Elektro', 'details', context),
              _buildFakultasJurusanRow('4. Teknik Mesin', 'details', context),
              _buildFakultasJurusanRow('5. Teknik Sipil', 'details', context),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildFakultasJurusanRow(
      String fakultas, String details, BuildContext context) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              fakultas,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                if (fakultas.contains("Akuntansi")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ListAkuntansi(), // Use your target page
                    ),
                  );
                }
              },
              child: Text(
                details,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration
                      .underline, // Optional: underline to show clickable
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<String> jurusanList = [
    'Akuntansi',
    'Administrasi Bisnis',
    'Teknik Elektro',
    'Teknik Mesin',
    'Teknik Sipil',
  ];
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '$title:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
