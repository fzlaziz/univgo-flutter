import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/presentation/univ_go_icon_icons.dart';
import 'package:univ_go/const/theme_color.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(
              UnivGoIcon.homeoutline,
              size: 30,
            ),
            label: 'Beranda',
            activeIcon: Icon(
              UnivGoIcon.home,
              size: 30,
            )),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.newspaper_sharp,
            size: 30,
          ),
          label: 'Berita Kampus',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
            size: 30,
          ),
          activeIcon: Icon(
            Icons.person,
            size: 30,
          ),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: const Color(blueTheme),
      unselectedItemColor: const Color(greyTheme),
      onTap: onItemTapped,
      selectedLabelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 13,
      ),
      iconSize: 25,
      unselectedLabelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 13,
      ),
    );
  }
}
