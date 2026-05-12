import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mock_data.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String role = 'student';

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => role = prefs.getString('userRole') ?? 'student');
  }

  @override
  Widget build(BuildContext context) {
    bool isCreator = role == 'creator';
    String userName = "LearnLab";

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle, color: Colors.black),
          ),
          IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back, $userName ${isCreator ? 'Creator' : 'Student'}!",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            // Creator Overview
            if (isCreator) ...[
              _buildCreatorOverview(),
              const SizedBox(height: 32),
            ],
            // Recommended Courses
            _buildRecommendedCourses(),
            const SizedBox(height: 32),
            // Bottom List (Inventory or Learning)
            isCreator ? _buildCreatorInventory() : _buildStudentCourses(),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatorOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Overview",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth < 400 ? 2 : 3;
            final spacing = 16.0;
            final cardWidth =
                (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
                crossAxisCount;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                _statCard(
                  "Revenue",
                  "\$24,890",
                  cardWidth,
                  subtitle: "+12% this month",
                ),
                _statCard(
                  "Students",
                  "1,820",
                  cardWidth,
                  subtitle: "+148 this week",
                ),
                _statCard(
                  "Courses",
                  "2",
                  cardWidth,
                  subtitle: "2 published · 0 draft",
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _statCard(
    String label,
    String value,
    double width, {
    String? subtitle,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              maxLines: 1,
              softWrap: false,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendedCourses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recommended Courses",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "View All",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: 2,
          itemBuilder: (context, index) {
            final c = index < studentCourses.length
                ? studentCourses[index]
                : creatorCourses[0];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Icon(Icons.image, color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "\$${c.price}",
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCreatorInventory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "MY COURSES (INVENTORY)",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...creatorCourses.map((c) => _courseListTile(c, showInstructor: false)),
      ],
    );
  }

  Widget _buildStudentCourses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "MY LEARNING",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...studentCourses.map((c) => _courseListTile(c, showInstructor: true)),
      ],
    );
  }

  Widget _courseListTile(Course c, {bool showInstructor = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.class_outlined, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  showInstructor ? c.instructor : "\$${c.price}",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              c.status.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 24),
          Text("${c.students}", style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 16),
          const Icon(Icons.more_horiz),
        ],
      ),
    );
  }
}
