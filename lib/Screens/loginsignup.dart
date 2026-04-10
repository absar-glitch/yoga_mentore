import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_mentore/Providers/user_provider.dart';
import 'main_layout.dart';
import 'admin_dashboard.dart';

/// Screen handling both Login and Sign-up functionality (AuthScreen se rename kiya gaya hai)
class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  // Toggle between Login and Sign-up forms - Login aur Signup switch krne ke liye
  bool isLogin = true;

  // Global keys for form validation - Form ki validation check krne ke liye keys
  final _loginKey = GlobalKey<FormState>();
  final _signupKey = GlobalKey<FormState>();

  // Visibility states for password fields - Password dikhane ya chupane ke liye
  bool _loginObscure = true;
  bool _signupObscure = true;
  bool _confirmObscure = true;

  // Controllers for text input fields - Text fields ka data access krne ke liye
  final TextEditingController _loginEmail = TextEditingController();
  final TextEditingController _loginPassword = TextEditingController();
  final TextEditingController _signupName = TextEditingController();
  final TextEditingController _signupPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background image for the auth screen — attractive yoga image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/yoga_login_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // Semi-transparent overlay taake form readable rahe
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.55),
                Colors.black.withValues(alpha: 0.7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: 380,
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: const Color(0xFF162D1B).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // App ka Name/Logo
                    const Text(
                      "Yoga Mentor",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Conditionally show either Login or Signup form - Login ya Signup form dikhana
                    isLogin ? _loginForm() : _signupForm(),
                    const SizedBox(height: 20),
                    // Toggle button to switch between Login and Signup - View switch krne ka button
                    GestureDetector(
                      onTap: () {
                        setState(() => isLogin = !isLogin);
                      },
                      child: Text(
                        isLogin
                            ? "Don't have an account? Sign Up"
                            : "Already have an account? Sign In",
                        style: const TextStyle(
                          color: Color(0xFF13EC5B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- LOGIN FORM ----------------
  // Login krne ka form
  Widget _loginForm() {
    return Form(
      key: _loginKey,
      child: Column(
        children: [
          _field(
            hint: "Email Address",
            icon: Icons.email,
            controller: _loginEmail,
            validator: (v) =>
                v == null || !v.contains("@") ? "Enter valid email" : null,
          ),
          const SizedBox(height: 16),
          _field(
            hint: "Password",
            icon: Icons.lock,
            controller: _loginPassword,
            obscure: _loginObscure,
            toggle: () => setState(() => _loginObscure = !_loginObscure),
            validator: (v) =>
                v == null || v.length < 6 ? "Minimum 6 characters" : null,
          ),
          const SizedBox(height: 24),
          _mainButton("Login", () {
            // Validation ke baad check karo — admin hai ya normal user
            if (_loginKey.currentState!.validate()) {
              final email = _loginEmail.text.trim();
              final password = _loginPassword.text.trim();

              // Admin credentials check
              if (email == 'Admin00@gmail.com' && password == 'Admin001') {
                Navigator.pushReplacement(
                  
                  context,
                  MaterialPageRoute(builder: (_) => const AdminDashboard()),
                );
              } else {
                // Normal user — home page
                final name = email.split('@')[0];
                Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).updateName(name);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainLayout()),
                );
              }
            }
          }),
        ],
      ),
    );
  }

  // ---------------- SIGN UP FORM ----------------
  // Naya account banane ka form
  Widget _signupForm() {
    return Form(
      key: _signupKey,
      child: Column(
        children: [
          _field(
            hint: "Full Name",
            icon: Icons.person,
            controller: _signupName,
            validator: (v) => v == null || v.isEmpty ? "Enter your name" : null,
          ),
          const SizedBox(height: 16),
          _field(
            hint: "Email Address",
            icon: Icons.email,
            validator: (v) =>
                v == null || !v.contains("@") ? "Enter valid email" : null,
          ),
          const SizedBox(height: 16),
          _field(
            hint: "Password",
            icon: Icons.lock,
            controller: _signupPass,
            obscure: _signupObscure,
            toggle: () => setState(() => _signupObscure = !_signupObscure),
            validator: (v) =>
                v == null || v.length < 6 ? "Minimum 6 characters" : null,
          ),
          const SizedBox(height: 16),
          _field(
            hint: "Confirm Password",
            icon: Icons.lock_outline,
            obscure: _confirmObscure,
            toggle: () => setState(() => _confirmObscure = !_confirmObscure),
            validator: (v) =>
                v != _signupPass.text ? "Password not match" : null,
          ),
          const SizedBox(height: 24),
          _mainButton("Create Account", () {
            // Validate sign-up details - Signup details check krna
            if (_signupKey.currentState!.validate()) {
              Provider.of<UserProvider>(
                context,
                listen: false,
              ).updateName(_signupName.text);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainLayout()),
              );
            }
          }),
        ],
      ),
    );
  }

  // ---------------- UI UTILITIES ----------------

  /// Reusable primary button component - Har jagah use hone wala main button
  Widget _mainButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF13EC5B),
          foregroundColor: const Color(0xFF102213),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  /// Reusable text input field with validation and styling - Custom input field
  Widget _field({
    required String hint,
    required IconData icon,
    TextEditingController? controller,
    bool obscure = false,
    VoidCallback? toggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF13EC5B)),
        suffixIcon: toggle != null
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white54,
                ),
                onPressed: toggle,
              )
            : null,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF19331E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(color: Color(0xFF13EC5B)),
      ),
    );
  }
}
