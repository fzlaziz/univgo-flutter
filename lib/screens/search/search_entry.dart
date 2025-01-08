import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/presentation/univ_go_icon_icons.dart';

const blueTheme = 0xff0059ff;
const greyTheme = 0xff808080;

class SearchEntry extends StatelessWidget {
  final TextEditingController searchController;

  const SearchEntry({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    searchController.text = '';
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          automaticallyImplyLeading: true,
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
                    const Icon(UnivGoIcon.search, color: Colors.black),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: searchController,
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
                        onFieldSubmitted: (value) {
                          Get.offNamed(
                            "/search-result",
                            arguments: {"value": value},
                          );
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
      body: const Center(
        child: Text(''),
      ),
    );
  }
}
