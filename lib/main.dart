import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/custom_app_bar.dart';
import 'package:univ_go/bottom_navbar.dart';
import 'package:univ_go/home.dart';
import 'package:univ_go/profile.dart';
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
      appBar: CustomAppBar(
        selectedIndex: _selectedIndex,
        backgroundColor: const Color(blueTheme),
        searchController: _searchController,
        focusNode: _focusNode,
        isSearchMode: _isSearchMode,
      ),
      bottomNavigationBar: _isSearchMode
          ? null
          : Container(
              height: 65,
              child: BottomNavBar(
                  selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
            ),
      body: _selectedIndex == 0
          ? Home()
          : _selectedIndex == 1
              ? const Center(
                  child: Text('Cari'),
                )
              : Profile(),
    );
  }
}
