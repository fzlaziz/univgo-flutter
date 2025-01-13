import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationCardStyles {
  static const double iconSize = 16.0;
  static const Color iconColor = Colors.blue;

  static final cardDecoration = BoxDecoration(
    border: Border.all(
      color: Colors.black.withOpacity(0.2),
      width: 0.5,
    ),
    borderRadius: BorderRadius.circular(5),
  );

  static final textStyle = GoogleFonts.poppins(fontSize: 10);
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final Widget child;

  const InfoRow({
    super.key,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: LocationCardStyles.iconColor,
          size: LocationCardStyles.iconSize,
        ),
        const SizedBox(width: 6),
        child,
      ],
    );
  }
}

class MapThumbnail extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapThumbnail({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  Future<void> _openMap() async {
    final Uri googleMapsUri =
        Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude');

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      final Uri webUri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not open the map.';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 65,
      margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: GestureDetector(
        onTap: _openMap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            "assets/images/gmap.png",
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

// Main location info card widget
class LocationInfoCard extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final num averageRating;
  final int totalReviews;
  final VoidCallback onNavigateToReviews;

  const LocationInfoCard({
    super.key,
    required this.snapshot,
    required this.averageRating,
    required this.totalReviews,
    required this.onNavigateToReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      width: double.infinity,
      decoration: LocationCardStyles.cardDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
            width: 60,
            height: 60,
            child: GestureDetector(
              onTap: onNavigateToReviews,
              child: Card(
                color: Colors.white,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          Text(
                            averageRating.toStringAsFixed(1),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Spacer(),
                          Text(
                            '$totalReviews',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios, size: 12),
                          const Spacer(),
                        ],
                      ),
                      const Spacer(),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          MapThumbnail(
            latitude: snapshot.data!.addressLatitude,
            longitude: snapshot.data!.addressLongitude,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoRow(
                icon: Icons.location_on,
                child: Text(
                  snapshot.data!.description,
                  style: LocationCardStyles.textStyle,
                ),
              ),
              const SizedBox(height: 6),
              InfoRow(
                icon: Icons.verified,
                child: Row(
                  children: [
                    Text(
                      'Akreditasi ',
                      style: LocationCardStyles.textStyle,
                    ),
                    Text(
                      snapshot.data!.accreditation,
                      style: LocationCardStyles.textStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              InfoRow(
                icon: Icons.bar_chart,
                child: Text(
                  'Ranking x di Indonesia',
                  style: LocationCardStyles.textStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
