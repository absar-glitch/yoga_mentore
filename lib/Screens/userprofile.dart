import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yoga_mentore/Providers/user_provider.dart';
import 'edit_details.dart';
import 'practice_history.dart';
import 'notification_settings.dart';
import 'loginsignup.dart';

/// User profile screen: Stats, Settings aur Personal Details dikhane ke liye
class YogaProfilePage extends StatefulWidget {
  const YogaProfilePage({super.key});

  @override
  State<YogaProfilePage> createState() => _YogaProfilePageState();
}

class _YogaProfilePageState extends State<YogaProfilePage> {
  final ImagePicker _picker = ImagePicker();

  /// Gallery ya Camera se image pick krne ka function
  Future<void> _pickImage(UserProvider userProvider) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        userProvider.updateProfileImage(pickedFile.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error picking image: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);
    final isDark = userProvider.isDarkMode;

    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            pinned: true,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'MY PROFILE',
              style: TextStyle(
                color: theme.textTheme.titleLarge?.color,
                letterSpacing: 1.5,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 100 : 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _pickImage(userProvider),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.primaryColor.withValues(alpha: 0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.primaryColor.withValues(
                                  alpha: 0.15,
                                ),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 62,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          backgroundImage:
                              userProvider.profileImage.startsWith('assets/')
                              ? AssetImage(userProvider.profileImage)
                                    as ImageProvider
                              : FileImage(File(userProvider.profileImage)),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userProvider.name,
                    style: TextStyle(
                      color: theme.textTheme.headlineMedium?.color,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Level 3 • Yoga Practitioner',
                    style: TextStyle(
                      color: theme.primaryColor.withValues(alpha: 0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem("24", "Sessions", theme, isDark),
                      _buildStatItem("1.2k", "Minutes", theme, isDark),
                      _buildStatItem("12", "Day Streak", theme, isDark),
                    ],
                  ),
                  const SizedBox(height: 35),
                  _buildSectionLabel("ACCOUNT", theme),
                  _buildModernTile(
                    icon: Icons.person_outline_rounded,
                    title: "Edit Personal Details",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditDetailsPage(),
                      ),
                    ),
                    theme: theme,
                    isDark: isDark,
                  ),
                  _buildModernTile(
                    icon: Icons.history_rounded,
                    title: "Practice History",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PracticeHistoryPage(),
                      ),
                    ),
                    theme: theme,
                    isDark: isDark,
                  ),
                  _buildModernTile(
                    icon: Icons.favorite_border_rounded,
                    title: "My Favorite Poses",
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Favorites clicked")),
                      );
                    },
                    trailing: Text(
                      "12",
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    theme: theme,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 25),
                  _buildSectionLabel("PREFERENCES", theme),
                  _buildModernTile(
                    icon: Icons.notifications_none_rounded,
                    title: "Settings",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationSettingsPage(),
                      ),
                    ),
                    theme: theme,
                    isDark: isDark,
                  ),
                  _buildModernTile(
                    icon: Icons.verified_user_outlined,
                    title: "Privacy & Security",
                    onTap: () {},
                    theme: theme,
                    isDark: isDark,
                  ),
                  _buildModernTile(
                    icon: Icons.support_agent_rounded,
                    title: "Help & Support",
                    onTap: () {},
                    theme: theme,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: InkWell(
                      onTap: () async {
                        await Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).logout();
                        if (!context.mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginSignupScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.redAccent.withValues(alpha: 0.5),
                          ),
                          color: Colors.redAccent.withValues(alpha: 0.1),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.power_settings_new_rounded,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E3A24) : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildModernTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ThemeData theme,
    required bool isDark,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF162A19).withValues(alpha: 0.5)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.primaryColor, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing:
            trailing ??
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.2),
              size: 16,
            ),
      ),
    );
  }
}
