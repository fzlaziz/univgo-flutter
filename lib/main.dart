import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/presentation/univ_go_icon_icons.dart';
import 'search_page.dart';

const blueTheme = 0xff0059ff;
const greyTheme = 0xff808080;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Univ Go',
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  bool _isSearchMode = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isSearchMode = false;
    });
    if (index == 1) {
      setState(() {
        _isSearchMode = true;
      });
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => SearchPage(
            searchController: _searchController,
            focusNode: _focusNode,
          ),
        ),
      )
          .then((_) {
        setState(() {
          _selectedIndex = 0;
          _searchController.clear();
          _isSearchMode = false;
        });
        _focusNode.unfocus();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _isSearchMode = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          toolbarHeight: 70,
          backgroundColor: const Color(blueTheme),
          centerTitle: true,
          title: _selectedIndex == 2
              ? Center(
                  child: Text(
                    "Profile",
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffffffff)),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Icon(UnivGoIcon.search, color: Colors.black),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _focusNode,
                              decoration: InputDecoration(
                                hintText: "Cari Perguruan Tinggi",
                                hintStyle: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                              ),
                              onTap: () {
                                setState(() {
                                  _isSearchMode = true;
                                });
                                Navigator.of(context)
                                    .push(
                                  MaterialPageRoute(
                                    builder: (context) => SearchPage(
                                      searchController: _searchController,
                                      focusNode: _focusNode,
                                    ),
                                  ),
                                )
                                    .then((_) {
                                  setState(() {
                                    _searchController.clear();
                                    _isSearchMode = false;
                                  });
                                  _focusNode.unfocus();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          elevation: 0,
        ),
      ),
      bottomNavigationBar: _isSearchMode
          ? null
          : Container(
              height: 65,
              child: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      UnivGoIcon.homeoutline,
                    ),
                    activeIcon: Icon(UnivGoIcon.home),
                    label: 'Beranda',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(UnivGoIcon.search),
                    label: 'Cari',
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
                currentIndex: _selectedIndex,
                selectedItemColor: const Color(blueTheme),
                unselectedItemColor: const Color(greyTheme),
                onTap: _onItemTapped,
                selectedLabelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                iconSize: 25,
                unselectedLabelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
      body: _selectedIndex == 0
          ? const Center(
              child: Text('Beranda'),
            )
          : _selectedIndex == 1
              ? const Center(
                  child: Text('Cari'),
                )
              : const Center(
                  child: Text('Profile'),
                ),
    );
  }
}
