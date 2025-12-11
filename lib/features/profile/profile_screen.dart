import 'package:dubar_physics/core/routing/navigation_service.dart';
import 'package:dubar_physics/core/routing/route_name.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            onPressed: () {
              NavigationService.pushNamed(RouteName.setting);
            },
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.settings,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.notifications,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Avatar Section
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF3CA), // Light yellow bg
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Name Here',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Tag Line',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // About Me
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About Me',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lorem Ipsum Dolor Sit Amet Consectetur. Etiam Eget Suspendisse In Vel Phasellus. Purus Aliquam Sed Odio Lacus At. Enim Tellus Rhoncus Vitae Commodo. Sociis Nec Facilisi Phasellus Rhoncus Nibh Imperdiet Arcu Felis. Pulvinar Suscipit.',
                    style: TextStyle(color: Colors.grey[600], height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // My Skills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Skills',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _SkillChip(label: 'UI/UX'),
                      _SkillChip(label: 'Website Design'),
                      _SkillChip(label: 'Figma'),
                      _SkillChip(label: 'Animation'),
                      _SkillChip(label: 'User Persona'),
                      _SkillChip(label: 'XD'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Enrolled Courses
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Enrolled Courses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Course Carousel (Horizontal)
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 24),
                children: [
                  _CourseThumbnail(
                    color1: Colors.blueAccent,
                    color2: Colors.orangeAccent,
                    title: "UI",
                    subtitle: "UX",
                  ),
                  const SizedBox(width: 16),
                  _CourseThumbnail(
                    color1: Colors.cyanAccent,
                    color2: Colors.teal,
                    title: "SEO",
                    subtitle: "",
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _CourseThumbnail extends StatelessWidget {
  final Color color1;
  final Color color2;
  final String title;
  final String subtitle;

  const _CourseThumbnail({
    required this.color1,
    required this.color2,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.black, // Placeholder for dark bg
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          // Using a gradient placeholder or a network image that looks techy
          image: NetworkImage(
            'https://img.freepik.com/free-vector/gradient-ui-ux-elements-background_23-2149056159.jpg',
          ),
          fit: BoxFit.cover,
          opacity: 0.6,
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (title.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.blue,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (subtitle.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.orange,
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
