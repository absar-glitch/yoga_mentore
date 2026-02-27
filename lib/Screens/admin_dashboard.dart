import 'package:flutter/material.dart';
import 'admin_manage_users.dart';
import 'admin_manage_library.dart';
import 'admin_settings.dart';
import 'loginsignup.dart';

/// Admin Dashboard - main layout with bottom nav for Dashboard, Manage Users, Manage Library, Settings
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;
  bool _isDarkMode = true; // Admin pages ka apna theme — default dark

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = !value; // value true = light mode, false = dark mode
    });
  }

  @override
  Widget build(BuildContext context) {
    // Admin pages ke liye alag theme — sirf admin pages par apply hoga
    final adminTheme = _isDarkMode
        ? ThemeData.dark().copyWith(
            primaryColor: Colors.greenAccent,
            scaffoldBackgroundColor: const Color(0xFF102213),
            appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF102213)),
            cardColor: const Color(0xFF1a2e1d),
          )
        : ThemeData.light().copyWith(
            primaryColor: Colors.green,
            scaffoldBackgroundColor: Colors.grey[100],
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[100],
              foregroundColor: Colors.black,
            ),
            cardColor: Colors.white,
          );

    return Theme(
      data: adminTheme,
      child: Scaffold(
        backgroundColor: adminTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: adminTheme.appBarTheme.backgroundColor,
          title: const Text('Admin Dashboard'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // Logout — login page par wapas
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginSignupScreen()),
                );
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            const _DashboardOverview(),
            const AdminManageUsersPage(),
            const AdminManageLibraryPage(),
            AdminSettingsPage(
              isDarkMode: _isDarkMode,
              onThemeChanged: _toggleTheme,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: _isDarkMode ? const Color(0xFF1a2e1d) : Colors.white,
          selectedItemColor: _isDarkMode ? Colors.greenAccent : Colors.green,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts),
              label: 'Manage Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storage),
              label: 'Manage Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

/// Dashboard Overview — pehle wala main content (stats + management menu)
class _DashboardOverview extends StatelessWidget {
  const _DashboardOverview();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final subtitleColor = theme.brightness == Brightness.dark
        ? Colors.grey
        : Colors.grey[600]!;
    final accentColor = theme.brightness == Brightness.dark
        ? Colors.greenAccent
        : Colors.green;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Real-time Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _statCard(
                  'Total Users',
                  '12.5k',
                  Icons.group,
                  cardColor,
                  subtitleColor,
                  textColor,
                  accentColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statCard(
                  'Active',
                  '432',
                  Icons.circle,
                  cardColor,
                  subtitleColor,
                  textColor,
                  accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _statCard(
            'Pose Database',
            '154 Verified',
            Icons.accessibility_new,
            cardColor,
            subtitleColor,
            textColor,
            accentColor,
          ),
          const SizedBox(height: 25),
          Text(
            'Management Menu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 15),
          _menuItem(
            Icons.self_improvement,
            'Manage Poses',
            'Edit AI coordinates and descriptions',
            cardColor,
            textColor,
            subtitleColor,
            accentColor,
          ),
          _menuItem(
            Icons.forum,
            'User Feedback',
            'Review unread reports and ratings',
            cardColor,
            textColor,
            subtitleColor,
            accentColor,
          ),
          _menuItem(
            Icons.system_update_alt,
            'System Updates',
            'AI Engine v2.4.1 - Status: Optimal',
            cardColor,
            textColor,
            subtitleColor,
            accentColor,
          ),
          _menuItem(
            Icons.settings,
            'Global Config',
            'API endpoints and notification triggers',
            cardColor,
            textColor,
            subtitleColor,
            accentColor,
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color cardColor,
    Color subtitleColor,
    Color textColor,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: subtitleColor, fontSize: 12)),
              Icon(icon, color: accentColor),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    IconData icon,
    String title,
    String subtitle,
    Color cardColor,
    Color textColor,
    Color subtitleColor,
    Color accentColor,
  ) {
    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: accentColor),
        title: Text(title, style: TextStyle(color: textColor)),
        subtitle: Text(subtitle, style: TextStyle(color: subtitleColor)),
        trailing: Icon(Icons.chevron_right, color: accentColor),
        onTap: () {},
      ),
    );
  }
}
