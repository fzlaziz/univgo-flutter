import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/presentation/univ_go_icon_icons.dart';

const blueTheme = 0xff0059ff;
const greyTheme = 0xff808080;

class SearchResultPage extends StatelessWidget {
  final String query;
  final TextEditingController searchController;
  final FocusNode focusNode;

  SearchResultPage(
      {required this.query,
      required this.searchController,
      required this.focusNode}) {
    searchController.text = query;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
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
                        controller: searchController,
                        focusNode: focusNode,
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
                        onSubmitted: (value) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchResultPage(
                                  query: value,
                                  searchController: searchController,
                                  focusNode: focusNode),
                            ),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with actual number of campuses
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${index + 1}',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black,
                                )),
                            const SizedBox(width: 20),
                            Icon(Icons.school, color: Colors.black),
                            const SizedBox(width: 10),
                            // Example logo
                          ],
                        ),
                        title: Text('Nama Kampus $index',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black,
                            )),
                        subtitle: Text('Lokasi Kampus $index',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
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
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with actual number of programs
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Text('${index + 1}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                        title: Text('Nama Prodi $index',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black,
                            )),
                        subtitle: Text('Nama Kampus $index',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.black,
                            )),
                        trailing: Text(
                          'S${index % 3 + 1}', // Example degree (S1, S2, S3)
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
