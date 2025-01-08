import 'package:flutter/material.dart';
import 'package:univ_go/models/study_program/study_program.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/const/theme_color.dart';
import 'package:univ_go/services/profile_campus/profile_campus_provider.dart';

class FacultyDetail extends StatefulWidget {
  final int facultyId;
  final String facultyName;

  const FacultyDetail(
      {super.key, required this.facultyId, required this.facultyName});

  @override
  _FacultyDetailState createState() => _FacultyDetailState();
}

class _FacultyDetailState extends State<FacultyDetail> {
  final ProfileCampusProvider apiDataProvider = ProfileCampusProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color(blueTheme),
        centerTitle: true,
        title: Text(
          widget.facultyName,
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
      body: FutureBuilder<StudyProgramList>(
        future: apiDataProvider.getStudyPrograms(widget.facultyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData ||
              snapshot.data!.studyPrograms.isEmpty) {
            return const Center(child: Text('No study programs found.'));
          }

          final studyPrograms = snapshot.data!.studyPrograms;

          final groupedPrograms = groupStudyProgramsByDegree(studyPrograms);

          return ListView(
            children: groupedPrograms.entries.map((entry) {
              final degreeLevel = entry.key;
              final programs = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    padding: const EdgeInsets.only(
                        top: 10, right: 10, left: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                        color: const Color(blueTheme),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0)),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1), // Warna outline
                          width: 1.0,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          degreeLevel,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...programs.map(
                    (program) {
                      return Container(
                        margin: const EdgeInsets.only(
                            right: 16, left: 16, bottom: 0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border(
                            top: BorderSide.none,
                            left: BorderSide(
                              color: Colors.black.withOpacity(0.1),
                              width: 1.0,
                            ),
                            right: BorderSide(
                              color: Colors.black.withOpacity(0.1),
                              width: 1.0,
                            ),
                            bottom: BorderSide(
                              color: Colors.black.withOpacity(0.1),
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${program.name} (${program.accreditation.name})',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Map<String, List<StudyProgram>> groupStudyProgramsByDegree(
      List<StudyProgram> programs) {
    final Map<String, List<StudyProgram>> groupedPrograms = {};
    for (var program in programs) {
      final degreeLevel = program.degreeLevel.name;
      if (groupedPrograms.containsKey(degreeLevel)) {
        groupedPrograms[degreeLevel]!.add(program);
      } else {
        groupedPrograms[degreeLevel] = [program];
      }
    }
    return groupedPrograms;
  }
}
