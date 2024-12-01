import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/presentation/univ_go_icon_icons.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final Color backgroundColor;
  final TextEditingController searchController;
  final FocusNode focusNode;
  final bool isSearchMode;

  const CustomAppBar({
    super.key,
    required this.selectedIndex,
    required this.backgroundColor,
    required this.searchController,
    required this.focusNode,
    required this.isSearchMode,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70.0),
      child: AppBar(
        toolbarHeight: 70,
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: selectedIndex == 2
            ? Center(
                child: Text(
                  "Profile",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xffffffff),
                  ),
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
                            controller: searchController,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              hintText: "Cari Perguruan Tinggi",
                              hintStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              border: InputBorder.none,
                            ),
                            onTap: () {
                              Get.toNamed("/search", arguments: {
                                "searchController": searchController,
                                "focusNode": focusNode
                              })?.then((_) {
                                searchController.clear();
                                focusNode.unfocus();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70.0);
}
