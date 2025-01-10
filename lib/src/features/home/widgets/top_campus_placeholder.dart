import 'package:flutter/material.dart';

class CampusPlaceholderList extends StatefulWidget {
  const CampusPlaceholderList({super.key});

  @override
  State<CampusPlaceholderList> createState() => _CampusPlaceholderListState();
}

class _CampusPlaceholderListState extends State<CampusPlaceholderList>
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
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3.5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Number of placeholder items
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width / 2,
            margin: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.grey[45],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final color = ColorTween(
                      begin: Colors.grey[300],
                      end: Colors.grey[100],
                    ).evaluate(_animationController)!;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo placeholder
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        // Text placeholder
                        Container(
                          height: 20,
                          width: 120,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
