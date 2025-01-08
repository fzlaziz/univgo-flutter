import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? style;

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.style,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textSpan = TextSpan(
      text: widget.text,
      style: widget.style ??
          GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.black,
          ),
    );

    final richText = Text.rich(
      textSpan,
      maxLines: isExpanded ? null : widget.maxLines,
      overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 32);

    if (textPainter.didExceedMaxLines) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          richText,
          TextButton(
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
              minimumSize: const Size(0, 50),
            ),
            child: Text(
              isExpanded ? 'Lebih Sedikit' : 'Selengkapnya',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }

    return richText;
  }
}
