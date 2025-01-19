import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HEYI SCHED',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
       debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'HEYI SCHED'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    CoursesScreen(),
    TeachersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              // Implement search functionality
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0XFF211A44 ),
              ),
              child: Center(
                child: Text(
                  'HEYI SCHED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Teachers'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
              onTap: () {
                // Implement message functionality
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                // Implement notification functionality
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Calendars'),
              onTap: () {
                // Implement calendar functionality
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Image.asset('assets/images/clock.png', width: 24, height: 24),
              title: Text('Community'),
              onTap: () {
                // Implement community functionality
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Implement settings functionality
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: getSelectedContent(), // Call the new method here
    );
  }

  // New method to get the selected content based on the index
  Widget getSelectedContent() {
    switch (_selectedIndex) {
      case 0: // Dashboard
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Global Activities Section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Global Activities',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      // Add any additional information or visuals here
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '\15 000',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(width: 10),
                          Row(
                            children: [
                              Icon(Icons.arrow_upward, color: Colors.green, size: 20),
                              Text('2%', style: TextStyle(color: Colors.green)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Compared to last year \14 800',
                        style: TextStyle(color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      // More data visualizations can be added here
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // New section for a more detailed view
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard Overview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 10),
                      // Example cards or stats can be added here
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard('Total Users', '1,234', Color(0XFF5C5792)),
                          _buildStatCard('Enseignant', '567', Color.fromARGB(255, 78, 52, 209)),
                          _buildStatCard('Admins', '5', Color(0XFF9F8DC3)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      case 1: // Teachers
        return TeachersScreen();
      default:
        return Container();
    }
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class CoursesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back Taylor!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'New Courses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CourseCard(
                    title: 'Content Writing',
                    lessons: 12,
                    type: 'Data Research',
                    rating: 4.0,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CourseCard(
                    title: 'Usability Testing',
                    lessons: 15,
                    type: 'UI/UX Design',
                    rating: 5.0,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CourseCard(
                    title: 'Photography',
                    lessons: 8,
                    type: 'Art and Design',
                    rating: 4.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Your Teachers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0XFF211A44 ),
                    child: Text('T${index + 1}'),
                  ),
                  title: Text('Teacher Name $index'),
                  subtitle: Text('Subject: Subject $index'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TeachersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Teachers',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0XFF211A44 ),
                    child: Text('T${index + 1}'),
                  ),
                  title: Text('Teacher ${index + 1}'),
                  subtitle: Text('Subject ${index + 1}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final int lessons;
  final String type;
  final double rating;

  CourseCard({required this.title, required this.lessons, required this.type, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text('Lessons: $lessons'),
            Text('Type: $type'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rating: $rating'),
                Icon(Icons.star, color: Colors.yellow),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
