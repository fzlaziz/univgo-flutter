import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/screens/campus/const/card_style.dart';
import 'package:univ_go/screens/campus/faculty_list.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutStyles {
  static final borderDecoration = BoxDecoration(
    border: Border.all(
      color: Colors.black.withOpacity(0.2),
      width: 0.5,
    ),
    borderRadius: BorderRadius.circular(5),
  );

  static final titleTextStyle = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.blue,
  );

  static final subtitleTextStyle = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static final linkTextStyle = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: Colors.blue,
  );

  static const defaultPadding = EdgeInsets.symmetric(horizontal: 12);
  static const iconSize = 16.0;
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Divider(
        color: Colors.black.withOpacity(0.5),
        thickness: 0.5,
      ),
    );
  }
}

class ContactInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final bool isLink;

  const ContactInfoItem({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    this.isLink = false,
  });

  Future<void> _handleTap() async {
    if (icon == Icons.phone) {
      final Uri uri =
          Uri.parse('tel:${text.replaceAll(RegExp(r'[^\d+]'), '')}');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } else if (icon == Icons.email) {
      final Uri uri = Uri.parse('mailto:$text');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } else if (onTap != null) {
      onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: isLink ? AboutStyles.linkTextStyle : AboutStyles.subtitleTextStyle,
      overflow: TextOverflow.clip,
      maxLines: null,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: AboutStyles.iconSize),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: (text.isNotEmpty) ? _handleTap : null,
              child: textWidget,
            ),
          ),
        ],
      ),
    );
  }
}

class StatsItem extends StatelessWidget {
  final String title;
  final String value;

  const StatsItem({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.blue,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: Colors.black.withOpacity(0.6),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class StatsItem2 extends StatelessWidget {
  final String title;
  final String value;

  const StatsItem2({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.blue,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Mulai dari\n',
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(
                text: value,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ExpandableSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const Border(),
      title: Text(title, style: AboutStyles.titleTextStyle),
      trailing: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(217, 217, 217, 217),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 30,
        height: 30,
        child: const Icon(
          Icons.arrow_downward_outlined,
          color: Colors.blue,
          size: 16,
        ),
      ),
      children: children,
    );
  }
}

// Main About widget
class AboutSection extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final int campusId;

  const AboutSection(
      {super.key, required this.snapshot, required this.campusId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4, left: 8, right: 8),
      decoration: AboutStyles.borderDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 10, bottom: 10),
            child: Text(
              'About',
              style: CardStyle.cardTextStyle,
            ),
          ),
          _buildContactInfo(),
          const CustomDivider(),
          _buildStats(context),
          const CustomDivider(),
          _buildFacultySection(context),
          const CustomDivider(),
          _buildDegreeSection(),
          const CustomDivider(),
          _buildAdmissionSection(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          )
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Padding(
      padding: AboutStyles.defaultPadding,
      child: Column(
        children: [
          if (snapshot.data!.phoneNumber.isNotEmpty)
            ContactInfoItem(
              icon: Icons.phone,
              text: snapshot.data!.phoneNumber,
            ),
          if (snapshot.data!.email.isNotEmpty)
            ContactInfoItem(
              icon: Icons.email,
              text: snapshot.data!.email,
            ),
          if (snapshot.data!.webAddress.isNotEmpty)
            ContactInfoItem(
              icon: Icons.public,
              text: snapshot.data!.webAddress,
              onTap: () => _launchUrl(snapshot.data!.webAddress),
              isLink: true,
            ),
          if (snapshot.data!.instagram.isNotEmpty)
            ContactInfoItem(
              icon: FontAwesomeIcons.instagram,
              text: snapshot.data!.instagram,
              onTap: () =>
                  _launchUrl(snapshot.data!.instagram, isInstagram: true),
              isLink: true,
            ),
          if (snapshot.data!.youtube.isNotEmpty)
            ContactInfoItem(
              icon: FontAwesomeIcons.youtube,
              text: snapshot.data!.youtube,
              onTap: () => _launchUrl(snapshot.data!.youtube, isYoutube: true),
              isLink: true,
            ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Padding(
      padding: AboutStyles.defaultPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: StatsItem(title: 'Jenis', value: snapshot.data!.campusType),
          ),
          _buildVerticalDivider(context),
          Expanded(
            child: StatsItem(
              title: 'Mahasiswa',
              value: snapshot.data!.numberOfRegistrants.toString(),
            ),
          ),
          _buildVerticalDivider(context),
          Expanded(
            child: StatsItem2(
              title: 'Biaya Kuliah',
              value: 'Rp${snapshot.data!.minSingleTuition}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width < 400 ? 8.0 : 16.0,
      ),
      child: Container(
        width: 0.5,
        height: 50,
        color: Colors.black.withOpacity(0.5),
      ),
    );
  }

  Widget _buildFacultySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ListFaculty(campusId: campusId)),
        ),
        child: Row(
          children: [
            Text('Fakultas', style: AboutStyles.titleTextStyle),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(217, 217, 217, 217),
                borderRadius: BorderRadius.circular(10),
              ),
              width: 30,
              height: 30,
              child: const Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.blue,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDegreeSection() {
    return ExpandableSection(
      title: 'Masa Studi',
      children: snapshot.data?.degreeLevels == null ||
              snapshot.data!.degreeLevels!.isEmpty
          ? [_buildFallbackItem('Tidak ada data Masa Studi')]
          : snapshot.data!.degreeLevels!.map<Widget>((degreeLevel) {
              return _buildExpandableItem(
                "${degreeLevel.name} (${degreeLevel.duration} Tahun)",
              );
            }).toList(),
    );
  }

  Widget _buildAdmissionSection() {
    return ExpandableSection(
      title: 'Jalur Masuk',
      children: snapshot.data?.admissionRoutes == null ||
              snapshot.data!.admissionRoutes!.isEmpty
          ? [_buildFallbackItem('Tidak ada data Jalur Masuk')]
          : snapshot.data!.admissionRoutes!.map<Widget>((route) {
              return _buildExpandableItem(
                "${route.name} (${route.description})",
              );
            }).toList(),
    );
  }

  Widget _buildFallbackItem(String message) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        message,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildExpandableItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: const BoxDecoration(
          // color: Colors.white,
          // border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url,
      {bool isYoutube = false, bool isInstagram = false}) async {
    try {
      final Uri uri = Uri.parse(url);

      if (isYoutube || isInstagram) {
        try {
          final bool launched = await launchUrl(
            uri,
            mode: LaunchMode.externalNonBrowserApplication,
          );

          if (!launched) {
            await launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );
          }
        } catch (e) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        }
      } else {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}
