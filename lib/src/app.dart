import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_go/src/features/home/controller/home_controller.dart';
import 'package:univ_go/src/routes/route.dart';
import 'package:univ_go/src/components/appbar/custom_app_bar.dart';
import 'package:univ_go/src/components/navbar/bottom_navbar.dart';
import 'package:univ_go/src/features/auth/screens/profile.dart';
import 'package:univ_go/src/features/home/screens/home.dart';
import 'package:univ_go/src/features/search/services/search_data_provider.dart';
import 'package:univ_go/src/const/theme_color.dart';

class UnivGoApp extends StatelessWidget {
  const UnivGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Univ Go',
      initialRoute: '/splashscreen',
      getPages: routes,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final TextEditingController _searchController = TextEditingController();
  final SearchDataProvider _apiDataProvider = SearchDataProvider();

  int _selectedIndex = 0;
  bool _isNewsMode = false;
  static const bool _isSearchMode = false;

  final List<Widget> _pages = [
    const Home(),
    const Center(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _apiDataProvider.fetchAndStoreFilters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isNewsMode = false;
    });

    if (index == 1) {
      _handleNewsTab();
    }
  }

  void _handleNewsTab() {
    setState(() => _isNewsMode = true);
    Get.toNamed('/news_list')?.then((_) {
      setState(() {
        _selectedIndex = 0;
        _isNewsMode = false;
      });
    });
  }

  Future<void> _refreshTab() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      if (_selectedIndex == 0) {
        Get.delete<HomeController>(force: true);
        _pages[0] = Home(key: UniqueKey());
        Get.put(HomeController());
      } else if (_selectedIndex == 2) {
        _pages[2] = ProfilePage(key: UniqueKey());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: CustomAppBar(
        selectedIndex: _selectedIndex,
        backgroundColor: const Color(blueTheme),
        searchController: _searchController,
        isSearchMode: _isSearchMode,
      ),
      bottomNavigationBar: _buildBottomNav(context),
      body: _buildBody(),
    );
  }

  Widget? _buildBottomNav(BuildContext context) {
    if (_isNewsMode) return null;

    return SizedBox(
      height: 65,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.white),
          child: BottomNavBar(
              selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _selectedIndex,
      children: _pages.map((widget) {
        return RefreshIndicator(
          onRefresh: _refreshTab,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: widget,
          ),
        );
      }).toList(),
    );
  }
}
