import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterButtonWidget extends StatelessWidget {
  final String label;
  final int id;
  final String group;
  final bool isSelected;
  final VoidCallback onToggle;
  final double? width;

  const FilterButtonWidget({
    super.key,
    required this.label,
    required this.id,
    required this.group,
    required this.isSelected,
    required this.onToggle,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: SizedBox(
        width: width ?? 100,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: isSelected ? Colors.white : const Color(0xFF0059FF),
          ),
        ),
      ),
      selected: isSelected,
      showCheckmark: false,
      onSelected: (_) => onToggle(),
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF0059FF),
      side: const BorderSide(
        color: Color(0xFF0059FF),
        width: 1,
      ),
    );
  }
}
