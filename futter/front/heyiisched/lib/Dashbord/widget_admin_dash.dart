import 'package:flutter/material.dart';
/*
class SimpleBarChart extends StatelessWidget {
  final List<double> data;
  final List<String> labels;
  final double maxHeight;

  const SimpleBarChart({
    Key? key,
    required this.data,
    required this.labels,
    this.maxHeight = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double maxValue = data.reduce((a, b) => a > b ? a : b);

    return Container(
      height: maxHeight,
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          data.length,
          (index) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 30,
                height: (data[index] / maxValue) * (maxHeight - 50),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF5C5792),
                      Color(0xFF5C5792).withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                ),
              ),
              SizedBox(height: 8),
              Text(
                labels[index],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.5,
      children: [
        StatCard(
          title: 'Total Enseignants',
          value: '45',
          icon: Icons.people,
          color: Color(0xFF5C5792),
          trend: '+12%',
          subtitle: 'depuis le mois dernier',
        ),
        StatCard(
          title: 'Total Matières',
          value: '28',
          icon: Icons.book,
          color: Color(0xFF9F8DC3),
          trend: '+5%',
          subtitle: 'depuis le mois dernier',
        ),
        StatCard(
          title: 'Total Classes',
          value: '15',
          icon: Icons.school,
          color: Color(0xFF7E6DB3),
          trend: '+8%',
          subtitle: 'depuis le mois dernier',
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  final String subtitle;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.8),
              color,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.white, size: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    trend,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivitySummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activité Hebdomadaire',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5C5792),
              ),
            ),
            SizedBox(height: 20),
            SimpleBarChart(
              data: [30, 45, 25, 50, 35, 40, 45],
              labels: ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'],
            ),
          ],
        ),
      ),
    );
  }
}

class RecentActivities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dernières Activités',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5C5792),
              ),
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildActivityItem(
                  'Nouvelle affectation de cours',
                  'Il y a ${index + 1} heures',
                  Icons.assignment,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF5C5792).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Color(0xFF5C5792)),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/

import 'package:flutter/material.dart';


class GlobalActivitiesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        ],
      ),
    );
  }
}

class DashboardOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatCard('Total Users', '1,234', Color(0XFF5C5792)),
              StatCard('Enseignant', '567', Color.fromARGB(255, 78, 52, 209)),
              StatCard('Admins', '5', Color(0XFF9F8DC3)),
            ],
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  StatCard(this.title, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 16)),
          SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
