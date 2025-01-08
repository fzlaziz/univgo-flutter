import 'package:flutter/material.dart';

class PlaceholderCardStudyProgram extends StatelessWidget {
  final AnimationController animationController;

  const PlaceholderCardStudyProgram(
      {super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        Color color = ColorTween(
          begin: Colors.grey[300],
          end: Colors.grey[400],
        ).evaluate(animationController)!;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            elevation: 2,
            color: Colors.grey[50],
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color.fromARGB(255, 198, 197, 197)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              trailing: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              title: Container(
                width: double.infinity,
                height: 16,
                color: color,
              ),
              subtitle: Container(
                width: double.infinity,
                height: 14,
                color: color,
              ),
            ),
          ),
        );
      },
    );
  }
}
