import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/controller/search_result_controller.dart';
import 'package:univ_go/presentation/univ_go_icon_icons.dart';
import 'package:univ_go/models/filter/filter_model.dart';
import 'package:univ_go/components/button/sort_button_widget.dart';
import 'package:univ_go/components/button/filter_button_widget.dart';
import 'package:univ_go/widgets/search_results/campus_list.dart';
import 'package:univ_go/widgets/search_results/study_program_list.dart';
import 'package:univ_go/const/theme_color.dart';

class SearchResultPage extends GetView<SearchResultController> {
  const SearchResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
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
                      child: Obx(() => TextField(
                            decoration: InputDecoration(
                              hintText: controller.showCampus.value
                                  ? 'Cari Kampus'
                                  : 'Cari Program Studi',
                              hintStyle: const TextStyle(color: Colors.black),
                              border: InputBorder.none,
                            ),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            controller: TextEditingController.fromValue(
                                TextEditingValue(
                                    text: controller.searchQuery.value,
                                    selection: TextSelection.collapsed(
                                        offset: controller
                                            .searchQuery.value.length))),
                            onSubmitted: (value) {
                              controller.searchQuery.value = value;
                              controller.searchData();
                            },
                          )),
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
        child: Obx(() => Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(16.0,
                      MediaQuery.of(context).padding.top + 16.0, 16.0, 16.0),
                  color: const Color(blueTheme),
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
                      children: controller.filters.entries.map((entry) {
                        String groupDisplayName = entry.key;
                        List<Filter> filterList = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              groupDisplayName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10.0,
                              runSpacing: 10.0,
                              children: filterList.map((filter) {
                                return Obx(() => FilterButtonWidget(
                                      label: filter.name,
                                      id: filter.id,
                                      group: filter.group,
                                      onToggle: () => controller.toggleFilter(
                                          filter.group, filter.id),
                                      isSelected: controller
                                              .tempSelectedFilters[filter.group]
                                              ?.contains(filter.id) ??
                                          false,
                                      width: controller
                                          .getWidthForGroup(filter.group),
                                    ));
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
                        onPressed: controller.resetFilters,
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
                            color: Color(blueTheme),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: controller.applyFilters,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(blueTheme),
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
            )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 13, right: 20.0, left: 20.0),
            decoration: BoxDecoration(
              color: const Color(blueTheme),
              border: Border.all(width: 0, color: const Color(blueTheme)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: controller.toggleView,
                    child: Obx(() => Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(bottom: 7.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: controller.showCampus.value
                                    ? Colors.white
                                    : Colors.transparent,
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
                        )),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: controller.toggleView,
                    child: Obx(() => Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(bottom: 7.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: !controller.showCampus.value
                                    ? Colors.white
                                    : Colors.transparent,
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
                        )),
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
                          Scaffold.of(context).openEndDrawer();
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
                            child: Obx(() => SortButtonWidget(
                                  label: 'Terdekat',
                                  value: "closer",
                                  isSelected: controller.selectedSort.value ==
                                      'nearest',
                                  onSelected: (isSelected) {
                                    controller.applySort('nearest', isSelected);
                                  },
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Obx(() => SortButtonWidget(
                                  label: 'Terbaik',
                                  value: "rank_score",
                                  isSelected: controller.selectedSort.value ==
                                      'rank_score',
                                  onSelected: (isSelected) {
                                    controller.applySort(
                                        'rank_score', isSelected);
                                  },
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Obx(() => SortButtonWidget(
                                  label: 'UKT Terendah',
                                  value: 'min_single_tuition',
                                  isSelected: controller.selectedSort.value ==
                                      'min_single_tuition',
                                  onSelected: (isSelected) {
                                    controller.applySort(
                                        'min_single_tuition', isSelected);
                                  },
                                )),
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
            child: GetBuilder<SearchResultController>(
              builder: (_) => controller.showCampus.value
                  ? CampusList(
                      response: controller.response,
                      showCampus: controller.showCampus.value,
                      animationController: controller.animationController,
                      onToggleView: controller.toggleView, // Add this line
                    )
                  : StudyProgramList(
                      responseStudyProgram: controller.responseStudyProgram,
                      showCampus: controller.showCampus.value,
                      animationController: controller.animationController,
                      onToggleView: controller.toggleView, // Add this line
                    ),
            ),
          ),
        ],
      ),
      endDrawerEnableOpenDragGesture: false,
    );
  }
}
