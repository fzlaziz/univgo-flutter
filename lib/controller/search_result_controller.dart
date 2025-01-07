import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_go/services/search/search_data_provider.dart';
import 'package:univ_go/services/location_service.dart';
import 'package:univ_go/models/filter/filter_model.dart';
import 'package:univ_go/models/campus/campus_response.dart';
import 'package:univ_go/models/study_program/study_programs_response.dart';

class SearchResultController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final SearchDataProvider apiDataProvider = SearchDataProvider();
  final locationService = LocationService(Get.context!);
  final RxString searchQuery = ''.obs;
  final RxBool showCampus = true.obs;
  final Rx<String?> selectedSort = Rx<String?>(null);

  // Temporary filters that will be applied when "Terapkan Filter" is pressed
  final RxMap<String, List<int>> tempSelectedFilters =
      <String, List<int>>{}.obs;

  // Actual applied filters
  final RxMap<String, List<int>> selectedFilters = <String, List<int>>{}.obs;

  final RxMap<String, List<Filter>> filters = <String, List<Filter>>{}.obs;
  late Future<List<CampusResponse>> response;
  late Future<List<StudyProgramResponse>> responseStudyProgram;
  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    locationService.loadUserLocation();
    locationService.updateLocation();

    // Retrieve the argument passed via Get.offNamed
    String initialValue = Get.arguments?['value'] ?? '';
    searchQuery.value = initialValue;
    response = apiDataProvider.getCampus(initialValue);
    responseStudyProgram = apiDataProvider.getStudyProgram(initialValue);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _loadFilters();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  Future<void> _loadFilters() async {
    final loadedFilters = await apiDataProvider.loadFiltersFromStorage();
    filters.value = loadedFilters;
  }

  void toggleView() {
    showCampus.toggle();
    searchData();
  }

  void searchData() {
    if (showCampus.value) {
      response = apiDataProvider.getCampus(
        searchQuery.value,
        sortBy: selectedSort.value,
        selectedFilters: selectedFilters,
      );
    } else {
      responseStudyProgram = apiDataProvider.getStudyProgram(
        searchQuery.value,
        sortBy: selectedSort.value,
        selectedFilters: selectedFilters,
      );
    }
    update();
  }

  void toggleFilter(String group, int id) {
    // Create a copy of the current map
    var currentFilters = Map<String, List<int>>.from(tempSelectedFilters);

    if (currentFilters.containsKey(group)) {
      if (currentFilters[group]!.contains(id)) {
        currentFilters[group]!.remove(id);
        if (currentFilters[group]!.isEmpty) {
          currentFilters.remove(group);
        }
      } else {
        currentFilters[group]!.add(id);
      }
    } else {
      currentFilters[group] = [id];
    }

    // Update the entire RxMap
    tempSelectedFilters.value = currentFilters;
  }

  void resetFilters() {
    tempSelectedFilters.clear();
    selectedFilters.clear();
    searchData();
    Get.back();
  }

  void applyFilters() {
    // Replace actual selected filters with temporary filters
    selectedFilters.clear();
    selectedFilters.addAll(tempSelectedFilters);

    // Perform search with new filters
    searchData();
    Get.back();
  }

  void applySort(String sort, bool isSelected) {
    selectedSort.value = isSelected ? sort : null;
    searchData();
  }

  double getWidthForGroup(String group) {
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
}
