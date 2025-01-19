
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heyiisched/services/AuthService_y.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final userRole = prefs.getString('userRole');

      if (userId != null && userRole != null) {
        debugPrint('Found existing session - UserId: $userId, Role: $userRole');
        _navigateBasedOnRole(userRole);
      }
    } catch (e) {
      debugPrint('Error checking session: $e');
    }
  }

  void _navigateBasedOnRole(String roleStr) {
    UserRole? role;
    switch (roleStr.toLowerCase()) {
      case 'admin':
        role = UserRole.admin;
        break;
      case 'enseignant':
        role = UserRole.enseignant;
        break;
      case 'etudiant':
        role = UserRole.etudiant;
        break;
    }

    if (role != null && mounted) {
      Navigator.of(context).pushReplacementNamed(_getRouteForRole(role));
    }
  }

  Future<void> _loginUser(BuildContext context) async {
    if (!mounted) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      setState(() => _isLoading = true);

      String login = _loginController.text.trim();
      String password = _passwordController.text.trim();

      if (login.isEmpty || password.isEmpty) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Please enter both login and password')),
        );
        setState(() => _isLoading = false);
        return;
      }

      debugPrint('Sending login request with: $login');
      final userRole = await _authService.login(login, password);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (userRole != null) {
        debugPrint('Login successful - Role: ${userRole.toString()}');

        // Verify SharedPreferences immediately after login
        final prefs = await SharedPreferences.getInstance();
        final savedUserId = prefs.getString('userId');
        final savedRole = prefs.getString('userRole');
        debugPrint(
            'Verified saved preferences - UserId: $savedUserId, Role: $savedRole');

        String route = _getRouteForRole(userRole);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Welcome ${userRole.toString().split('.').last}!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Add slight delay to show the success message
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          navigator.pushReplacementNamed(route);
        }
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Login failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return '/admin/dashboard';
      case UserRole.enseignant:
         return  '/profi';
      case UserRole.etudiant:
        return '/student';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBE9CC7),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              decoration: const BoxDecoration(
                color: Color(0xFFBE9CC7),
              ),
              child: Stack(
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/icons/login.svg',
                    fit: BoxFit.cover,
                    height: 400,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  FadeInUp(
                    duration: const Duration(milliseconds: 1800),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFBE9CC7)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Color(0xFFBE9CC7)),
                              ),
                            ),
                            child: TextField(
                              controller: _loginController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email or Phone number",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                              onSubmitted: (_) => _loginUser(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1900),
                    child: GestureDetector(
                      onTap: _isLoading ? null : () => _loginUser(context),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(colors: [
                            const Color(0xFF211A44),
                            const Color(0xFF211A44).withOpacity(0.6),
                          ]),
                        ),
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  FadeInUp(
                    duration: const Duration(milliseconds: 2000),
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Color(0xFF5C5792)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
/*import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heyiisched/services/AuthService_y.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final userRole = prefs.getString('userRole');

      if (userId != null && userRole != null) {
        debugPrint('Found existing session - UserId: $userId, Role: $userRole');
        _navigateBasedOnRole(userRole);
      }
    } catch (e) {
      debugPrint('Error checking session: $e');
    }
  }

  void _navigateBasedOnRole(String roleStr) {
    UserRole? role;
    switch (roleStr.toLowerCase()) {
      case 'admin':
        role = UserRole.admin;
        break;
      case 'enseignant':
        role = UserRole.enseignant;
        break;
      case 'etudiant':
        role = UserRole.etudiant;
        break;
    }

    if (role != null && mounted) {
      Navigator.of(context).pushReplacementNamed(_getRouteForRole(role));
    }
  }

  Future<void> _loginUser(BuildContext context) async {
    if (!mounted) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      setState(() => _isLoading = true);

      String login = _loginController.text.trim();
      String password = _passwordController.text.trim();

      if (login.isEmpty || password.isEmpty) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Please enter both login and password')),
        );
        setState(() => _isLoading = false);
        return;
      }

      debugPrint('Sending login request with: $login');
      final userRole = await _authService.login(login, password);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (userRole != null) {
        debugPrint('Login successful - Role: ${userRole.toString()}');

        // Verify SharedPreferences immediately after login
        final prefs = await SharedPreferences.getInstance();
        final savedUserId = prefs.getString('userId');
        final savedRole = prefs.getString('userRole');
        debugPrint(
            'Verified saved preferences - UserId: $savedUserId, Role: $savedRole');

        String route = _getRouteForRole(userRole);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Welcome ${userRole.toString().split('.').last}!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Add slight delay to show the success message
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          navigator.pushReplacementNamed(route);
        }
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Login failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return '/admin/dashboard';
      case UserRole.enseignant:
         return  '/profi';
      case UserRole.etudiant:
        return '/student';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBE9CC7),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              decoration: const BoxDecoration(
                color: Color(0xFFBE9CC7),
              ),
              child: Stack(
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/icons/login.svg',
                    fit: BoxFit.cover,
                    height: 400,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  FadeInUp(
                    duration: const Duration(milliseconds: 1800),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFBE9CC7)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Color(0xFFBE9CC7)),
                              ),
                            ),
                            child: TextField(
                              controller: _loginController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email or Phone number",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                              onSubmitted: (_) => _loginUser(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1900),
                    child: GestureDetector(
                      onTap: _isLoading ? null : () => _loginUser(context),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(colors: [
                            const Color(0xFF211A44),
                            const Color(0xFF211A44).withOpacity(0.6),
                          ]),
                        ),
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  FadeInUp(
                    duration: const Duration(milliseconds: 2000),
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Color(0xFF5C5792)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heyiisched/services/authService.dart';
// Ensure correct model imports

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Declare controllers for the login form
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Instance of AuthService
  final AuthService _authService = AuthService();

  // Login function
 Future<void> _loginUser(BuildContext context) async {
  String login = _loginController.text.trim();
  String password = _passwordController.text.trim();

  if (login.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Veuillez entrer le login et le mot de passe')),
    );
    return;
  }

  final userRole = await _authService.login(login, password);

  if (userRole != null) {
    String route;
    switch (userRole) {
      case UserRole.admin:
        route = '/admin/dashboard';
        break;
      case UserRole.enseignant:
        route = '/profi';
        break;
      case UserRole.etudiant:
        route = '/student';
        break;
      default:
        route = '/login'; // Default if role is invalid
    }
    print('route :  ${route}');
    Navigator.pushReplacementNamed(context, route); // Navigate after successful login
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBE9CC7),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                  color: Color(0xFFBE9CC7),
                ),
                child: Stack(
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/icons/login.svg',
                      fit: BoxFit.cover,
                      height: 400,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xFFBE9CC7)),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, .2),
                              blurRadius: 20.0,
                              offset: Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xFFBE9CC7)))),
                              child: TextField(
                                controller: _loginController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email or Phone number",
                                  hintStyle: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: GestureDetector(
                        onTap: () {
                          // Handle login logic and store role
                          _loginUser(context);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              Color(0xFF211A44),
                              Color(0xFF211A44).withOpacity(0.6),
                            ]),
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 70),
                    FadeInUp(
                      duration: Duration(milliseconds: 2000),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: Color(0xFF5C5792)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/