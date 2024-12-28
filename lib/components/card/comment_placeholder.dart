import 'package:flutter/material.dart';

class CommentPlaceholder extends StatefulWidget {
  const CommentPlaceholder({Key? key}) : super(key: key);

  @override
  State<CommentPlaceholder> createState() => _CommentPlaceholderState();
}

class _CommentPlaceholderState extends State<CommentPlaceholder>
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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3, // Show 3 placeholder comments
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final color = ColorTween(
              begin: Colors.grey[300],
              end: Colors.grey[100],
            ).evaluate(_animationController)!;

            return Container(
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
              ),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.0,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username placeholder
                      Container(
                        width: 120,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey[400]?.withOpacity(
                            _animationController.value * 0.5,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8.0),

                      // Comment text placeholders
                      Container(
                        width: double.infinity,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey[400]?.withOpacity(
                            _animationController.value * 0.5,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity * 0.7,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey[400]?.withOpacity(
                            _animationController.value * 0.5,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                  // Date placeholder
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 100,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey[400]?.withOpacity(
                          _animationController.value * 0.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
