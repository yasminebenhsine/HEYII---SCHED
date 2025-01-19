import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heyiisched/authuser/updateProfile.dart';
import 'package:heyiisched/services/AuthService_y.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(context),
          _buildGrid(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
void _logoutUser() async {
  try {
    final authService = AuthService();
    await authService.logout();
    print("Logged out successfully.");
  } catch (e) {
    print("Error during logout: $e");
  }
}

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0XFFBE9CC7), // Header background color
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 100,
              width: 100,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, color: Colors.red),
            ),
            const Spacer(),
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                title: const Text(
                  'Mr/Mme',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Bonjour !',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                trailing: PopupMenuButton<String>(
                  icon: const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/user.JPG'),
                  ),
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'profile',
                        child: Text('Profile'),

                      ),
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Text('Logout'),
                        
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 'profile') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile clicked')),
                    );

                    // Naviguer vers la page de mise à jour du profil
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfileDialog()), // Remplacer par votre page de mise à jour du profil
                    );
                                  } else if (value == 'logout') {
                    // Afficher le Snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logging out...')),
                    );

                    // Appel à la méthode de logout pour effacer la session
                    _logoutUser();

                    // Naviguer vers la page de connexion après un court délai
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.pushReplacementNamed(context, '/login');
                    });
                  }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Container(
      color: const Color(0XFFBE9CC7), // Indigo background for the grid section
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(200)),
        ),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 40,
          mainAxisSpacing: 10,
          children: [
           _itemDashboard(
                'Mon EMPLOI', CupertinoIcons.graph_circle, const Color.fromARGB(255, 148, 75, 127), context),
            _itemDashboard('Mes Vœux', CupertinoIcons.add_circled, const Color.fromARGB(255, 91, 51, 128),
                context),
            _itemDashboard('Réclamation', CupertinoIcons.chat_bubble_2,
                const Color.fromARGB(255, 85, 28, 75), context),
          
            _itemDashboard('cours', CupertinoIcons.person_2, const Color.fromARGB(255, 181, 123, 192),
                context),
          ],
        ),
      ),
    );
  }

Widget _itemDashboard(String title, IconData iconData, Color background, BuildContext context) {
  return GestureDetector(
    onTap: () {
      if (title == 'Mon EMPLOI') {
        Navigator.pushNamed(context, '/timetable');
      } else if (title == 'Mes Vœux') {
        Navigator.pushNamed(context, '/add_voeux');
      } else if (title == 'Réclamation') { // New condition for Réclamation
        Navigator.pushNamed(context, '/reclamation');
        
      }else if (title == 'cours') { 
        Navigator.pushNamed(context, '/matiere');
      }
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Theme.of(context).primaryColor.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: background, shape: BoxShape.circle),
            child: Icon(iconData, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    ),
  );
}

}
















/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heyiisched/authuser/updateProfile.dart';
import 'package:heyiisched/services/EnseignantService.dart';
import 'package:heyiisched/services/GrpClassService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'GrpClassListScreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Méthode pour récupérer l'ID de l'enseignant
  Future<String> getEnseignantId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String enseignantId = prefs.getString('enseignantId') ?? '';
    debugPrint("Fetched enseignantId: $enseignantId");
    return enseignantId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(context),
          _buildGrid(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0XFFBE9CC7), // Header background color
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 100,
              width: 100,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, color: Colors.red),
            ),
            const Spacer(),
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                title: const Text(
                  'Mr/Mme',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Bonjour !',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                trailing: PopupMenuButton<String>(
                  icon: const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/user.JPG'),
                  ),
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'profile',
                        child: Text('Profile'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Text('Logout'),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 'profile') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile clicked')),
                      );

                      // Naviguer vers la page de mise à jour du profil
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfileDialog()), // Remplacer par votre page de mise à jour du profil
                      );
                    } else if (value == 'logout') {
                      // Afficher le Snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logout clicked')),
                      );

                      // Naviguer vers la page de connexion après un court délai
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pushNamed(context, '/login');
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Container(
      color: const Color(0XFFBE9CC7), // Indigo background for the grid section
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(200)),
        ),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 40,
          mainAxisSpacing: 10,
          children: [
            _itemDashboard(
                'Mon EMPLOI', CupertinoIcons.graph_circle, Colors.green, context),
            _itemDashboard('Mes Vœux', CupertinoIcons.add_circled, Colors.teal,
                context),
            _itemDashboard('Réclamation', CupertinoIcons.chat_bubble_2,
                Colors.brown, context),
            _itemDashboard('Étudiants', CupertinoIcons.person_2, Colors.purple,
                context),
            _itemDashboard('cours', CupertinoIcons.person_2, const Color.fromARGB(255, 154, 124, 159),
                context),
          ],
        ),
      ),
    );
  }

  Widget _itemDashboard(String title, IconData iconData, Color background, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (title == 'Mon EMPLOI') {
          Navigator.pushNamed(context, '/timetable');
        } else if (title == 'Mes Vœux') {
          Navigator.pushNamed(context, '/add_voeux');
        } else if (title == 'Réclamation') { 
          Navigator.pushNamed(context, '/reclamation');
        } else if (title == 'cours') { 
          // Récupérer l'ID de l'enseignant et naviguer vers GrpClassListScreen
          String enseignantId = await getEnseignantId();
          if (enseignantId.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GrpClassListScreen(idEnseignant: enseignantId),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Impossible de récupérer l\'ID enseignant.')),
            );
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Theme.of(context).primaryColor.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: background, shape: BoxShape.circle),
              child: Icon(iconData, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
*/