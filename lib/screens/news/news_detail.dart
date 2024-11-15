import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const blueTheme = 0xff0059ff;
const greyTheme = 0xff808080;

class NewsDetailScreen extends StatefulWidget {
  final String title;
  final String date;
  final String detail;

  NewsDetailScreen({
    required this.title,
    required this.date,
    required this.detail,
  });

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  // Daftar untuk menyimpan komentar yang ditulis pengguna
  final List<Map<String, String>> _comments = [
    {
      'username': 'Elizabeth',
      'text':
          'geda gedi geda geda o, skibidi sigma rizz, what the hell is this.'
    },
    {
      'username': 'Your name',
      'text': 'Does everyone really bother to write comments?'
    },
  ];

  // Data berita lain
  final List<Map<String, String>> otherNewsData = [
    {
      'title': 'Pendaftaran Terus Meningkat, Bukti IISMA menyita Perhatian.',
      'date': '16 September 2024 - 12:50',
      'imageUrl': 'assets/images/iisma.png',
    },
    {
      'title': 'Pendaftaran Terus Meningkat, Bukti IISMA menyita Perhatian.',
      'date': '16 September 2024 - 12:50',
      'imageUrl': 'assets/images/iisma.png',
    },
    {
      'title': 'Pendaftaran Terus Meningkat, Bukti IISMA menyita Perhatian.',
      'date': '16 September 2024 - 12:50',
      'imageUrl': 'assets/images/iisma.png',
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: const Color(blueTheme),
          centerTitle: true,
          title: Text(
            "Detail Berita",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xffffffff),
            ),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNewsHeader(),
              SizedBox(height: 16),
              Image.asset(
                  'assets/images/iisma_detail.png'), // Gambar detail berita
              SizedBox(height: 16),
              Text(
                widget.detail,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),

              // Bagian Komentar
              SizedBox(height: 20), // Jarak sebelum bagian komentar
              Text(
                "Komentar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // Menampilkan daftar komentar
              ..._buildComments(),
              SizedBox(height: 16),

              // Input untuk komentar baru
              _buildCommentInput(),

              // Judul untuk berita lainnya
              SizedBox(height: 20), // Jarak sebelum judul berita lainnya
              Text(
                'Baca Lainnya',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              // List berita lainnya
              ListView.builder(
                physics:
                    NeverScrollableScrollPhysics(), // Menghindari scroll di dalam scroll
                shrinkWrap:
                    true, // Mengatur ukuran ListView agar sesuai dengan konten
                itemCount: otherNewsData.length,
                itemBuilder: (context, index) {
                  final news = otherNewsData[index];
                  return ListTile(
                    trailing: Image.asset(news['imageUrl']!),
                    title: Text(news['title']!,
                        style: GoogleFonts.poppins(
                            fontSize: 12, fontWeight: FontWeight.w700)),
                    subtitle: Text(news['date']!,
                        style: GoogleFonts.poppins(fontSize: 12)),
                    onTap: () {
                      // Navigasi ke detail berita lain jika diinginkan
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan header berita
  Widget _buildNewsHeader() {
    return Column(
      children: [
        Center(
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.date,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  // Widget untuk menampilkan daftar komentar
  List<Widget> _buildComments() {
    List<Widget> commentWidgets = [];
    for (var comment in _comments) {
      commentWidgets.add(_buildComment(comment['username']!, comment['text']!));
      commentWidgets.add(SizedBox(height: 8)); // Jarak antar komentar
    }
    return commentWidgets;
  }

  // Widget untuk menampilkan setiap komentar
  Widget _buildComment(String username, String comment) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(comment),
        ],
      ),
    );
  }

  // Widget untuk input komentar
  Widget _buildCommentInput() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: "Your name",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _commentController,
          decoration: InputDecoration(
            labelText: "Tulis Komentar",
            border: OutlineInputBorder(),
          ),
          maxLines: 3, // Membolehkan beberapa baris
        ),
        SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            String name = _nameController.text;
            String comment = _commentController.text;
            if (name.isNotEmpty && comment.isNotEmpty) {
              // Menambahkan komentar baru ke daftar
              setState(() {
                _comments.add({'username': name, 'text': comment});
              });
              _nameController.clear();
              _commentController.clear();
            }
          },
          label: const Text(
            'Kirim Komentar',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(blueTheme),
            padding: EdgeInsets.symmetric(vertical: 20),
            minimumSize: const Size.fromHeight(50), // Make button full width
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
