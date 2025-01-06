import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_go/controller/home_controller.dart';
import 'package:univ_go/routes/route.dart';
import 'package:univ_go/components/appbar/custom_app_bar.dart';
import 'package:univ_go/components/navbar/bottom_navbar.dart';
import 'package:univ_go/screens/auth/profile.dart';
import 'package:univ_go/screens/home.dart';
import 'package:univ_go/services/api_data_provider.dart';
import 'package:get/get.dart';
import 'package:univ_go/const/theme_color.dart';
import 'package:timezone/data/latest.dart' as tz;

Future main() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/Poppins/OFL.txt');
    yield LicenseEntryWithLineBreaks(['assets/fonts/Poppins'], license);
  });
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final prefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(prefs, permanent: true);
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  bool _isSearchMode = false;
  ApiDataProvider apiDataProvider = ApiDataProvider();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isSearchMode = false;
    });
    if (index == 1) {
      setState(() {
        _isSearchMode = true;
      });
      Get.toNamed('/search', arguments: {
        "searchController": _selectedIndex,
      })?.then((_) {
        setState(() {
          _selectedIndex = 0;
          _searchController.clear();
          _isSearchMode = false;
        });
      });
    }
  }

  Future<void> _refreshTab() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      if (_selectedIndex == 0) {
        Get.delete<HomeController>(force: true);
        index[0] = Home(key: UniqueKey());
      } else if (_selectedIndex == 2) {
        index[2] = ProfilePage(key: UniqueKey());
      }

      if (_selectedIndex == 0) {
        Get.put(
            HomeController()); // Reinitialize the controller after the rebuild
      }
    });
  }

  @override
  void initState() {
    super.initState();
    apiDataProvider.fetchAndStoreFilters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  var index = [
    const Home(),
    const Center(),
    const ProfilePage(),
  ];

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
      bottomNavigationBar: _isSearchMode
          ? null
          : SizedBox(
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
                      selectedIndex: _selectedIndex,
                      onItemTapped: _onItemTapped),
                ),
              ),
            ),
      body: IndexedStack(
        index: _selectedIndex,
        children: index.map((widget) {
          return RefreshIndicator(
            onRefresh: _refreshTab,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: widget,
            ),
          );
        }).toList(),
      ),
    );
  }
}
