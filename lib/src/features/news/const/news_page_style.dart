import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsStyle {
  static final contentTextStyle = GoogleFonts.poppins(
    fontSize: 13,
    fontStyle: FontStyle.normal,
  );

  static final newsListTitleStyle =
      GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold);

  static final newsListDateStyle =
      GoogleFonts.poppins(fontSize: 10, color: Colors.grey[600]);

  static final newsListExcerptStyle =
      GoogleFonts.poppins(fontSize: 10, color: Colors.black);

  static final newsListDivider = Divider(
    color: Colors.grey[300],
    thickness: 1,
    height: 20,
    indent: 10,
    endIndent: 10,
  );
}
