import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({Key? key}) : super(key: key);

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _mdpController = TextEditingController();
  final TextEditingController _confirmdpController = TextEditingController();

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

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
print("dd");
    setState(() => _isLoading = true);

    try {
      if (_mdpController.text.isNotEmpty &&
          _mdpController.text != _confirmdpController.text) {
        _showErrorSnackBar('Les mots de passe ne correspondent pas.');
        return;
      }

      // Simulez une mise à jour du profil.
      await Future.delayed(const Duration(seconds: 2)); // Remplacez par votre API.

      _showSuccessSnackBar('Profil mis à jour avec succès !');
      Navigator.pop(context); // Retour au tableau de bord.
    } catch (e) {
      _showErrorSnackBar('Erreur lors de la mise à jour : $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier Profil')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextFieldWithIcon(
                  Icons.person,
                  'Nom',
                  _nomController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Entrez votre nom' : null,
                ),
                _buildTextFieldWithIcon(
                  Icons.person_outline,
                  'Prénom',
                  _prenomController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Entrez votre prénom' : null,
                ),
                _buildTextFieldWithIcon(
                  Icons.email,
                  'Email',
                  _emailController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Entrez votre email' : null,
                ),
                _buildTextFieldWithIcon(
                  Icons.account_circle,
                  'Login',
                  _loginController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Entrez votre login' : null,
                ),
                _buildTextFieldWithIcon(
                  Icons.lock,
                  'Nouveau mot de passe',
                  _mdpController,
                  obscureText: true,
                ),
                _buildTextFieldWithIcon(
                  Icons.lock_outline,
                  'Confirmez mot de passe',
                  _confirmdpController,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
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
      ),
    );
  }

  Widget _buildTextFieldWithIcon(
    IconData icon,
    String hintText,
    TextEditingController controller, {
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: validator,
      ),
    );
  }
}
