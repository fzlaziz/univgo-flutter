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
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.all(8),
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

  const LocationInfoCard({
    super.key,
    required this.snapshot,
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
          MapThumbnail(
            latitude: snapshot.data!.addressLatitude,
            longitude: snapshot.data!.addressLongitude,
          ),
          const SizedBox(width: 16),
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
