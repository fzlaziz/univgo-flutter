import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_go/components/card/comment_placeholder.dart';
import 'package:univ_go/const/theme_color.dart';
import 'package:univ_go/models/news/news_comment.dart';
import 'package:univ_go/models/news/news_detail.dart';
import 'package:univ_go/screens/news/const/news_page_style.dart';
import 'package:univ_go/screens/news/widgets/news_detail_app_bar.dart';
import 'package:univ_go/services/news/news_provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsDetail extends StatefulWidget {
  final DetailBerita berita;

  const NewsDetail({super.key, required this.berita});

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
  final int _defaultCommentsToShow = 5;
  bool _isSubmittingComment = false;
  final FocusNode _commentFocus = FocusNode();
  int? _userId;

  @override
  void initState() {
    super.initState();
    _comments = NewsProvider().fetchComments(widget.berita.id);
    _commentController.addListener(_validateComment);
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('user_id');
    });
  }

  Future<void> _deleteComment(int commentId) async {
    try {
      final result = await NewsProvider().deleteComment(commentId);

      if (result['success']) {
        setState(() {
          _comments = NewsProvider().fetchComments(widget.berita.id);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentController.removeListener(_validateComment);
    super.dispose();
  }

  void _validateComment() {
    setState(() {
      _isCommentValid = _commentController.text.isNotEmpty;
    });
  }

  Future<bool> _submitComment() async {
    if (_isSubmittingComment) return false;

    setState(() {
      _isSubmittingComment = true;
    });
    _commentFocus.unfocus();
    if (_commentController.text.isNotEmpty) {
      try {
        await NewsProvider().addComment(
          widget.berita.id,
          _commentController.text,
        );

        setState(() {
          _comments = NewsProvider().fetchComments(widget.berita.id);
          _commentController.clear();
          _isSubmittingComment = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Komentar berhasil dikirim!')),
        );

        return true;
      } catch (e) {
        setState(() {
          _isSubmittingComment = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim komentar, coba lagi.')),
        );
        return false;
      }
    } else {
      setState(() {
        _isSubmittingComment = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Komentar tidak boleh kosong!')),
      );
      return false;
    }
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: const Icon(
        Icons.person,
        size: 25,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NewsAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.berita.title,
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                widget.berita.excerpt,
                style: NewsStyle.contentTextStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              Text(
                widget.berita.createdAt != null
                    ? DateFormat('dd MMMM yyyy - HH:mm')
                        .format(widget.berita.createdAt)
                    : 'No Date',
                style:
                    GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Center(
                child: widget.berita.attachment != null
                    ? Image.network(
                        '$awsUrl/${widget.berita.attachment}',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/news_placeholder.jpg',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/news_placeholder.jpg',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 24),
              if (widget.berita.content != null &&
                  widget.berita.content!.isNotEmpty)
                Text(
                  widget.berita.content!,
                  style: NewsStyle.contentTextStyle,
                  textAlign: TextAlign.justify,
                ),
              if (widget.berita.content == null ||
                  widget.berita.content!.isEmpty)
                Text(
                  'Konten berita tidak tersedia.',
                  style: GoogleFonts.poppins(
                      fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.justify,
                ),
              const SizedBox(height: 16),
              Text(
                'Komentar',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<Comment>>(
                future: _comments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CommentPlaceholder();
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada komentar.'));
                  } else {
                    final List<Comment> displayedComments =
                        snapshot.data!.take(_commentsToShow).toList();
                    final bool hasMoreComments =
                        snapshot.data!.length > _commentsToShow;
                    final bool canShowLess =
                        _commentsToShow > _defaultCommentsToShow;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: displayedComments.length,
                          itemBuilder: (context, index) {
                            final comment = displayedComments[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipOval(
                                        child: SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: comment.user.profileImage !=
                                                  null
                                              ? Image.network(
                                                  comment.user.profileImage!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return _buildDefaultAvatar();
                                                  },
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return _buildDefaultAvatar();
                                                  },
                                                )
                                              : _buildDefaultAvatar(),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        comment.user.name,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 13,
                                        ),
                                      ),
                                      if (_userId != null &&
                                          _userId == comment.user.id)
                                        const Spacer(),
                                      if (_userId != null &&
                                          _userId == comment.user.id)
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              size: 16, color: Colors.red),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  title: Text(
                                                    'Konfirmasi',
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    'Apakah Anda yakin ingin menghapus komentar ini?',
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child: Text(
                                                        'Batal',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .grey),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        _deleteComment(
                                                            comment.id);
                                                      },
                                                      child: Text(
                                                        'Hapus',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color:
                                                                    Colors.red),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6.0),
                                  Text(
                                    comment.text,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      textAlign: TextAlign.right,
                                      comment.createdAt != null
                                          ? DateFormat('dd MMM yyyy, HH:mm')
                                              .format(comment.createdAt!)
                                          : 'No Date',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        if (hasMoreComments || canShowLess)
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (canShowLess)
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _commentsToShow =
                                            _defaultCommentsToShow;
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'View Less',
                                          style: GoogleFonts.poppins(
                                              color: Colors.black),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.expand_less,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                if (hasMoreComments && canShowLess)
                                  const SizedBox(width: 16),
                                if (hasMoreComments)
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _commentsToShow += 5;
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'View More',
                                          style: GoogleFonts.poppins(
                                              color: Colors.black),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.expand_more,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                focusNode: _commentFocus,
                controller: _commentController,
                onTapOutside: (event) {
                  _commentFocus.unfocus();
                },
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
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isCommentValid && !_isSubmittingComment)
                      ? () async {
                          bool isSuccess = await _submitComment();
                          if (isSuccess) {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
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
                                            Navigator.of(context).pop();
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
                                        Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            'Gagal mengirim komentar, coba lagi.',
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
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
                    foregroundColor: (_isCommentValid && !_isSubmittingComment)
                        ? Colors.white
                        : const Color(blueTheme),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: _isSubmittingComment
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  (_isCommentValid && !_isSubmittingComment)
                                      ? Colors.white
                                      : const Color(blueTheme),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('Mengirim...', style: GoogleFonts.poppins()),
                          ],
                        )
                      : Text('Kirim Komentar', style: GoogleFonts.poppins()),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Berita Terkait',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              ListView.separated(
                separatorBuilder: (context, index) => NewsStyle.newsListDivider,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.berita.relatedNews.length,
                itemBuilder: (context, index) {
                  final related = widget.berita.relatedNews[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          related.title,
                          style: NewsStyle.newsListTitleStyle,
                        ),
                        if (related.excerpt != null &&
                            related.excerpt.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              related.excerpt.length > 80
                                  ? '${related.excerpt.substring(0, 80)}...'
                                  : related.excerpt,
                              style: NewsStyle.newsListExcerptStyle,
                            ),
                          ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        related.createdAt != null
                            ? DateFormat('dd MMMM yyyy - HH:mm')
                                .format(related.createdAt)
                            : 'No Date',
                        style: NewsStyle.newsListDateStyle,
                      ),
                    ),
                    trailing: related.attachment != null
                        ? Image.network(
                            '$awsUrl/${related.attachment}',
                            height: 60,
                            width: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/news_placeholder.jpg',
                                height: 60,
                                width: 80,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/news_placeholder.jpg',
                            height: 60,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                    onTap: () {
                      final relatedBerita = DetailBerita(
                        id: related.id,
                        title: related.title,
                        slug: related.slug,
                        excerpt: related.excerpt,
                        content: related.content,
                        attachment: related.attachment,
                        campusId: related.campusId,
                        createdAt: related.createdAt,
                        relatedNews: [],
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewsDetail(berita: relatedBerita),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
