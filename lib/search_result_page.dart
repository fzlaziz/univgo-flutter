import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/presentation/univ_go_icon_icons.dart';
import 'package:univ_go/api_data_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

const blueTheme = 0xff0059ff;
const greyTheme = 0xff808080;

class SearchResultPage extends StatefulWidget {
  @override
  SearchResultPageState createState() => SearchResultPageState();
  final String value;

  SearchResultPage({required this.value});
}

class SearchResultPageState extends State<SearchResultPage>
    with SingleTickerProviderStateMixin {
  final ApiDataProvider apiDataProvider = ApiDataProvider();
  late Future<List<CampusResponse>> response;
  late Future<List<StudyProgramResponse>> responseStudyProgram;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _controller;
  List<String> selectedSorts = [];
  double? userLatitude;
  double? userLongitude;
  String? selectedSort;
  late AnimationController _animationController;

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  void _applyFilter(String sort, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedSort = sort;
      } else {
        selectedSort = null;
      }
      response =
          apiDataProvider.getCampus(_controller.text, sortBy: selectedSort);
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    response = apiDataProvider.getCampus(widget.value);
    responseStudyProgram = apiDataProvider.getStudyProgram(widget.value);
    _loadUserLocation();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    _animationController.dispose();
  }

  Widget _buildPlaceholderCard() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        Color color = ColorTween(
          begin: Colors.grey[300],
          end: Colors.grey[400],
        ).evaluate(_animationController)!;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: const Color.fromARGB(255, 198, 197, 197)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              title: Container(
                width: double.infinity,
                height: 16,
                color: color,
              ),
              subtitle: Container(
                width: double.infinity,
                height: 12,
                color: color,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userLatitude = prefs.getDouble('userLatitude');
      userLongitude = prefs.getDouble('userLongitude');
    });
    if (userLatitude == null || userLongitude == null) {
      await _getCurrentPosition();
      setState(() {
        userLatitude = prefs.getDouble('userLatitude');
        userLongitude = prefs.getDouble('userLongitude');
      });
    }
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        userLatitude = position.latitude;
        userLongitude = position.longitude;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('userLatitude', position.latitude);
      await prefs.setDouble('userLongitude', position.longitude);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Izin Lokasi dimatikan, mohon aktifkan izin lokasi.')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin Lokasi ditolak.')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Izin Lokasi ditolak secara permanen, buka pengaturan untuk mengaktifkan izin lokasi.')));
      return false;
    }
    return true;
  }

  Widget _buildCampusList() {
    return FutureBuilder<List<CampusResponse>>(
      future: response,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => _buildPlaceholderCard(),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Tidak ada kampus yang ditemukan'));
        } else {
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var campus = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: const Color.fromARGB(255, 198, 197, 197)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 20,
                            alignment: Alignment.center,
                            child: Text(
                              '${index + 1}',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          campus.logoPath != null
                              ? Image.network(
                                  campus.logoPath,
                                  width: 30,
                                  height: 40,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.image_not_supported,
                                        color: Colors.black);
                                  },
                                )
                              : Icon(Icons.image_not_supported,
                                  color: Colors.black),
                          const SizedBox(width: 5),
                        ],
                      ),
                      title: Text(campus.name,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          )),
                      subtitle: Text(campus.description,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.black,
                          )),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildStudyProgramList() {
    return FutureBuilder<List<StudyProgramResponse>>(
      future: responseStudyProgram,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => _buildPlaceholderCard(),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Center(child: Text('Tidak ada program studi yang ditemukan')),
              SizedBox(
                height: 25,
              )
            ],
          );
        } else {
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var studyProgram = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: const Color.fromARGB(255, 198, 197, 197)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Text('${index + 1}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black,
                          )),
                      title: Text(studyProgram.name,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          )),
                      subtitle: Text(studyProgram.campus,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.black,
                          )),
                      trailing: Text(
                        studyProgram.degreeLevel,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 14),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          actions: <Widget>[Container()],
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          toolbarHeight: 70,
          backgroundColor: const Color(blueTheme),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(
                      UnivGoIcon.search,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "",
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        autofocus: true,
                        controller: _controller,
                        onSubmitted: (value) {
                          setState(() {
                            _controller.text = value;
                            response = apiDataProvider.getCampus(value);
                            responseStudyProgram =
                                apiDataProvider.getStudyProgram(value);
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
      endDrawer: Drawer(
        width: 300,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                  16.0,
                  MediaQuery.of(context).padding.top + 16.0, // Padding atas
                  16.0,
                  16.0),
              color: const Color(0xFF0059FF),
              child: const Text(
                'Filter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  padding: const EdgeInsets.all(0),
                  children: [
                    const Text(
                      'Lokasi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: const [
                        FilterChipWidget(label: 'Jawa Tengah'),
                        FilterChipWidget(label: 'Jawa Timur'),
                        FilterChipWidget(label: 'Semarang'),
                        FilterChipWidget(label: 'DIY'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Level Studi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: const [
                        FilterChipWidget(label: 'S1'),
                        FilterChipWidget(label: 'S2'),
                        FilterChipWidget(label: 'S3'),
                        FilterChipWidget(label: 'S4'),
                        FilterChipWidget(label: 'D1'),
                        FilterChipWidget(label: 'D2'),
                        FilterChipWidget(label: 'D3'),
                        FilterChipWidget(label: 'D4'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Range UKT',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: const [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'MIN',
                              hintStyle: TextStyle(
                                color: Color(0xFF2196F3), // Warna teks MIN
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF2196F3), // Warna border MIN
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(
                                      0xFF2196F3), // Warna border MIN saat tidak fokus
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(
                                      0xFF928989), // Warna border MIN saat fokus
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'MAX',
                              hintStyle: TextStyle(
                                color: Color(0xFF2196F3), // Warna teks MAX
                              ),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(
                                      0xFF2196F3), // Warna border MAX saat tidak fokus
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(
                                      0xFF928989), // Warna border MAX saat fokus
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Jalur Masuk',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: const [
                        FilterChipWidget(label: 'MANDIRI'),
                        FilterChipWidget(label: 'SNBP'),
                        FilterChipWidget(label: 'BEASISWA'),
                        FilterChipWidget(label: 'UTBK'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Akreditasi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: const [
                        FilterChipWidget(label: 'UNGGUL'),
                        FilterChipWidget(label: 'BAIK SEKALI'),
                        FilterChipWidget(label: 'BAIK'),
                        FilterChipWidget(label: 'TIDAK TERAKREDITASI'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Jenis PTN',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: const [
                        FilterChipWidget(label: 'PTN'),
                        FilterChipWidget(label: 'SWASTA'),
                        FilterChipWidget(label: 'POLITEKNIK'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Tombol Terapkan
                    StatefulButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            IntrinsicHeight(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF0059FF),
                    radius: 20.0,
                    child: Builder(builder: (context) {
                      return IconButton(
                        icon: Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          _openEndDrawer();
                        },
                        iconSize: 20.0, // Ukuran ikon di dalam tombol
                      );
                    }),
                  ),
                  Container(
                    height: 30, // Mengatur tinggi dari vertical divider
                    child: VerticalDivider(
                      color: Color(0xFF0059FF), // Warna garis divider
                      thickness: 2, // Ketebalan garis
                      width: 20, // Lebar garis
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 50, // Set the height for the list
                      child: ListView(
                        scrollDirection:
                            Axis.horizontal, // Horizontal scrolling
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: SortChipWidget(
                              label: 'Terdekat',
                              value: "closer",
                              isSelected: selectedSort == 'nearest',
                              onSelected: (isSelected) {
                                _applyFilter('nearest', isSelected);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: SortChipWidget(
                              label: 'Terbaik',
                              value: "rank_score",
                              isSelected: selectedSort == 'rank_score',
                              onSelected: (isSelected) {
                                _applyFilter('rank_score', isSelected);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: SortChipWidget(
                              label: 'UKT Terendah',
                              value: 'min_single_tuition',
                              isSelected: selectedSort == 'min_single_tuition',
                              onSelected: (isSelected) {
                                _applyFilter('min_single_tuition', isSelected);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: SortChipWidget(
                                label: 'UKT Tertinggi',
                                value: 'max_single_tuition',
                                isSelected:
                                    selectedSort == "max_single_tuition",
                                onSelected: (isSelected) {
                                  _applyFilter(
                                      'max_single_tuition', isSelected);
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Kampus',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            _buildCampusList(),
            const SizedBox(height: 10),
            const Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.black,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Program Studi',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            _buildStudyProgramList(),
          ],
        ),
      ),
      endDrawerEnableOpenDragGesture: false,
    );
  }
}

class StatefulButton extends StatefulWidget {
  @override
  _StatefulButtonState createState() => _StatefulButtonState();
}

class _StatefulButtonState extends State<StatefulButton> {
  bool isApplied = false;

  void toggleButton() {
    setState(() {
      isApplied = !isApplied; // Toggle state
    });
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        toggleButton(); // Call toggle function on press
      },
      child: Text(isApplied ? 'Terapkan' : 'Diterapkan'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        textStyle: const TextStyle(fontSize: 16),
        backgroundColor: isApplied
            ? const Color(0xFF0059FF) // Warna latar belakang saat diterapkan
            : const Color(0xFFFFFFFF), // Warna latar belakang default
        foregroundColor: isApplied
            ? Colors.white // Warna teks saat diterapkan
            : const Color(0xFF0059FF), // Warna teks default
        side: const BorderSide(
          color: Color(0xFF0059FF), // Warna border
        ),
      ),
    );
  }
}

class SortChipWidget extends StatelessWidget {
  final String label;
  final String? value;
  final ValueChanged<bool>? onSelected;
  final bool isSelected;

  const SortChipWidget({
    super.key,
    required this.label,
    this.value,
    this.onSelected,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF0059FF),
        ),
      ),
      selected: isSelected,
      showCheckmark: false,
      backgroundColor: const Color(0xFFFFFFFF),
      selectedColor: const Color(0xFF0059FF),
      onSelected: (selected) {
        if (onSelected != null) {
          onSelected!(selected);
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color.fromARGB(255, 33, 149, 243)),
      ),
    );
  }
}

class FilterChipWidget extends StatefulWidget {
  final String label;
  final String? value;
  final ValueChanged<bool>? onSelected;

  const FilterChipWidget({
    super.key,
    required this.label,
    this.value,
    this.onSelected,
  });

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        widget.label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF0059FF),
        ),
      ),
      selected: isSelected,
      showCheckmark: false,
      backgroundColor: const Color(0xFFFFFFFF),
      selectedColor: const Color(0xFF0059FF),
      onSelected: (selected) {
        setState(() {
          isSelected = selected;
          // Check if onSelected is not null before calling it
          if (widget.onSelected != null) {
            widget.onSelected!(selected);
          }
        });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color.fromARGB(255, 33, 149, 243)),
      ),
    );
  }
}
