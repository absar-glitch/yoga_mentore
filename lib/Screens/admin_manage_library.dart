import 'package:flutter/material.dart';

/// Admin ke liye pose/content library manage karne ka page
class AdminManageLibraryPage extends StatelessWidget {
  const AdminManageLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey : Colors.grey[600]!;
    final accentColor = const Color(0xFF13EC5B);

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Library',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage yoga poses, categories and content',
              style: TextStyle(color: subtitleColor, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Stats
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    'Total Poses',
                    '154',
                    Icons.accessibility_new,
                    cardColor,
                    subtitleColor,
                    textColor,
                    accentColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _statCard(
                    'Categories',
                    '12',
                    Icons.category,
                    cardColor,
                    subtitleColor,
                    textColor,
                    accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    'Verified',
                    '142',
                    Icons.verified,
                    cardColor,
                    subtitleColor,
                    accentColor,
                    accentColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _statCard(
                    'Pending',
                    '12',
                    Icons.pending,
                    cardColor,
                    subtitleColor,
                    Colors.orangeAccent,
                    accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Pose categories
            Text(
              'Pose Categories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            _categoryTile(
              'Beginner Poses',
              '45 poses',
              Icons.self_improvement,
              cardColor,
              textColor,
              subtitleColor,
              bgColor,
              accentColor,
            ),
            _categoryTile(
              'Intermediate Poses',
              '52 poses',
              Icons.fitness_center,
              cardColor,
              textColor,
              subtitleColor,
              bgColor,
              accentColor,
            ),
            _categoryTile(
              'Advanced Poses',
              '38 poses',
              Icons.sports_gymnastics,
              cardColor,
              textColor,
              subtitleColor,
              bgColor,
              accentColor,
            ),
            _categoryTile(
              'Meditation',
              '19 poses',
              Icons.spa,
              cardColor,
              textColor,
              subtitleColor,
              bgColor,
              accentColor,
            ),
            const SizedBox(height: 24),

            // Recent additions
            Text(
              'Recently Added',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            _poseTile(
              'Tree Pose',
              'Beginner',
              'Verified',
              cardColor,
              textColor,
              subtitleColor,
              bgColor,
              accentColor,
            ),
            _poseTile(
              'Crow Pose',
              'Advanced',
              'Pending',
              cardColor,
              textColor,
              subtitleColor,
              bgColor,
              accentColor,
            ),
            _poseTile(
              'Warrior III',
              'Intermediate',
              'Verified',
              cardColor,
              textColor,
              subtitleColor,
              bgColor,
              accentColor,
            ),
            _poseTile(
              'Lotus Pose',
              'Beginner',
              'Verified',
              cardColor,
              textColor,
              subtitleColor,
              bgColor,
              accentColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color cardColor,
    Color subtitleColor,
    Color valueColor,
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
              Icon(icon, color: accentColor, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryTile(
    String title,
    String subtitle,
    IconData icon,
    Color cardColor,
    Color textColor,
    Color subtitleColor,
    Color bgColor,
    Color accentColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: bgColor,
          child: Icon(icon, color: accentColor),
        ),
        title: Text(title, style: TextStyle(color: textColor)),
        subtitle: Text(subtitle, style: TextStyle(color: subtitleColor)),
        trailing: Icon(Icons.chevron_right, color: accentColor),
      ),
    );
  }

  Widget _poseTile(
    String name,
    String level,
    String status,
    Color cardColor,
    Color textColor,
    Color subtitleColor,
    Color bgColor,
    Color accentColor,
  ) {
    final statusColor = status == 'Verified'
        ? Colors.greenAccent
        : Colors.orangeAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: bgColor,
          child: Icon(Icons.self_improvement, color: accentColor),
        ),
        title: Text(name, style: TextStyle(color: textColor)),
        subtitle: Text(level, style: TextStyle(color: subtitleColor)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
