import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AITutorScreen extends StatefulWidget {
  const AITutorScreen({super.key});

  @override
  State<AITutorScreen> createState() => _AITutorScreenState();
}

class _AITutorScreenState extends State<AITutorScreen> {
  final List<Map<String, dynamic>> _aiTutors = [
    {
      'id': '1',
      'name': 'MathGPT',
      'specialization': 'Mathematics',
      'description': 'Expert in algebra, calculus, geometry, and statistics',
      'avatar': 'MG',
      'color': Colors.blue,
      'isOnline': true,
      'rating': 4.8,
      'studentsHelped': 1250,
      'subjects': ['Algebra', 'Calculus', 'Geometry', 'Statistics'],
    },
    {
      'id': '2',
      'name': 'PhysicsAI',
      'specialization': 'Physics',
      'description': 'Specialized in mechanics, thermodynamics, and quantum physics',
      'avatar': 'PA',
      'color': Colors.purple,
      'isOnline': true,
      'rating': 4.9,
      'studentsHelped': 980,
      'subjects': ['Mechanics', 'Thermodynamics', 'Quantum Physics', 'Electromagnetism'],
    },
    {
      'id': '3',
      'name': 'ChemBot',
      'specialization': 'Chemistry',
      'description': 'Master of organic chemistry, inorganic chemistry, and biochemistry',
      'avatar': 'CB',
      'color': Colors.green,
      'isOnline': false,
      'rating': 4.7,
      'studentsHelped': 750,
      'subjects': ['Organic Chemistry', 'Inorganic Chemistry', 'Biochemistry', 'Analytical Chemistry'],
    },
    {
      'id': '4',
      'name': 'BioAI',
      'specialization': 'Biology',
      'description': 'Expert in cell biology, genetics, and evolutionary biology',
      'avatar': 'BA',
      'color': Colors.orange,
      'isOnline': true,
      'rating': 4.6,
      'studentsHelped': 620,
      'subjects': ['Cell Biology', 'Genetics', 'Evolutionary Biology', 'Ecology'],
    },
    {
      'id': '5',
      'name': 'EnglishTutor',
      'specialization': 'English Literature',
      'description': 'Specialized in literature analysis, writing, and grammar',
      'avatar': 'ET',
      'color': Colors.red,
      'isOnline': true,
      'rating': 4.5,
      'studentsHelped': 890,
      'subjects': ['Literature Analysis', 'Essay Writing', 'Grammar', 'Creative Writing'],
    },
    {
      'id': '6',
      'name': 'HistoryAI',
      'specialization': 'History',
      'description': 'Expert in world history, political science, and cultural studies',
      'avatar': 'HA',
      'color': Colors.brown,
      'isOnline': false,
      'rating': 4.4,
      'studentsHelped': 450,
      'subjects': ['World History', 'Political Science', 'Cultural Studies', 'Geography'],
    },
  ];

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Online', 'Mathematics', 'Physics', 'Chemistry', 'Biology', 'English', 'History'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'AI Tutors',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4B6CB7),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Color(0xFF4B6CB7)),
            onPressed: _showAIInfo,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4B6CB7), Color(0xFF182848)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4B6CB7).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.smart_toy,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Learning Assistants',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${_aiTutors.length} specialized AI tutors available',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Filter Chips
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(
                      filter,
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : const Color(0xFF4B6CB7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFF4B6CB7),
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF4B6CB7) : Colors.grey[300]!,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // AI Tutors List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _getFilteredTutors().length,
              itemBuilder: (context, index) {
                final tutor = _getFilteredTutors()[index];
                return _buildTutorCard(tutor);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredTutors() {
    if (_selectedFilter == 'All') {
      return _aiTutors;
    } else if (_selectedFilter == 'Online') {
      return _aiTutors.where((tutor) => tutor['isOnline']).toList();
    } else {
      return _aiTutors.where((tutor) => tutor['specialization'] == _selectedFilter).toList();
    }
  }

  Widget _buildTutorCard(Map<String, dynamic> tutor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tutor Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [tutor['color'], tutor['color'].withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          tutor['avatar'],
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    if (tutor['isOnline'])
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              tutor['name'],
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: tutor['color'].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tutor['specialization'],
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: tutor['color'],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tutor['description'],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${tutor['rating']}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.people,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${tutor['studentsHelped']} students',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Subjects
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (tutor['subjects'] as List<String>).map((subject) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    subject,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: tutor['isOnline'] ? () => _startChat(tutor) : null,
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: Text(
                      'Start Chat',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B6CB7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showTutorDetails(tutor),
                    icon: const Icon(Icons.info_outline),
                    label: Text(
                      'Details',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4B6CB7),
                      side: const BorderSide(color: Color(0xFF4B6CB7)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startChat(Map<String, dynamic> tutor) {
    Navigator.pushNamed(
      context,
      '/chat-detail',
      arguments: {'chatTitle': tutor['name']},
    );
  }

  void _showTutorDetails(Map<String, dynamic> tutor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          tutor['name'],
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Specialization: ${tutor['specialization']}',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              tutor['description'],
              style: GoogleFonts.inter(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              'Subjects Covered:',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...(tutor['subjects'] as List<String>).map((subject) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(subject, style: GoogleFonts.inter(fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${tutor['rating']} rating'),
                const SizedBox(width: 16),
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${tutor['studentsHelped']} students helped'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.inter(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startChat(tutor);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4B6CB7)),
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  void _showAIInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'About AI Tutors',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Our AI tutors are specialized in different subjects and can help you with:',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildInfoItem('• Instant homework help and explanations'),
            _buildInfoItem('• Step-by-step problem solving'),
            _buildInfoItem('• Concept clarification and examples'),
            _buildInfoItem('• Practice questions and quizzes'),
            _buildInfoItem('• 24/7 availability'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4B6CB7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.security, color: Color(0xFF4B6CB7), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'All conversations are private and secure',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF4B6CB7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it', style: GoogleFonts.inter(color: const Color(0xFF4B6CB7))),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 14),
      ),
    );
  }
}
