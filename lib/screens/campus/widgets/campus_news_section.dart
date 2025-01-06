import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CampusNewsContainer extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;

  const CampusNewsContainer({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

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
                fontSize: 14,
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
    if (snapshot.data?.news == null || snapshot.data!.news!.isEmpty) {
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
            )),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: snapshot.data!.news!.length,
      itemBuilder: (context, index) {
        return NewsListItem(
          news: snapshot.data!.news![index],
          imageUrl: snapshot.data!.galleries != null &&
                  snapshot.data!.galleries!.isNotEmpty
              ? snapshot.data!.galleries![0].fileLocation
              : null,
        );
      },
    );
  }
}

class NewsListItem extends StatelessWidget {
  final dynamic news;
  final String? imageUrl;

  const NewsListItem({
    Key? key,
    required this.news,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          // final newsId = news.id;
          // Handle the onTap event
        },
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
