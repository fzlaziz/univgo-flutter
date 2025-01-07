import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/const/theme_color.dart';
import 'package:univ_go/screens/campus/faculty_detail.dart';
import 'package:univ_go/services/profile_campus/profile_campus_provider.dart';

class ListFaculty extends StatefulWidget {
  final int campusId;

  const ListFaculty({Key? key, required this.campusId}) : super(key: key);

  @override
  State<ListFaculty> createState() => _ListFacultyState();
}

class _ListFacultyState extends State<ListFaculty> {
  final ProfileCampusProvider api = ProfileCampusProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color(blueTheme),
        centerTitle: true,
        title: Text(
          "Fakultas",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: const Color(0xffffffff),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: Column(children: [
          FutureBuilder(
            future: api.getCampusDetail(widget.campusId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  color: Color(blueTheme),
                );
              } else {
                if (snapshot.data != null) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).size.height / 8,
                          child: ListView.builder(
                            itemCount: snapshot.data!.faculties!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 24,
                                      right: -40,
                                      child: Opacity(
                                        opacity: 0.2,
                                        child: Image.asset(
                                          'assets/images/logo.png',
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16.0,
                                          bottom: 12.0,
                                          left: 16.0,
                                          right: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot
                                                .data!.faculties![index].name,
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FacultyDetail(
                                                      facultyId: snapshot.data!
                                                          .faculties![index].id,
                                                      facultyName: snapshot
                                                          .data!
                                                          .faculties![index]
                                                          .name,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: OutlinedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                textStyle: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                ),
                                                side: const BorderSide(
                                                    color: Colors.black),
                                                foregroundColor: Colors.black,
                                              ),
                                              child: const Text('See More'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Text('No data available');
                }
              }
            },
          )
        ])),
      ),
    );
  }
}
