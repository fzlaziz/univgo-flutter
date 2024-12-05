import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/screens/news/news_detail.dart';
import 'package:univ_go/services/news/news_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsList extends StatefulWidget {
  static const String routeName = '/berita_page';
  const NewsList({super.key});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';
  String awsUrl = dotenv.env['AWS_URL'] ?? 'http://localhost:8000';
  late Future<List<Berita>> listBerita;
  final NewsProvider apiDataProvider = NewsProvider();
  int _currentPage = 1; // Track current page
  final int _perPage = 6; // Set to 6 items per page
  int _totalPages = 1; // Total number of pages

  // Variabel untuk mengecek status navigasi
  bool isNavigating = false;

  @override
  void initState() {
    super.initState();
    listBerita = apiDataProvider.getBerita();
  }

  Widget _buildListBerita(List<Berita> beritaList) {
    final start = (_currentPage - 1) * _perPage;
    final end = start + _perPage;
    final paginatedList = beritaList.sublist(
        start, end > beritaList.length ? beritaList.length : end);

    return ListView.separated(
      itemCount: paginatedList.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[300],
        thickness: 1,
        height: 20,
        indent: 10,
        endIndent: 10,
      ),
      itemBuilder: (context, index) {
        var berita = paginatedList[index];
        return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  berita.title,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                // Excerpt (Add this line)
                if (berita.excerpt != null && berita.excerpt.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      berita.excerpt.length > 70
                          ? '${berita.excerpt.substring(0, 70)}...'
                          : berita.excerpt, // Display excerpt with overflow
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.black),
                    ),
                  ),
              ],
            ),
            subtitle: Text(
              berita.createdAt != null
                  ? DateFormat('dd MMMM yyyy - HH:mm').format(berita.createdAt)
                  : 'No Date',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
            trailing: ClipRRect(
              child: Image.network(
                berita.attachment != null
                    ? '$awsUrl/${berita.attachment}'
                    : 'https://via.placeholder.com/150',
                width: 120,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 60,
                    width: 80,
                    color: Colors.grey.shade200,
                    child: Icon(Icons.image_not_supported, size: 30),
                  );
                },
              ),
            ),
            onTap: () async {
              // Jika belum ada navigasi yang sedang berlangsung
              if (!isNavigating) {
                setState(() {
                  isNavigating =
                      true; // Menandai bahwa sedang melakukan navigasi
                });

                // Ambil detail berita
                DetailBerita detailBerita =
                    await apiDataProvider.getDetailBerita(berita.id);

                // Jika widget masih ada di dalam tree (menghindari error saat pop/push setelah widget dihapus)
                if (mounted) {
                  // Tutup semua halaman di stack navigasi sebelumnya dan buka halaman detail berita
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetail(berita: detailBerita),
                    ),
                  ).then((_) {
                    // Reset navigasi setelah halaman detail selesai ditampilkan
                    setState(() {
                      isNavigating = false; // Reset setelah navigasi selesai
                    });
                  });
                }
              }
            });
      },
    );
  }

  Widget _buildPagination(int totalItems) {
    _totalPages = (totalItems / _perPage).ceil();

    List<Widget> pageButtons = [];
    // Generate page buttons
    for (int i = 1; i <= _totalPages; i++) {
      pageButtons.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _currentPage = i;
            });
          },
          child: Container(
            width: 40, // Set a fixed width for each button
            height: 40, // Set a fixed height for each button
            decoration: BoxDecoration(
              color: Colors.white, // Set the background to white
              borderRadius: BorderRadius.zero, // Remove rounded corners
              border: Border.all(
                color: _currentPage == i
                    ? Colors.black
                    : Colors
                        .grey.shade400, // Change border color for selected page
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '$i',
                style: TextStyle(
                  color: _currentPage == i
                      ? Colors.black
                      : Colors
                          .black, // Text is black when selected, grey otherwise
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding:
          EdgeInsets.symmetric(vertical: 10), // Padding for the whole container
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Button
          Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
              color: _currentPage > 1 ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.zero, // No rounded corners
              border: Border.all(
                color: _currentPage > 1
                    ? Colors.grey.shade400
                    : Colors.grey.shade400,
                width: 2,
              ),
            ),
            child: TextButton(
              onPressed: _currentPage > 1
                  ? () {
                      setState(() {
                        _currentPage--;
                      });
                    }
                  : null,
              child: Center(
                child: Text(
                  '< Previous',
                  style: TextStyle(
                    color: _currentPage > 1 ? Colors.black : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Page number buttons (1, 2, 3, ...)
          ...pageButtons,
          // Next Button
          Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
              color: _currentPage < _totalPages
                  ? Colors.white
                  : Colors.transparent,
              borderRadius: BorderRadius.zero, // No rounded corners
              border: Border.all(
                color: _currentPage < _totalPages ? Colors.grey : Colors.grey,
                width: 2,
              ),
            ),
            child: TextButton(
              onPressed: _currentPage < _totalPages
                  ? () {
                      setState(() {
                        _currentPage++;
                      });
                    }
                  : null,
              child: Center(
                child: Text(
                  'Next >',
                  style: TextStyle(
                    color:
                        _currentPage < _totalPages ? Colors.black : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Berita',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: FutureBuilder<List<Berita>>(
          future: listBerita,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final beritaList = snapshot.data!;

              // Mengurutkan berita berdasarkan tanggal (terbaru di atas)
              beritaList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

              // Tampilkan data dengan pagination
              return Column(
                children: [
                  Expanded(child: _buildListBerita(beritaList)),
                  _buildPagination(beritaList.length),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
