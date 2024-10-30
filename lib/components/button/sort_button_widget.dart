import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SortButtonWidget extends StatelessWidget {
  final String label;
  final String? value;
  final ValueChanged<bool>? onSelected;
  final bool isSelected;

  const SortButtonWidget({
    super.key,
    required this.label,
    this.value,
    this.onSelected,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: ElevatedButton(
        onPressed: () {
          if (onSelected != null) {
            onSelected!(!isSelected);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF0059FF) : Colors.white,
          foregroundColor: isSelected ? Colors.white : const Color(0xFF0059FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color.fromARGB(255, 33, 149, 243)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF0059FF),
          ),
        ),
      ),
    );
  }
}
