import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_mentore/Providers/user_provider.dart';

/// Personal account details ko edit krne ke liye page
class EditDetailsPage extends StatefulWidget {
  const EditDetailsPage({super.key});

  @override
  State<EditDetailsPage> createState() => _EditDetailsPageState();
}

class _EditDetailsPageState extends State<EditDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final TextEditingController _bioController = TextEditingController(
    text: 'Passionate Yoga Enthusiast',
  );

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(text: userProvider.name);
    _emailController = TextEditingController(text: userProvider.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: theme.textTheme.titleLarge?.color),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.iconTheme.color),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInput('Full Name', _nameController, theme),
            _buildInput('Email', _emailController, theme),
            _buildInput('Bio', _bioController, theme),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await userProvider.updateUserDetails(
                  _nameController.text,
                  _emailController.text,
                );
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Changes saved successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF13EC37),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'SAVE CHANGES',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
