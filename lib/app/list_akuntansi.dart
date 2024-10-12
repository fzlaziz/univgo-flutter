import 'package:flutter/material.dart';
import 'package:univ_go/app/profile_campus.dart';
import 'package:google_fonts/google_fonts.dart';

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
              fontSize: 17,
              fontWeight: FontWeight.w500,
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
            onPressed: () => Navigator.pushReplacementNamed(context, '/')),
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
                14.0),
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
                14.0),
          ],
        ),
      ),
    );
  }

  Widget _buildBoxSection(String title, List<String> items, double fontSize) {
    return Container(
      decoration: BoxDecoration(
        color: Color(blueTheme),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // White background for items
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ), // Rounded bottom corners
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
        style: TextStyle(fontSize: fontSize),
      ),
      tileColor: Colors.white,
      onTap: () {
        // Implement your onTap logic here
      },
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
