import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/presentation/univ_go_icon_icons.dart';
import 'package:univ_go/api_data_provider.dart';
import 'package:univ_go/location_service.dart';
import 'package:univ_go/data/filter_data.dart';
import 'package:univ_go/model/filter_model.dart';
import 'package:univ_go/components/sort_button_widget.dart';
import 'package:univ_go/components/filter_button_widget.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<CampusResponse>> response;
  late Future<List<StudyProgramResponse>> responseStudyProgram;
  late TextEditingController _controller;
  late LocationService locationService;
  late AnimationController _animationController;
  List<String> selectedSorts = [];
  String? selectedSort;
  Map<String, List<int>> selectedFilters = {};

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  void toggleFilter(String group, int id) {
    setState(() {
      if (selectedFilters.containsKey(group)) {
        if (selectedFilters[group]!.contains(id)) {
          selectedFilters[group]!.remove(id);
          if (selectedFilters[group]!.isEmpty) {
            selectedFilters.remove(group);
          }
        } else {
          selectedFilters[group]!.add(id);
        }
      } else {
        selectedFilters[group] = [id];
      }
    });
  }

  void resetFilters() {
    setState(() {
      selectedFilters.clear();
    });
    response = apiDataProvider.getCampus(_controller.text,
        selectedFilters: selectedFilters);
    Navigator.pop(context);
    print("Filters diterapkan: $selectedFilters");
  }

  void applyFilters() {
    setState(() {
      response = apiDataProvider.getCampus(_controller.text,
          selectedFilters: selectedFilters);
    });
    print("Filters diterapkan: $selectedFilters");
    Navigator.pop(context);
  }

  void _applySort(String sort, bool isSelected) {
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
    locationService = LocationService(context);
    locationService.loadUserLocation();
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
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                          hintText: "Cari Kampus",
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
                            response = apiDataProvider.getCampus(value,
                                sortBy: selectedSort);
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
                  children: filters.entries.map((entry) {
                    String groupDisplayName = entry.key;
                    List<Filter> filterList = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          groupDisplayName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: filterList.map((filter) {
                            return FilterButtonWidget(
                              label: filter.label,
                              id: filter.id,
                              group: filter.group,
                              onSelected: (isSelected) {
                                toggleFilter(filter.group, filter.id);
                              },
                              isSelected: selectedFilters[filter.group]
                                      ?.contains(filter.id) ??
                                  false,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: resetFilters,
                    child: const Text(
                      'Reset Filter',
                      style: TextStyle(
                        color: Color(0xFF0059FF),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 33, 149, 243)),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: applyFilters,
                    child: const Text(
                      'Terapkan Filter',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0059FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 33, 149, 243)),
                      ),
                    ),
                  ),
                ],
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
                      height: 35, // Set the height for the list
                      child: ListView(
                        scrollDirection:
                            Axis.horizontal, // Horizontal scrolling
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: SortButtonWidget(
                              label: 'Terdekat',
                              value: "closer",
                              isSelected: selectedSort == 'nearest',
                              onSelected: (isSelected) {
                                _applySort('nearest', isSelected);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: SortButtonWidget(
                              label: 'Terbaik',
                              value: "rank_score",
                              isSelected: selectedSort == 'rank_score',
                              onSelected: (isSelected) {
                                _applySort('rank_score', isSelected);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: SortButtonWidget(
                              label: 'UKT Terendah',
                              value: 'min_single_tuition',
                              isSelected: selectedSort == 'min_single_tuition',
                              onSelected: (isSelected) {
                                _applySort('min_single_tuition', isSelected);
                              },
                            ),
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
