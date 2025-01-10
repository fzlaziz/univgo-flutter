import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/const/theme_color.dart';
import 'package:univ_go/models/news/news.dart';
import 'package:univ_go/models/news/news_detail.dart';
import 'package:univ_go/screens/news/const/news_page_style.dart';
import 'package:univ_go/screens/news/news_detail.dart';
import 'package:univ_go/services/news/news_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';
  String awsUrl = dotenv.env['AWS_URL'] ?? 'http://localhost:8000';
  late Future<List<Berita>> listBerita;
  final NewsProvider apiDataProvider = NewsProvider();
  int _currentPage = 1;
  final int _perPage = 6;
  int _totalPages = 1;

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
      separatorBuilder: (context, index) => NewsStyle.newsListDivider,
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
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                if (berita.excerpt != null && berita.excerpt.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      berita.excerpt.length > 80
                          ? '${berita.excerpt.substring(0, 80)}...'
                          : berita.excerpt,
                      style: NewsStyle.newsListExcerptStyle,
                    ),
                  ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                berita.createdAt != null
                    ? DateFormat('dd MMMM yyyy - HH:mm').format(berita.createdAt)
                    : 'No Date',
                style: NewsStyle.newsListDateStyle,
              ),
            ),
            trailing: ClipRRect(
              child: berita.attachment != null
                  ? Image.network(
                      '$awsUrl/${berita.attachment}',
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/news_placeholder.jpg',
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/news_placeholder.jpg',
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
            ),
            onTap: () async {
              if (!isNavigating) {
                setState(() {
                  isNavigating = true;
                });

                DetailBerita detailBerita =
                    await apiDataProvider.getDetailBerita(berita.id);

                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetail(berita: detailBerita),
                    ),
                  ).then((_) {
                    setState(() {
                      isNavigating = false;
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

    int startPage = _currentPage - 1;
    int endPage = _currentPage + 1;

    if (startPage < 1) {
      startPage = 1;
      endPage = 3;
    }
    if (endPage > _totalPages) {
      endPage = _totalPages;
      startPage = _totalPages - 2;
    }
    if (_totalPages <= 3) {
      startPage = 1;
      endPage = _totalPages;
    }

    List<Widget> pageButtons = [];
    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _currentPage = i;
            });
          },
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: _currentPage == i ? Colors.blue : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$i',
                style: GoogleFonts.poppins(
                  color: _currentPage == i ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _currentPage = 1;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                '<<',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: _currentPage > 1 ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _currentPage > 1
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                  }
                : null,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                '<',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: _currentPage > 1 ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
          ...pageButtons,
          GestureDetector(
            onTap: _currentPage < _totalPages
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                  }
                : null,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                '>',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color:
                      _currentPage < _totalPages ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
          // Last Page Button
          GestureDetector(
            onTap: () {
              setState(() {
                _currentPage = _totalPages;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                '>>',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color:
                      _currentPage < _totalPages ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
          // "Go to Page" Input Field
          const SizedBox(width: 20),
          Row(
            children: [
              Text(
                'Go to : ',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 40,
                child: TextField(
                  onSubmitted: (value) {
                    final page = int.tryParse(value);
                    if (page != null && page > 0 && page <= _totalPages) {
                      setState(() {
                        _currentPage = page;
                      });
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ],
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
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(blueTheme),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: FutureBuilder<List<Berita>>(
          future: listBerita,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final beritaList = snapshot.data!;

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
