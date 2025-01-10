import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:univ_go/src/features/profile_campus/const/card_style.dart';

class BarChartContainer extends StatelessWidget {
  final String title;
  final List<BarChartGroupData> barGroups;
  final double aspectRatio;

  const BarChartContainer({
    super.key,
    required this.title,
    required this.barGroups,
    this.aspectRatio = 1.5,
  });

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CardStyle.cardTextStyle,
                ),
              ],
            ),
            const SizedBox(height: 15),
            AspectRatio(
              aspectRatio: aspectRatio,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(
                    border: const Border(
                      top: BorderSide.none,
                      right: BorderSide.none,
                      left: BorderSide(width: 1),
                      bottom: BorderSide(width: 1),
                    ),
                  ),
                  groupsSpace: 5,
                  barGroups: barGroups,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
