import 'package:flutter/material.dart';
import 'package:univ_go/main.dart';
import 'list_akuntansi.dart';
import 'package:google_fonts/google_fonts.dart';

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
        '/list_akuntansi': (context) => ListAkuntansi(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
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
            onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyApp()))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                'assets/images/polines.jpg',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoRow(
                      title: 'Akreditasi',
                      value: 'A',
                    ),
                    InfoRow(
                      title: 'Jenis',
                      value:
                          'Perguruan Tinggi Negeri, Politeknik, Badan Layanan Umum',
                    ),
                    InfoRow(
                      title: 'Biaya Kuliah',
                      value: 'Rp 3.000.000 per-kisaran semester',
                    ),
                    InfoRow(
                      title: 'Tanggal Berdiri',
                      value:
                          '6 Agustus 1982 (sebagai Politeknik Universitas Diponegoro)\n1997 (sebagai Politeknik Negeri Semarang)',
                    ),
                    InfoRow(
                      title: 'Direktur',
                      value: 'Dr. Eni Dwi Wardihani, S.T., M.T.',
                    ),
                    InfoRow(
                      title: 'Kontak',
                      value: '024-7473417',
                    ),
                    InfoRow(
                      title: 'Email',
                      value: 'sekretariat@polines.ac.id',
                    ),
                    InfoRow(
                      title: 'Website',
                      value: 'www.polines.ac.id',
                    ),
                    SizedBox(height: 16),
                    InfoRow(
                      title: 'Alamat',
                      value:
                          'Jalan Prof H Soedarto SH\nTembalang, Semarang,\nKota Semarang, Prov. Jawa Tengah',
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
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    'Masa Studi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Table(
                border: TableBorder.all(
                  color: Colors.grey,
                  width: 1,
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade200,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text('Jenjang',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text('Masa Studi',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                    ],
                  ),
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text('D3')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text('3 tahun')),
                      ),
                    ],
                  ),
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text('D4')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text('4 tahun')),
                      ),
                    ],
                  ),
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text('S2')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text('2.8 tahun')),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildFakultasJurusanTable(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    'Fakultas/Jurusan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Table(
                border: TableBorder.all(
                  color: Colors.grey,
                  width: 1,
                ),
                children: [
                  for (var i = 0; i < jurusanList.length; i++)
                    TableRow(
                      decoration: BoxDecoration(
                        color: i.isEven ? Colors.white : Colors.blue.shade50,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${i + 1}. ${jurusanList[i]}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                if (jurusanList[i] == 'Akuntansi') {
                                  Navigator.pushNamed(
                                      context, '/list_akuntansi');
                                }
                              },
                              child: Text(
                                'details',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
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
