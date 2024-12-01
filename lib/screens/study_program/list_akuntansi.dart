import 'package:flutter/material.dart';
import 'package:univ_go/screens/campus/profile_campus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/const/theme_color.dart';

class ListAkuntansi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color(blueTheme),
        centerTitle: true,
        title: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Prodi Akuntansi",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xffffffff),
            ),
          ),
          Text(
            "Politeknik Negeri Semarang",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xffffffff),
            ),
          ),
        ]),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildBoxSection(
              'D3',
              [
                'Keuangan dan Perbankan (A)',
                'Akuntansi (A)',
              ],
              14.0,
            ),
            SizedBox(height: 16.0),
            _buildBoxSection(
              'D4',
              [
                'Keuangan dan Perbankan (B)',
                'Akuntansi Manajerial (B)',
                'Analisis Sistem Informasi',
                'Perbankan Syariah (A)',
                'Komputerisasi Akuntansi (A)',
              ],
              14.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoxSection(String title, List<String> items, double fontSize) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1E88E5),
                  Color(0xFF42A5F5)
                ], // Gradient effect
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize + 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
            ),
            child: Column(
              children:
                  items.map((item) => _buildListItem(item, fontSize)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, double fontSize) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      tileColor: Colors.white,
      onTap: () {},
    );
  }
}

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => MainPage(),
      '/list_akuntansi': (context) => ListAkuntansi(),
    },
  ));
}
