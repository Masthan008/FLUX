import 'package:flutter/material.dart';
import 'package:fluxflow/data/engineering_data.dart';
import 'package:fluxflow/screens/engineering/topic_viewer_screen.dart';
import 'package:fluxflow/data/model_data.dart';
import 'package:fluxflow/screens/engineering/model_viewer_screen.dart';

class EngineeringHub extends StatelessWidget {
  const EngineeringHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Engineering Hub 📚",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade900, Colors.blue.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Master Engineering Graphics",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Offline diagrams with step-by-step procedures",
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatChip("📐 Mechanical", Colors.amber),
                    const SizedBox(width: 8),
                    _buildStatChip("🏗️ Civil", Colors.orange),
                    const SizedBox(width: 8),
                    _buildStatChip("💻 CSE", Colors.blue),
                  ],
                ),
              ],
            ),
          ),

          // 3D Models Section
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.view_in_ar,
                      color: Colors.cyanAccent,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Interactive 3D Models",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Explore engineering models with AR support",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 15),
                ...my3DModels.map((model) => Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Colors.cyanAccent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.cyanAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.view_in_ar,
                        color: Colors.cyanAccent,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      model.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      model.dimensions,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ModelViewerScreen(model: model),
                        ),
                      );
                    },
                  ),
                )).toList(),
              ],
            ),
          ),

          // Branch Cards
          // 📐 FIRST YEAR GRAPHICS (NEW)
          _buildBranchCard(
            context,
            "Engineering Graphics (1st Year)",
            Colors.tealAccent,
            Icons.architecture,
            EngineeringData.graphicsTopics,
            "Curves, Projections & Development",
          ),
          _buildBranchCard(
            context,
            "Mechanical Engineering",
            Colors.amber,
            Icons.settings,
            EngineeringData.mechTopics,
            "Engineering Graphics & Design",
          ),
          _buildBranchCard(
            context,
            "Civil Engineering",
            Colors.orange,
            Icons.foundation,
            EngineeringData.civilTopics,
            "Structural Analysis & Design",
          ),
          _buildBranchCard(
            context,
            "Computer Science (CSE)",
            Colors.blueAccent,
            Icons.computer,
            EngineeringData.cseTopics,
            "Data Structures & Algorithms",
          ),
          _buildBranchCard(
            context,
            "Electronics (ECE/EEE)",
            Colors.purpleAccent,
            Icons.electrical_services,
            EngineeringData.eceTopics,
            "Circuit Analysis & Digital Design",
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBranchCard(
    BuildContext context,
    String title,
    Color color,
    IconData icon,
    List<EngineeringTopic> topics,
    String subtitle,
  ) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3), width: 1),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          "$subtitle • ${topics.length} Topics",
          style: TextStyle(color: Colors.grey[400], fontSize: 13),
        ),
        iconColor: color,
        collapsedIconColor: color.withOpacity(0.7),
        children: topics.map((topic) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[800]!, width: 0.5),
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              title: Text(
                topic.title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.article_outlined,
                  color: color.withOpacity(0.7),
                  size: 20,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey[600],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TopicViewerScreen(topic: topic),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
