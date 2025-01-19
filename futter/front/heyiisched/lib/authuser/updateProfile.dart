import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:heyiisched/Prof/model/model_emploi.dart';
import 'package:heyiisched/services/UserService_Y.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({Key? key}) : super(key: key);

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  dynamic _currentUser;

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _mdpController = TextEditingController();
  final TextEditingController _confirmdpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserFromPrefs();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _loginController.dispose();
    _mdpController.dispose();
    _confirmdpController.dispose();
    super.dispose();
  }

  Future<void> _loadUserFromPrefs() async {
    try {
      setState(() => _isLoading = true);
      final prefs = await SharedPreferences.getInstance();

      final userId = prefs.getString('userId');
      final userRole = prefs.getString('userRole');
      print('load fc :${userId}');
      debugPrint('Loading user data - UserId: $userId, Role: $userRole');

      if (userId == null ||
          userId.isEmpty ||
          userRole == null ||
          userRole.isEmpty) {
        debugPrint('Invalid userId or role - userId: $userId, role: $userRole');
        _handleSessionError();
        return;
      }

      try {
        final user = await _userService.fetchUserDetails(userId, userRole);
        if (user != null) {
          _updateUserFormFields(user);
        } else {
          debugPrint('User data is null after fetch');
          _handleDataError('No user data found');
        }
      } catch (e) {
        debugPrint('Error in fetchUserDetails: $e');
        _handleDataError('Failed to fetch user details: $e');
      }
    } catch (e) {
      debugPrint('Error in _loadUserFromPrefs: $e');
      _handleDataError('Error loading user data: $e');
    }
  }
 /*Future<void> _loadUserFromPrefs() async {
  try {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    
    final userId = prefs.getString('userId');
    final userRole = prefs.getString('userRole');
    
    if (userId == null || userRole == null) {
      print('aaa');
      _handleSessionError();
      return;
    }

    final user = await _userService.fetchUserDetails(userId, userRole);
    print('id :${user}');
    if (user != null) {
      setState(() {
        _currentUser = user;
        _nomController.text = user.nom ?? '';
        _prenomController.text = user.prenom ?? '';
        _emailController.text = user.email ?? '';
        _loginController.text = user.login ?? '';
        _mdpController.text = ''; 
        _confirmdpController.text = '';
        _isLoading = false;
      });
    } else {
      _handleDataError('User data not found');
    }
  } catch (e) {
    debugPrint('Error loading user data: $e');
    _handleDataError('Failed to load user data: $e');
  }
}*/
  void _handleSessionError() {
    if (!mounted) return;
    _showErrorSnackBar('Session expired. Please login again.');
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  void _handleDataError(String message) {
    if (!mounted) return;

    setState(() => _isLoading = false);
    _showErrorSnackBar(message);
  }

  void _updateUserFormFields(dynamic user) {
    if (!mounted) return;

    try {
      setState(() {
        _currentUser = user;
        _nomController.text = user.nom ?? '';
        _prenomController.text = user.prenom ?? '';
        _emailController.text = user.email ?? '';
        _loginController.text = user.login ?? '';
        _mdpController.text = '';
        _confirmdpController.text = '';
        _isLoading = false;
      });
   
    } catch (e) {
      debugPrint('Error updating form fields: $e');
      _handleDataError('Error updating form fields');
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _updateProfile() async {

    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);
      if (_mdpController.text.isNotEmpty &&
          _mdpController.text != _confirmdpController.text) {
        _showErrorSnackBar('Passwords do not match');
        setState(() => _isLoading = false);
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final userRole = prefs.getString('userRole');
      if (userId == null ||
          userId.isEmpty ||
          userRole == null ||
          userRole.isEmpty) {
        _handleSessionError();
        return;
      }
      final updatedUser = _createUpdatedUser();
      if (updatedUser == null) {
        _handleDataError('Invalid user type');
        return;
      }
      print('${userId}- ${userRole}  - ${updatedUser}');

      final result = await _userService.updateUser(
        userId,
        updatedUser,
        userRole,
      );
      print('reslut  ${result}');
      if (result != null) {
        _updateUserFormFields(result);
        _showSuccessSnackBar('Profile updated successfully');
        if (mounted) {
          Navigator.of(context).pop(result);
        }
      } else {
        _handleDataError('Failed to update profile');
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
      _handleDataError('Failed to update profile: ${e.toString()}');
    }
  }

  dynamic _createUpdatedUser() {
    if (_currentUser == null) return null;

    final String password = _mdpController.text.isNotEmpty
        ? _mdpController.text
        : _currentUser.motDePasse ?? '';

    try {
      if (_currentUser is Admin) {
        return Admin(
          idUser: _currentUser.idUser,
          nom: _nomController.text,
          prenom: _prenomController.text,
          email: _emailController.text,
          login: _loginController.text,
          motDePasse: password,
          cin: _currentUser.cin ?? '',
          telephone: _currentUser.telephone ?? '',
          dateNaissance: _currentUser.dateNaissance ?? DateTime.now(),
          role: _currentUser.role ?? '',
        );
      } else if (_currentUser is Enseignant) {
        return Enseignant(
          idUser: _currentUser.idUser,
          nom: _nomController.text,
          prenom: _prenomController.text,
          email: _emailController.text,
          login: _loginController.text,
          motDePasse: password,
          cin: _currentUser.cin ?? '',
          telephone: _currentUser.telephone ?? '',
          dateNaissance: _currentUser.dateNaissance ?? DateTime.now(),
          nbHeure: _currentUser.nbHeure ?? 0,
          grade: _currentUser.grade ?? null,
        );
      } else if (_currentUser is Etudiant) {
        return Etudiant(
          idUser: _currentUser.idUser,
          nom: _nomController.text,
          prenom: _prenomController.text,
          email: _emailController.text,
          login: _loginController.text,
          motDePasse: password,
          cin: _currentUser.cin ?? '',
          telephone: _currentUser.telephone ?? '',
          dateNaissance: _currentUser.dateNaissance ?? DateTime.now(),
          niveau: _currentUser.niveau ?? '',
          grpClass: _currentUser.grpClass ?? '',
          admin: _currentUser.admin ?? null,
        );
      }
    } catch (e) {
      debugPrint('Error creating updated user: $e');
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
    body: SingleChildScrollView(
      child: AlertDialog(
        title: const Text('Edit Profile'),
        content: _isLoading
            ? const Center(child: CircularProgressIndicator())
                : Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Modifier votre profil',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextFieldWithIcon(
                          Icons.person,
                          'Nom',
                          _nomController,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter your last name'
                              : null,
                        ),
                        _buildTextFieldWithIcon(
                          Icons.person_outline,
                          'Prenom',
                          _prenomController,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter your first name'
                              : null,
                        ),
                        _buildTextFieldWithIcon(
                          Icons.email,
                          'Email',
                          _emailController,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter your email'
                              : null,
                        ),
                        _buildTextFieldWithIcon(
                          Icons.account_circle,
                          'Login',
                          _loginController,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter your login'
                              : null,
                        ),
                        _buildTextFieldWithIcon(
                          Icons.lock,
                          'New Password',
                          _mdpController,
                          obscureText: true,
                        ),
                        _buildTextFieldWithIcon(
                          Icons.lock_outline,
                          'Confirm Password',
                          _confirmdpController,
                          obscureText: true,
                          validator: (value) =>
                              _mdpController.text.isNotEmpty &&
                                      value != _mdpController.text
                                  ? 'Passwords do not match'
                                  : null,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Annuler'),
                            ),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _updateProfile,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Mettre à jour'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
      ),
    ));
  }

  Widget _buildTextFieldWithIcon(
    IconData icon,
    String hintText,
    TextEditingController controller, {
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: validator,
      ),
    );
  }
}