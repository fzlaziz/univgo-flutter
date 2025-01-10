import 'package:flutter/material.dart';

class RecommendedCampusesPlaceholder extends StatefulWidget {
  const RecommendedCampusesPlaceholder({super.key});

  @override
  State<RecommendedCampusesPlaceholder> createState() =>
      _RecommendedCampusesPlaceholderState();
}

class _RecommendedCampusesPlaceholderState
    extends State<RecommendedCampusesPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 2 / 2.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        4, // Show 4 placeholder items in 2x2 grid
        (index) => AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final color = ColorTween(
              begin: Colors.grey[300],
              end: Colors.grey[100],
            ).evaluate(_animationController)!;

            return Card(
              color: Colors.grey[45],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background shimmer
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      color: color,
                    ),
                  ),
                  // Title placeholder
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey[400]?.withOpacity(
                          _animationController.value * 0.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  // Button placeholder
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      width: 80,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.grey[400]?.withOpacity(
                          _animationController.value * 0.5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
