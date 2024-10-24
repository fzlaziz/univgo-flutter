import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/presentation/univ_go_icon_icons.dart';
import 'package:univ_go/api_data_provider.dart';

const blueTheme = 0xff0059ff;
const greyTheme = 0xff808080;

class SearchResultPage extends StatefulWidget {
  @override
  SearchResultPageState createState() => SearchResultPageState();
  final String value;

  SearchResultPage({required this.value});
}

class SearchResultPageState extends State<SearchResultPage> {
  final ApiDataProvider apiDataProvider = ApiDataProvider();  
  late Future<List<CampusResponse>> response;
  late Future<List<StudyProgramResponse>> responseStudyProgram;

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    response = apiDataProvider.getCampus(widget.value);
    responseStudyProgram = apiDataProvider.getStudyProgram(widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCampusList() {
    return FutureBuilder<List<CampusResponse>>(
      future: response,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
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
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              )),
                          const SizedBox(width: 20),
                          Icon(Icons.school, color: Colors.black),
                          const SizedBox(width: 10),
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
          return Center(child: CircularProgressIndicator());
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
                      side: BorderSide(color: Colors.black),
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
    );
  }
}
