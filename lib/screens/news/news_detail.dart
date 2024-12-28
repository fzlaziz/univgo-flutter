import 'package:flutter/material.dart';
import 'package:univ_go/const/theme_color.dart';
import 'package:univ_go/models/news/news_comment.dart';
import 'package:univ_go/models/news/news_detail.dart';
import 'package:univ_go/services/news/news_provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsDetail extends StatefulWidget {
  final DetailBerita berita;

  const NewsDetail({required this.berita});

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';
  String awsUrl = dotenv.env['AWS_URL'] ?? 'http://localhost:8000';
  final TextEditingController _commentController = TextEditingController();
  bool _isCommentValid = false;
  late Future<List<Comment>> _comments;
  int _commentsToShow = 5;
  final FocusNode _commentFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _comments = NewsProvider().fetchComments(widget.berita.id);
    // Tambahkan listener untuk memperbarui validitas komentar
    _commentController.addListener(_validateComment);
  }

  @override
  void dispose() {
    _commentController.dispose();
    // Jangan lupa untuk menghapus listener saat halaman dihapus
    _commentController.removeListener(_validateComment);
    super.dispose();
  }

  // Fungsi untuk mengecek apakah komentar valid
  void _validateComment() {
    setState(() {
      // Memvalidasi apakah kolom komentar tidak kosong
      _isCommentValid = _commentController.text.isNotEmpty;
    });
  }

  //Fungsi untuk mengirim komentar
  Future<bool> _submitComment() async {
    if (_commentController.text.isNotEmpty) {
      try {
        // Mengirimkan komentar dan username ke API
        await NewsProvider().addComment(
          widget.berita.id,
          _commentController.text,
        );

        // Mengambil komentar lagi setelah menambah komentar
        setState(() {
          _comments = NewsProvider().fetchComments(widget.berita.id);
          _commentController.clear(); // Menghapus teks input komentar
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Komentar berhasil dikirim!')),
        );

        return true; // Menandakan pengiriman komentar berhasil
      } catch (e) {
        // Jika terjadi error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim komentar, coba lagi.')),
        );
        return false; // Menandakan pengiriman gagal
      }
    } else {
      // Jika komentar kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Komentar tidak boleh kosong!')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Berita',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(blueTheme),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // Menutup halaman detail dan kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title berita
              Text(
                widget.berita.title,
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),
              // Excerpt berita
              Text(
                widget.berita.excerpt,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontStyle: FontStyle.normal),
              ),
              const SizedBox(height: 16),
              // Tanggal berita
              Text(
                widget.berita.createdAt != null
                    ? DateFormat('dd MMMM yyyy - HH:mm:ss')
                        .format(widget.berita.createdAt)
                    : 'No Date',
                style:
                    GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              // Menampilkan gambar berita jika ada
              Center(
                child: Image.network(
                  widget.berita.attachment != null
                      ? '$awsUrl/${widget.berita.attachment}'
                      : 'https://via.placeholder.com/150', // URL gambar default
                  height: 200, // Menyesuaikan tinggi gambar
                  width: double.infinity, // Lebar gambar mengikuti lebar layar
                  fit: BoxFit.cover, // Agar gambar tetap proporsional
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200, // Menyesuaikan tinggi container
                      width: double.infinity, // Menyesuaikan lebar container
                      color: Colors.grey.shade200, // Warna background opsional
                      child: const Icon(Icons.image_not_supported,
                          size: 100), // Ikon fallback
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Konten berita
              if (widget.berita.content != null &&
                  widget.berita.content!.isNotEmpty)
                Text(
                  widget.berita.content!,
                  style: GoogleFonts.poppins(fontSize: 16),
                  textAlign: TextAlign.justify, // Menambahkan justify alignment
                ),
              if (widget.berita.content == null ||
                  widget.berita.content!.isEmpty)
                Text(
                  'Konten berita tidak tersedia.',
                  style: GoogleFonts.poppins(
                      fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.justify, // Menambahkan justify alignment
                ),
              const SizedBox(
                  height:
                      16), // Menambahkan jarak antara konten berita dan komentar

              // Menampilkan daftar komentar di atas berita terkait
              Text(
                'Komentar',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                  height:
                      8), // Jarak antara judul "Komentar" dan daftar komentar
              FutureBuilder<List<Comment>>(
                future: _comments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Tidak ada komentar.'));
                  } else {
                    // Batasi komentar yang ditampilkan sesuai dengan _commentsToShow
                    final List<Comment> displayedComments =
                        snapshot.data!.take(_commentsToShow).toList();
                    final bool hasMoreComments =
                        snapshot.data!.length > _commentsToShow;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tampilkan komentar tanpa bubble, tetapi dengan batas garis
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: displayedComments
                              .length, // Gunakan displayedComments
                          itemBuilder: (context, index) {
                            final comment = displayedComments[
                                index]; // Ambil komentar berdasarkan index

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4.0), // Jarak antar komentar
                              padding: const EdgeInsets.all(
                                  12.0), // Padding di dalam komentar
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color:
                                        Colors.grey[300]!, // Warna garis bawah
                                    width: 1.0, // Ketebalan garis bawah
                                  ),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Konten rata kiri
                                    children: [
                                      // Nama pengguna
                                      Text(
                                        comment.user
                                            .name, // Menampilkan nama pengguna
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(
                                          height:
                                              4.0), // Jarak antara nama dan teks komentar
                                      // Teks komentar
                                      Text(
                                        comment.text,
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      // Menampilkan teks komentar
                                      const SizedBox(
                                          height:
                                              4.0), // Jarak antara teks komentar dan tanggal
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 0, // Posisikan tanggal di bawah
                                    right: 0, // Posisikan tanggal di kanan
                                    child: Text(
                                      comment.createdAt != null
                                          ? DateFormat('dd MMM yyyy, HH:mm')
                                              .format(comment
                                                  .createdAt!) // Format tanggal
                                          : 'No Date',
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors
                                              .grey[600]), // Warna teks tanggal
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        if (hasMoreComments) // Jika masih ada komentar yang belum ditampilkan
                          Center(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _commentsToShow +=
                                      5; // Tambahkan 3 komentar lagi
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Agar Row tidak mengambil ruang penuh
                                children: [
                                  Text(
                                    'View More',
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                      width: 4), // Jarak antara teks dan ikon
                                  const Icon(
                                    Icons.expand_more,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              // Form untuk menambah komentar
              TextField(
                focusNode: _commentFocus,
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Tulis komentar',
                  floatingLabelStyle: GoogleFonts.poppins(
                      color: _commentFocus.hasFocus
                          ? const Color(blueTheme)
                          : Colors.black),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(blueTheme)),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity, // Tombol memenuhi lebar TextField
                child: ElevatedButton(
                  onPressed: _isCommentValid
                      ? () async {
                          bool isSuccess = await _submitComment();
                          if (isSuccess) {
                            showDialog(
                              context: context,
                              barrierDismissible:
                                  true, // Klik di luar dialog untuk menutup
                              builder: (BuildContext context) {
                                return Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                        const SizedBox(height: 10),
                                        Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            'Berhasil mengirim komentar!',
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Menutup dialog
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.blue,
                                          ),
                                          child: Text(
                                            'OK',
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );

                            // Refresh halaman detail berita
                            setState(() {
                              _comments = NewsProvider()
                                  .fetchComments(widget.berita.id);
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.error,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Gagal mengirim komentar, coba lagi.',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.red,
                                          ),
                                          child: Text(
                                            'OK',
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(blueTheme),
                    foregroundColor:
                        _isCommentValid ? Colors.white : Color(blueTheme),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text('Kirim Komentar', style: GoogleFonts.poppins()),
                ),
              ),

              const SizedBox(height: 24),
              // Judul berita terkait
              Text(
                'Berita Terkait',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Menampilkan berita terkait menggunakan ListView.builder
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    widget.berita.relatedNews.length, // Jumlah berita terkait
                itemBuilder: (context, index) {
                  final related = widget.berita.relatedNews[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          related.title, // Judul berita terkait
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          related.createdAt != null
                              ? DateFormat('dd MMMM yyyy - HH:mm:ss')
                                  .format(related.createdAt)
                              : 'No Date', // Menampilkan tanggal atau 'No Date'
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color:
                                  Colors.grey[600]), // Ringkasan berita terkait
                        ),
                        trailing: Image.network(
                          related.attachment != null
                              ? '$awsUrl/${related.attachment}'
                              : 'https://via.placeholder.com/150', // URL gambar default
                          height: 60, // Menyesuaikan tinggi gambar
                          width: 80, // Lebar gambar mengikuti lebar layar
                          fit: BoxFit.cover, // Agar gambar tetap proporsional
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 60, // Menyesuaikan tinggi container
                              width: 80, // Menyesuaikan lebar container
                              color: Colors
                                  .grey.shade200, // Warna background opsional
                              child: const Icon(Icons.image_not_supported,
                                  size: 30), // Ikon fallback
                            ); // Ikon fallback jika gagal
                          },
                        ),
                        onTap: () {
                          // Navigasi ke halaman DetailBeritaPage untuk berita terkait
                          final relatedBerita = DetailBerita(
                            id: related.id,
                            title: related.title,
                            slug: related.slug,
                            excerpt: related.excerpt,
                            content: related.content,
                            attachment: related.attachment,
                            campusId: related.campusId,
                            createdAt: related.createdAt,
                            relatedNews: [], // Isi dengan berita terkait lainnya jika ada
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NewsDetail(berita: relatedBerita),
                            ),
                          );
                        },
                      ),
                      // Garis pemisah antar berita
                      Divider(
                        color: Colors.grey[300], // Warna garis
                        thickness: 1.0, // Ketebalan garis
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor:
          Colors.white, // Menambahkan background putih untuk seluruh halaman
    );
  }
}
