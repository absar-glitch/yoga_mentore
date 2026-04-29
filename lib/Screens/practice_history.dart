import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_mentore/Providers/user_provider.dart';
import 'package:yoga_mentore/database/db_helper.dart';

class PracticeHistoryPage extends StatefulWidget {
  const PracticeHistoryPage({super.key});

  @override
  State<PracticeHistoryPage> createState() => _PracticeHistoryPageState();
}

class _PracticeHistoryPageState extends State<PracticeHistoryPage> {
  List<Map<String, dynamic>> _sessions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final userId =
        Provider.of<UserProvider>(context, listen: false).userId;
    if (userId != null) {
      final sessions = await DBHelper.getUserSessions(userId);
      if (mounted) setState(() { _sessions = sessions; _loading = false; });
    } else {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Provider.of<UserProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Practice History',
          style: TextStyle(color: theme.textTheme.titleLarge?.color),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.iconTheme.color),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _sessions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 64,
                    color: theme.primaryColor.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No sessions yet',
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color?.withValues(
                        alpha: 0.6,
                      ),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start a yoga session to see your history here',
                    style: TextStyle(
                      color: theme.textTheme.bodySmall?.color?.withValues(
                        alpha: 0.5,
                      ),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _sessions.length,
              itemBuilder: (context, index) {
                final s = _sessions[index];
                final date = DateTime.tryParse(s['date'] as String? ?? '');
                final dateStr = date != null
                    ? '${date.day}/${date.month}/${date.year} • ${s['duration_minutes']} mins'
                    : '${s['duration_minutes']} mins';
                final accuracy =
                    ((s['accuracy'] as double) * 100).toStringAsFixed(0);

                return Card(
                  color: isDark
                      ? const Color(0xFF1E3A24)
                      : Colors.grey[100],
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.self_improvement, color: theme.primaryColor),
                    ),
                    title: Text(
                      s['pose_name'] as String,
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      dateStr,
                      style: TextStyle(
                        color: theme.textTheme.bodySmall?.color?.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                    trailing: Text(
                      '$accuracy%',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
