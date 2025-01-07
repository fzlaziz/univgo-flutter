import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePageStyle {
  static final _baseButtonTextStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
  );

  static final _baseButtonStyle = ElevatedButton.styleFrom(
    elevation: 3,
    padding: const EdgeInsets.symmetric(vertical: 20),
    minimumSize: const Size.fromHeight(50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  static final normalButtonTextStyle = _baseButtonTextStyle.copyWith(
    color: Colors.black,
  );

  static final whiteButtonTextStyle = _baseButtonTextStyle.copyWith(
    color: Colors.white,
  );

  static final buttonStyle = _baseButtonStyle.copyWith(
    backgroundColor: WidgetStateProperty.all(Colors.white),
  );

  static final logoutButtonStyle = _baseButtonStyle.copyWith(
    backgroundColor: WidgetStateProperty.all(Colors.redAccent),
  );

  static final profileDetailTextStyle = GoogleFonts.poppins(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  static final profileDetailFieldTextStyle = GoogleFonts.poppins(fontSize: 16);

  static Widget buildCircleAvatar(IconData icon) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey[300],
      child: Icon(
        icon,
        size: 50,
        color: Colors.grey[700],
      ),
    );
  }
}
