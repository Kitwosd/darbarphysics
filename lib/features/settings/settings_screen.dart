import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/core/theme/theme_extension.dart';
import 'package:durbar_physics/features/practise/basic_webview_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.settings,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              context.toggleTheme();
            },
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                context.isDark ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Avatar
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF3CA), // Light yellow bg from image
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg',
                        ), // Placeholder 3D avatar
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Menu Items
              _buildSettingItem(
                context,
                Icons.person,
                'Edit Profile',
                () => NavigationService.pushNamed(RouteName.profile),
              ),
              _buildSettingItem(
                context,
                Icons.credit_card,
                'Payment Option',
                null,
              ),
              _buildSettingItem(
                context,
                Icons.grid_view,
                'My Certificates',
                null,
              ),
              _buildSettingItem(
                context,
                Icons.analytics,
                'Terms & Conditions',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BasicWebviewScreen(
                      url:
                          'https://us04web.zoom.us/j/3117772972?pwd=oQOKC681rjGaeyA8ZiixJe8T2sW9pN.1',
                    ),
                  ),
                ),
              ),
              _buildSettingItem(
                context,
                Icons.headset_mic,
                'Help Center',
                null,
              ),
              _buildSettingItem(context, Icons.send, 'Invite Friends', null),
              _buildSettingItem(context, Icons.logout, 'Logout', null),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback?
    navigateTo, //TODO: Just for remembering void Function()? navigateTo = VoidCallback()
  ) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // color: color.withOpacity(0.1), // Optional: if we want colored bg for icon
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 28),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      onTap: () {
        if (navigateTo != null) {
          return navigateTo();
        }
      },
    );
  }
}
