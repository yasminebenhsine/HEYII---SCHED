import 'package:flutter/material.dart';
import 'package:heyiisched/authuser/update_admin_etud/updateProfile.dart';
//import 'package:heyiisched/authuser/UpdateProfile.dart';
import 'package:heyiisched/services/AuthService_y.dart';


class DashboardPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  Future<void> _logoutUser(BuildContext context) async {
    try {
      await _authService.logout();

      // Affichage du message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Déconnexion réussie.'),
          backgroundColor: Colors.green,
        ),
      );

      // Rediriger l'utilisateur vers la page de connexion
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      
    } catch (e) {
      print("Error during logout: $e");

      // Afficher le message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la déconnexion: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 234, 236),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: AppBarClipper(),
                  child: Container(
                    height: 220,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF9F8DC3), Color(0xFFBE9CC7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Etudiant(e)',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Bonjour !',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/user.JPG'),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _buildDashboardCard(
                          title: 'Mon Emploi',
                          iconData: Icons.calendar_today,
                          iconColor: Color(0XFF211A44),
                          context: context,
                          onTap: () {
                            Navigator.pushNamed(context, '/emploi'); // Utilisez le nom de la route
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: _buildDashboardCard(
                          title: "Modifier Profil",
                          iconData: Icons.edit,
                          iconColor: Color(0XFF9F8DC3),
                          context: context,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => EditProfileDialog(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      _logoutUser(context); // Appeler la méthode de déconnexion
                    },
                    icon: Icon(Icons.logout),
                    label: Text("Déconnexion"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF9F8DC3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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

  Widget _buildDashboardCard({
    required String title,
    required IconData iconData,
    required Color iconColor,
    required BuildContext context,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, color: iconColor, size: 40),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);
    var secondControlPoint = Offset(3 * size.width / 4, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/*
class DashboardPage extends StatelessWidget {
 final Etudiant? etudiant; // This would be passed or fetched

  DashboardPage({this.etudiant}); // Constructor accepting Etudiant object
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 234, 236),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: AppBarClipper(),
                  child: Container(
                    height: 220,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF9F8DC3), Color(0xFFBE9CC7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Etudiant(e)',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        etudiant != null
                            ? 'Bonjour ${etudiant!.nom}!'
                            : 'Bonjour !',  // If no student is connected
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/user.JPG'),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _buildDashboardCard(
                          title: 'Mon Emploi',
                          iconData: Icons.calendar_today,
                          iconColor: Color(0XFF211A44),
                          context: context,
                          onTap: () {
                            Navigator.pushNamed(context, '/emploi'); // Utilisez le nom de la route
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildDashboardCard(
                          title: "Mes messages",
                          iconData: Icons.message,
                          iconColor: Color(0XFF5C5792),
                          context: context,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: _buildDashboardCard(
                      title: "Modifier Profil",
                      iconData: Icons.edit,
                      iconColor: Color(0XFF9F8DC3),
                      context: context,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => EditProfileDialog(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Logique de déconnexion
                },
                icon: Icon(Icons.logout),
                label: Text("Déconnexion"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9F8DC3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required IconData iconData,
    required Color iconColor,
    required BuildContext context,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, color: iconColor, size: 40),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);
    var secondControlPoint = Offset(3 * size.width / 4, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
*/