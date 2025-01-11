import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/src/const/theme_color.dart';
import 'package:univ_go/src/features/profile_campus/models/campus_registration_records.dart';
import 'package:univ_go/src/features/profile_campus/widgets/bar_chart_container.dart';

class BarChartSection extends StatelessWidget {
  final List<CampusRegistrationRecord>? registrationRecords;

  const BarChartSection({
    super.key,
    this.registrationRecords,
  });

  @override
  Widget build(BuildContext context) {
    if (registrationRecords == null || registrationRecords!.isEmpty) {
      return Container(
        margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jumlah Pendaftar 5 Tahun Terakhir',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    'Tidak ada Data Jumlah Pendaftar',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return BarChartContainer(
      title: 'Jumlah Pendaftar 5 Tahun Terakhir',
      barGroups: registrationRecords!.map((record) {
        return BarChartGroupData(
          x: record.year,
          barRods: [
            BarChartRodData(
              fromY: 0,
              toY: record.totalRegistrants.toDouble(),
              width: 10,
              color: const Color(blueTheme),
              borderRadius: BorderRadius.zero,
            ),
          ],
        );
      }).toList(),
    );
  }
}
