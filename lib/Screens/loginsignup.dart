import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_mentore/Providers/user_provider.dart';
import 'package:yoga_mentore/database/db_helper.dart';
import 'main_layout.dart';
import 'admin_dashboard.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  bool _isLoading = false;

  final _loginKey = GlobalKey<FormState>();
  final _signupKey = GlobalKey<FormState>();

  bool _loginObscure = true;
  bool _signupObscure = true;
  bool _confirmObscure = true;

  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();
  final _signupName = TextEditingController();
  final _signupEmail = TextEditingController();
  final _signupPass = TextEditingController();
  final _confirmPass = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _loginEmail.dispose();
    _loginPassword.dispose();
    _signupName.dispose();
    _signupEmail.dispose();
    _signupPass.dispose();
    _confirmPass.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_loginKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final user = await DBHelper.loginUser(
      _loginEmail.text.trim(),
      _loginPassword.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (user == null) {
      _showSnack('Invalid email or password');
      return;
    }

    await Provider.of<UserProvider>(context, listen: false).loginUser(user);
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            user['is_admin'] == 1 ? const AdminDashboard() : const MainLayout(),
      ),
      (route) => false,
    );
  }

  Future<void> _handleSignup() async {
    if (!_signupKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final id = await DBHelper.insertUser(
        name: _signupName.text.trim(),
        email: _signupEmail.text.trim(),
        password: _signupPass.text,
      );

      if (!mounted) return;

      final user = await DBHelper.getUserById(id);
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (user == null) {
        _showSnack('Something went wrong. Please try again.');
        return;
      }

      await Provider.of<UserProvider>(context, listen: false).loginUser(user);
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainLayout()),
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnack('Email already registered. Please login.');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFF1E3A24),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/yoga_login_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.5),
                Colors.black.withValues(alpha: 0.65),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF13EC5B).withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          'assets/images/app_logo.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: Container(
                        width: 380,
                        padding: const EdgeInsets.all(28),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Yoga Mentor",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isLogin
                                  ? "Welcome back! Sign in to continue"
                                  : "Create your account",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 28),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              transitionBuilder: (child, animation) =>
                                  FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.05, 0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  ),
                              child: isLogin
                                  ? _loginForm(key: const ValueKey('login'))
                                  : _signupForm(key: const ValueKey('signup')),
                            ),
                            const SizedBox(height: 24),
                            GestureDetector(
                              onTap: _isLoading
                                  ? null
                                  : () => setState(() => isLogin = !isLogin),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: isLogin
                                          ? "Don't have an account? "
                                          : "Already have an account? ",
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextSpan(
                                      text: isLogin ? "Sign Up" : "Sign In",
                                      style: const TextStyle(
                                        color: Color(0xFF13EC5B),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'App made with ❤️ by Absar, Taha and Eman',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginForm({Key? key}) {
    return Form(
      key: _loginKey,
      child: Column(
        key: key,
        children: [
          _field(
            hint: "Email Address",
            icon: Icons.email_outlined,
            controller: _loginEmail,
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
                v == null || !v.contains('@') ? 'Enter valid email' : null,
          ),
          const SizedBox(height: 16),
          _field(
            hint: "Password",
            icon: Icons.lock_outline,
            controller: _loginPassword,
            obscure: _loginObscure,
            toggle: () => setState(() => _loginObscure = !_loginObscure),
            validator: (v) =>
                v == null || v.length < 6 ? 'Minimum 6 characters' : null,
          ),
          const SizedBox(height: 28),
          _mainButton("Login", _isLoading ? null : _handleLogin),
        ],
      ),
    );
  }

  Widget _signupForm({Key? key}) {
    return Form(
      key: _signupKey,
      child: Column(
        key: key,
        children: [
          _field(
            hint: "Full Name",
            icon: Icons.person_outline,
            controller: _signupName,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter your name' : null,
          ),
          const SizedBox(height: 16),
          _field(
            hint: "Email Address",
            icon: Icons.email_outlined,
            controller: _signupEmail,
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
                v == null || !v.contains('@') ? 'Enter valid email' : null,
          ),
          const SizedBox(height: 16),
          _field(
            hint: "Password",
            icon: Icons.lock_outline,
            controller: _signupPass,
            obscure: _signupObscure,
            toggle: () => setState(() => _signupObscure = !_signupObscure),
            validator: (v) =>
                v == null || v.length < 6 ? 'Minimum 6 characters' : null,
          ),
          const SizedBox(height: 16),
          _field(
            hint: "Confirm Password",
            icon: Icons.lock_outline,
            controller: _confirmPass,
            obscure: _confirmObscure,
            toggle: () => setState(() => _confirmObscure = !_confirmObscure),
            validator: (v) =>
                v != _signupPass.text ? 'Passwords do not match' : null,
          ),
          const SizedBox(height: 28),
          _mainButton("Create Account", _isLoading ? null : _handleSignup),
        ],
      ),
    );
  }

  Widget _mainButton(String text, VoidCallback? onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF13EC5B),
          foregroundColor: const Color(0xFF102213),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 6,
          shadowColor: const Color(0xFF13EC5B).withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF102213),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  Widget _field({
    required String hint,
    required IconData icon,
    TextEditingController? controller,
    bool obscure = false,
    VoidCallback? toggle,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF13EC5B), size: 22),
        suffixIcon: toggle != null
            ? IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white60,
                  size: 22,
                ),
                onPressed: toggle,
              )
            : null,
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.45),
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.15),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF13EC5B), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
        ),
        errorStyle: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 12),
      ),
    );
  }
}
