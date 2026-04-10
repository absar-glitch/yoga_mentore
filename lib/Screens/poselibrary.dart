import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_mentore/Providers/user_provider.dart';

/// Screen displaying a searchable library of yoga poses
class PoseLibraryPage extends StatefulWidget {
  const PoseLibraryPage({super.key});

  @override
  State<PoseLibraryPage> createState() => _PoseLibraryPageState();
}

class _PoseLibraryPageState extends State<PoseLibraryPage> {
  // Controllers for scrolling and search
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;


  // Keys for each category section
  final GlobalKey _beginnerKey = GlobalKey();
  final GlobalKey _intermediateKey = GlobalKey();
  final GlobalKey _advancedKey = GlobalKey();

  // Data from home.dart
  final List<Map<String, dynamic>> poses = const [
    {
      "title": "Mountain Pose",
      "sub": "Tadasana",
      "time": "5 min",
      "level": "Beginner",
      "color": Colors.greenAccent,
      "image": "assets/images/pexels-photo-8436587.jpeg",
    },
    {
      "title": "Child Pose",
      "sub": "Balasana",
      "time": "3 min",
      "level": "Beginner",
      "color": Colors.greenAccent,
      "image": "assets/images/pexels-photo-3757376.jpeg",
    },
    {
      "title": "Tree Pose",
      "sub": "Vrikshasana",
      "time": "5 min",
      "level": "Beginner",
      "color": Colors.greenAccent,
      "image": "assets/images/pexels-photo-3823039.jpeg",
    },
    {
      "title": "Warrior I",
      "sub": "Virabhadrasana I",
      "time": "6 min",
      "level": "Intermediate",
      "color": Colors.orangeAccent,
      "image": "assets/images/pexels-photo-317157.jpeg",
    },
    {
      "title": "Downward Dog",
      "sub": "Adho Mukha Svanasana",
      "time": "8 min",
      "level": "Intermediate",
      "color": Colors.orangeAccent,
      "image": "assets/images/pexels-photo-3822622.jpeg",
    },
    {
      "title": "Cobra Pose",
      "sub": "Bhujangasana",
      "time": "7 min",
      "level": "Advanced",
      "color": Colors.redAccent,
      "image": "assets/images/pexels-photo-4056723.jpeg",
    },
  ];

  void _searchPose(String query) {
    if (query.isEmpty) return;

    final foundPose = poses.firstWhere(
      (p) => p['title'].toString().toLowerCase().contains(query.toLowerCase()),
      orElse: () => {},
    );

    if (foundPose.isNotEmpty) {
      String level = foundPose['level'];
      if (level == 'Beginner') {
        _scrollToSection(_beginnerKey);
      } else if (level == 'Intermediate') {
        _scrollToSection(_intermediateKey);
      } else if (level == 'Advanced') {
        _scrollToSection(_advancedKey);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Found: ${foundPose['title']} in $level section"),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pose not found!")));
    }
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);
    final isDark = userProvider.isDarkMode;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: theme.scaffoldBackgroundColor,
              floating: true,
              pinned: true,
              elevation: 0,
              automaticallyImplyLeading: false,
              expandedHeight: 180,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'POSE LIBRARY',
                        style: TextStyle(
                          color: theme.textTheme.headlineMedium?.color,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Find the perfect pose for your practice today.',
                        style: TextStyle(
                          color: theme.primaryColor.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Container(
                  color: theme.scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      _buildSearchBar(theme, isDark),
                      _buildCategoryChips(theme, isDark),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              key: _beginnerKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'BEGINNER',
                  style: TextStyle(
                    color: theme.textTheme.titleLarge?.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            _buildGridSection('Beginner', theme, isDark),
            SliverToBoxAdapter(
              key: _intermediateKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'INTERMEDIATE',
                  style: TextStyle(
                    color: theme.textTheme.titleLarge?.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            _buildGridSection('Intermediate', theme, isDark),
            SliverToBoxAdapter(
              key: _advancedKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'ADVANCED / EXPERT',
                  style: TextStyle(
                    color: theme.textTheme.titleLarge?.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            _buildGridSection('Advanced', theme, isDark),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildGridSection(String level, ThemeData theme, bool isDark) {
    final filteredPoses = poses.where((p) => p['level'] == level).toList();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final pose = filteredPoses[index];
          return _buildPoseCard(
            context,
            pose['title'],
            pose['sub'],
            pose['time'],
            pose['level'],
            pose['color'],
            pose['image'],
            theme,
            isDark,
          );
        }, childCount: filteredPoses.length),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchBar(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withValues(alpha: 0.05),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onSubmitted: (value) => _searchPose(value),
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: 'Search poses...',
            hintStyle: TextStyle(
              color: theme.primaryColor.withValues(alpha: 0.5),
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: theme.primaryColor,
              size: 22,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                size: 20,
              ),
              onPressed: () => _searchController.clear(),
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF162A19) : Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(ThemeData theme, bool isDark) {
    final categories = ['All', 'Beginner', 'Intermediate', 'Advanced'];
    return SizedBox(
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isActive = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
              if (categories[index] == 'Beginner') {
                _scrollToSection(_beginnerKey);
              } else if (categories[index] == 'Intermediate') {
                _scrollToSection(_intermediateKey);
              } else if (categories[index] == 'Advanced') {
                _scrollToSection(_advancedKey);
              } else if (categories[index] == 'All') {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isActive
                    ? theme.primaryColor
                    : (isDark ? const Color(0xFF162A19) : Colors.grey[300]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isActive
                      ? Colors.black
                      : theme.textTheme.bodyLarge?.color?.withValues(
                          alpha: 0.7,
                        ),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildPoseCard(
    BuildContext context,
    String title,
    String sub,
    String time,
    String level,
    Color levelColor,
    String image,
    ThemeData theme,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Selected $title")));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: theme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor.withValues(
                          alpha: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: levelColor.withValues(alpha: 0.5),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        level,
                        style: TextStyle(
                          color: levelColor,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: theme.primaryColor.withValues(alpha: 0.7),
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                '$sub • $time',
                style: TextStyle(
                  color: theme.primaryColor.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
