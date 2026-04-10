import 'package:flutter/material.dart';

/// Admin ke liye users manage karne ka page
class AdminManageUsersPage extends StatelessWidget {
  const AdminManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey : Colors.grey[600]!;
    final accentColor = const Color(0xFF13EC5B);
    final hintColor = isDark ? Colors.white38 : Colors.grey;

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Users',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'View and manage all registered users',
              style: TextStyle(color: subtitleColor, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Search bar
            TextField(
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Search users...',
                hintStyle: TextStyle(color: hintColor),
                prefixIcon: Icon(Icons.search, color: accentColor),
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Stats row
            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    'Total Users',
                    '12,500',
                    Icons.group,
                    cardColor,
                    subtitleColor,
                    textColor,
                    accentColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _infoCard(
                    'Active Now',
                    '432',
                    Icons.circle,
                    cardColor,
                    subtitleColor,
                    accentColor,
                    accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    'New Today',
                    '28',
                    Icons.person_add_alt_1,
                    cardColor,
                    subtitleColor,
                    textColor,
                    accentColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _infoCard(
                    'Blocked',
                    '5',
                    Icons.block,
                    cardColor,
                    subtitleColor,
                    Colors.redAccent,
                    accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // User list
            Text(
              'Recent Users',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            _userTile(
              'Ahmad Khan',
              'ahmad@email.com',
              'Active',
              cardColor,
              textColor,
              subtitleColor,
              bgColor,
              accentColor,
            ),
            _userTile(
              'Sara Ali',
              'sara@email.com',
              'Active',
              cardColor,
              textColor,
              subtitleColor,
              bgColor,
              accentColor,
            ),
            _userTile(
              'Usman Raza',
              'usman@email.com',
              'Inactive',
              cardColor,
              textColor,
              subtitleColor,
              bgColor,
              accentColor,
            ),
            _userTile(
              'Fatima Noor',
              'fatima@email.com',
              'Active',
              cardColor,
              textColor,
              subtitleColor,
              bgColor,
              accentColor,
            ),
            _userTile(
              'Bilal Ahmed',
              'bilal@email.com',
              'Blocked',
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

  Widget _infoCard(
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

  Widget _userTile(
    String name,
    String email,
    String status,
    Color cardColor,
    Color textColor,
    Color subtitleColor,
    Color bgColor,
    Color accentColor,
  ) {
    Color statusColor;
    switch (status) {
      case 'Active':
        statusColor = Colors.greenAccent;
        break;
      case 'Blocked':
        statusColor = Colors.redAccent;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: bgColor,
          child: Icon(Icons.person, color: accentColor),
        ),
        title: Text(name, style: TextStyle(color: textColor)),
        subtitle: Text(email, style: TextStyle(color: subtitleColor)),
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
