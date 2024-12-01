import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/presentation/univ_go_icon_icons.dart';
import 'package:univ_go/services/api_data_provider.dart';
import 'package:univ_go/services/location_service.dart';
import 'package:univ_go/models/filter/filter_model.dart';
import 'package:univ_go/components/button/sort_button_widget.dart';
import 'package:univ_go/components/button/filter_button_widget.dart';
import 'package:univ_go/models/campus/campus_response.dart';
import 'package:univ_go/models/study_program/study_programs_response.dart';
import 'package:univ_go/widgets/search_results/campus_list.dart';
import 'package:univ_go/widgets/search_results/study_program_list.dart';

const blueTheme = 0xff0059ff;
const greyTheme = 0xff808080;

class SearchResultPage extends StatefulWidget {
  @override
  SearchResultPageState createState() => SearchResultPageState();
  final String value;

  const SearchResultPage({required this.value});
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
  bool showCampus = true;
  late Map<String, List<Filter>> filters;
  void _toggleView() {
    setState(() {
      showCampus = !showCampus;
      if (showCampus) {
        response = apiDataProvider.getCampus(_controller.text,
            sortBy: selectedSort, selectedFilters: selectedFilters);
        debugPrint('selectedFilters: $selectedFilters');
      } else {
        responseStudyProgram = apiDataProvider.getStudyProgram(_controller.text,
            sortBy: selectedSort, selectedFilters: selectedFilters);
        debugPrint('selectedFilters: $selectedFilters');
      }
    });
  }

  Future<void> _loadFilters() async {
    final loadedFilters = await apiDataProvider.loadFiltersFromStorage();
    setState(() {
      filters = loadedFilters;
    });
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  double _getWidthForGroup(String group) {
    switch (group) {
      case 'location':
        return 95.0;
      case 'degree_level':
        return 25.0;
      case 'entry_path':
        return 90.0;
      case 'accreditation':
        return 90.0;
      case 'campus_type':
        return 90.0;
      default:
        return 100.0;
    }
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
      if (showCampus) {
        response = apiDataProvider.getCampus(_controller.text,
            sortBy: selectedSort, selectedFilters: selectedFilters);
      } else {
        responseStudyProgram = apiDataProvider.getStudyProgram(_controller.text,
            sortBy: selectedSort, selectedFilters: selectedFilters);
      }
    });
    Get.back();
  }

  void applyFilters() {
    setState(() {
      if (showCampus) {
        response = apiDataProvider.getCampus(_controller.text,
            sortBy: selectedSort, selectedFilters: selectedFilters);
        debugPrint('selectedFilters: $selectedFilters');
      } else {
        responseStudyProgram = apiDataProvider.getStudyProgram(_controller.text,
            sortBy: selectedSort, selectedFilters: selectedFilters);
        debugPrint('selectedFilters: $selectedFilters');
      }
    });
    Get.back();
  }

  void _applySort(String sort, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedSort = sort;
      } else {
        selectedSort = null;
      }
      if (showCampus) {
        response = apiDataProvider.getCampus(_controller.text,
            sortBy: selectedSort, selectedFilters: selectedFilters);
        debugPrint('selectedFilters: $selectedFilters');
      } else {
        responseStudyProgram = apiDataProvider.getStudyProgram(_controller.text,
            sortBy: selectedSort, selectedFilters: selectedFilters);
        debugPrint('selectedFilters: $selectedFilters');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFilters();

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

  @override
  Widget build(BuildContext context) {
    print("rerender");
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          actions: <Widget>[Container()],
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.offAllNamed('/home');
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
                        decoration: InputDecoration(
                          hintText:
                              showCampus ? 'Cari Kampus' : 'Cari Program Studi',
                          hintStyle: const TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        autofocus: false,
                        controller: _controller,
                        onSubmitted: (value) {
                          setState(() {
                            _controller.text = value;
                            if (showCampus) {
                              response = apiDataProvider.getCampus(value,
                                  sortBy: selectedSort,
                                  selectedFilters: selectedFilters);
                            } else {
                              responseStudyProgram =
                                  apiDataProvider.getStudyProgram(value,
                                      sortBy: selectedSort,
                                      selectedFilters: selectedFilters);
                            }
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
                              label: filter.name,
                              id: filter.id,
                              group: filter.group,
                              onSelected: (isSelected) {
                                toggleFilter(filter.group, filter.id);
                              },
                              isSelected: selectedFilters[filter.group]
                                      ?.contains(filter.id) ??
                                  false,
                              width: _getWidthForGroup(filter.group),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 33, 149, 243)),
                      ),
                    ),
                    child: const Text(
                      'Reset Filter',
                      style: TextStyle(
                        color: Color(0xFF0059FF),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0059FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 33, 149, 243)),
                      ),
                    ),
                    child: const Text(
                      'Terapkan Filter',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color(0xFF0059FF),
            padding: const EdgeInsets.only(top: 13, right: 20.0, left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _toggleView();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(bottom: 7.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                showCampus ? Colors.white : Colors.transparent,
                            width: 5.0,
                          ),
                        ),
                      ),
                      child: Text(
                        'Kampus',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _toggleView();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(bottom: 7.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                !showCampus ? Colors.white : Colors.transparent,
                            width: 5.0,
                          ),
                        ),
                      ),
                      child: Text(
                        'Program Studi',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(
                left: 13.0, right: 13.0, bottom: 5, top: 0),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(blueTheme),
                    radius: 20.0,
                    child: Builder(builder: (context) {
                      return IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          _openEndDrawer();
                        },
                        iconSize: 20.0,
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 35,
                    child: VerticalDivider(
                      color: Color(blueTheme),
                      thickness: 2,
                      width: 20,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
          ),
          Expanded(
            child: showCampus
                ? CampusList(
                    response: response,
                    showCampus: showCampus,
                    animationController: _animationController,
                  )
                : StudyProgramList(
                    responseStudyProgram: responseStudyProgram,
                    showCampus: showCampus,
                    animationController: _animationController,
                  ),
          ),
        ],
      ),
      endDrawerEnableOpenDragGesture: false,
    );
  }
}
