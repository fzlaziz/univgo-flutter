import 'package:flutter/material.dart';

// Widget untuk tombol filter
class FilterButtonWidget extends StatelessWidget {
  final String label;
  final int id;
  final String group;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const FilterButtonWidget({
    Key? key,
    required this.label,
    required this.id,
    required this.group,
    required this.onSelected,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      showCheckmark: false,
      onSelected: (selected) => onSelected(selected),
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF0059FF),
      labelStyle:
          TextStyle(color: isSelected ? Colors.white : const Color(0xFF0059FF)),
      side: const BorderSide(
        color: Color(0xFF0059FF), // Border color
        width: 1, // Border width
      ),
    );
  }
}
