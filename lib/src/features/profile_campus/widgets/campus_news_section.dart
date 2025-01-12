import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:univ_go/src/features/news/models/news_detail.dart';
import 'package:univ_go/src/features/news/screens/news_detail.dart';
import 'package:univ_go/src/features/news/services/news_provider.dart';

class CampusNewsContainer extends StatefulWidget {
  final AsyncSnapshot<dynamic> snapshot;

  const CampusNewsContainer({
    super.key,
    required this.snapshot,
  });

  @override
  State<CampusNewsContainer> createState() => _CampusNewsContainerState();
}

class _CampusNewsContainerState extends State<CampusNewsContainer> {
  bool _isLoading = false;
  final NewsProvider apiDataProvider = NewsProvider();

  final String baseUrl = '${dotenv.env['AWS_URL']}/';

  String? _getFullImageUrl(String? attachment) {
    if (attachment == null || attachment.isEmpty) return null;
    if (attachment.startsWith('http://') || attachment.startsWith('https://')) {
      return attachment;
    }
    return '$baseUrl$attachment';
  }

  Future<void> handleNewsPress(dynamic newsItem) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      DetailBerita detailBerita =
          await apiDataProvider.getDetailBerita(newsItem.id);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetail(berita: detailBerita),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error loading news details: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Berita Kampus',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            _buildNewsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    if (widget.snapshot.data?.news == null ||
        widget.snapshot.data!.news!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Tidak ada Berita',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

    return AbsorbPointer(
      absorbing: _isLoading,
      child: Opacity(
        opacity: _isLoading ? 0.5 : 1.0,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.snapshot.data!.news!.length,
          itemBuilder: (context, index) {
            final newsItem = widget.snapshot.data!.news![index];
            return NewsListItem(
              news: newsItem,
              imageUrl: _getFullImageUrl(newsItem.attachment),
              onTap: handleNewsPress,
            );
          },
        ),
      ),
    );
  }
}

class NewsListItem extends StatelessWidget {
  final dynamic news;
  final String? imageUrl;
  final Future<void> Function(dynamic news) onTap;

  const NewsListItem({
    super.key,
    required this.news,
    required this.onTap,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => onTap(news),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "'${news.excerpt}'",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${DateFormat('EEEE, dd MMMM yyyy - HH:mm').format(news.createdAt)} WIB',
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildImage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholderImage();
        },
      );
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Image.asset(
      'assets/images/news_placeholder.jpg',
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    );
  }
}
