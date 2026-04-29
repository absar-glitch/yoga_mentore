import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_mentore/Providers/user_provider.dart';
import 'package:yoga_mentore/database/db_helper.dart';
import 'package:yoga_mentore/Screens/splash.dart';
import 'package:yoga_mentore/Screens/loginsignup.dart';
import 'package:yoga_mentore/Screens/userprofile.dart';
import 'package:yoga_mentore/Screens/poselibrary.dart';
import 'package:yoga_mentore/Screens/main_layout.dart';
import 'package:yoga_mentore/Screens/progresspage.dart';
import 'package:yoga_mentore/Screens/real_time.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize DB on startup so admin seed runs before any screen loads
  try {
    await DBHelper.database;
  } catch (e) {
    print("Database initialization failed: $e");
  }
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return MaterialApp(
      title: 'Yoga Mentor',
      debugShowCheckedModeBanner: false,
      theme: userProvider.isDarkMode
          ? ThemeData.dark().copyWith(
              primaryColor: const Color(0xFF13EC5B),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF13EC5B),
                brightness: Brightness.dark,
              ),
              scaffoldBackgroundColor: const Color(0xFF102213),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF102213),
              ),
            )
          : ThemeData.light().copyWith(
              primaryColor: const Color(0xFF13EC5B),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF13EC5B),
                brightness: Brightness.light,
              ),
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
            ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginSignupScreen(),
        '/home': (context) => const MainLayout(),
        '/Explore': (context) => const PoseLibraryPage(),
        '/Profile': (context) => const YogaProfilePage(),
        '/Stats': (context) => const YogaProgressPage(),
        '/AI': (context) => const YogaPracticePage(),
      },
    );
  }
}
