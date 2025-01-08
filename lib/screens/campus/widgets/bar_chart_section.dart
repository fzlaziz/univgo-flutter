import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:univ_go/const/theme_color.dart';
import 'package:univ_go/screens/campus/widgets/bar_chart_container.dart';

class BarChartSection extends StatelessWidget {
  const BarChartSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BarChartContainer(
      title: 'Jumlah Mahasiswa 5 Tahun Terakhir',
      barGroups: [
        BarChartGroupData(x: 20, barRods: [
          BarChartRodData(
              fromY: 0,
              toY: 2120,
              width: 10,
              color: const Color(blueTheme),
              borderRadius: BorderRadius.zero),
        ]),
        BarChartGroupData(x: 21, barRods: [
          BarChartRodData(
              fromY: 0,
              toY: 1990,
              width: 10,
              color: const Color(blueTheme),
              borderRadius: BorderRadius.zero),
        ]),
        BarChartGroupData(x: 22, barRods: [
          BarChartRodData(
              fromY: 0,
              toY: 2260,
              width: 10,
              color: const Color(blueTheme),
              borderRadius: BorderRadius.zero),
        ]),
        BarChartGroupData(x: 23, barRods: [
          BarChartRodData(
              fromY: 0,
              toY: 2320,
              width: 10,
              color: const Color(blueTheme),
              borderRadius: BorderRadius.zero),
        ]),
        BarChartGroupData(x: 24, barRods: [
          BarChartRodData(
              fromY: 0,
              toY: 2402,
              width: 10,
              color: const Color(blueTheme),
              borderRadius: BorderRadius.zero),
        ]),
      ],
    );
  }
}
