import 'package:flutter/material.dart';

class NewsPlaceholder extends StatefulWidget {
  const NewsPlaceholder({super.key});

  @override
  State<NewsPlaceholder> createState() => _NewsPlaceholderState();
}

class _NewsPlaceholderState extends State<NewsPlaceholder>
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
      childAspectRatio: 1 / 1.5,
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

            return GestureDetector(
              onTap: () {},
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image placeholder
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        color: color,
                        height: 150, // Fixed height for image placeholder
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Title placeholder
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 16,
                        color: Colors.grey[400]?.withOpacity(
                          _animationController.value * 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Date placeholder
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 14,
                        color: Colors.grey[400]?.withOpacity(
                          _animationController.value * 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
