import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class FilterButtonWidget extends StatelessWidget {
  final String label;
  final int id;
  final String group;
  final bool isSelected;
  final ValueChanged<bool> onSelected;
  final double? width;

  const FilterButtonWidget({
    Key? key,
    required this.label,
    required this.id,
    required this.group,
    required this.onSelected,
    required this.isSelected,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int overflowThreshold = 13;

    return ChoiceChip(
      label: Container(
        width: width ?? 100,
        child: (label.length > overflowThreshold)
            ? SizedBox(
                height: 20,
                child: Marquee(
                  text: label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF0059FF),
                  ),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  blankSpace: 20.0,
                  velocity: 30.0,
                  pauseAfterRound: Duration(seconds: 1),
                ),
              )
            : Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF0059FF),
                ),
              ),
      ),
      selected: isSelected,
      showCheckmark: false,
      onSelected: (selected) => onSelected(selected),
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF0059FF),
      side: const BorderSide(
        color: Color(0xFF0059FF),
        width: 1,
      ),
    );
  }
}
