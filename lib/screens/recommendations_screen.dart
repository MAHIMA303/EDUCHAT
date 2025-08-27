import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Temporarily disabled
import '../models/recommendation.dart';
import '../models/group.dart';
import '../services/recommendation_service.dart';
import '../constants/app_colors.dart';
import '../widgets/offline_banner.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  RecommendationService? _recommendationService;
  final String _currentUserId = 'u_current'; // Replace with actual user ID
  final String _currentUsername = 'John Doe'; // Replace with actual username
  
  String _selectedFilter = 'All';
  bool _isGenerating = false;

  final List<String> _filterOptions = [
    'All',
    'Learning Resources',
    'Chat Groups',
    'Study Topics',
    'Assignments',
    'AI Tutor',
  ];

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _recommendationService = RecommendationService();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Recommendations',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4B6CB7),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF4B6CB7)),
            onPressed: _refreshRecommendations,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF4B6CB7)),
            onPressed: _showOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filterOptions.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : Colors.grey[600],
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Generate new recommendations button
          if (_selectedFilter == 'All')
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton.icon(
                onPressed: _isGenerating ? null : _generateNewRecommendations,
                icon: _isGenerating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(_isGenerating ? 'Generating...' : 'Generate New Recommendations'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),

                    // Recommendations list
          Expanded(
            child: _recommendationService == null
                ? const Center(
                    child: Text(
                      'Recommendations not available on web',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : StreamBuilder<List<Recommendation>>(
                    stream: _recommendationService!.getUserRecommendations(_currentUserId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'Error loading recommendations',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: _refreshRecommendations,
                                child: const Text('Try Again'),
                              ),
                            ],
                          ),
                        );
                      }

                      final recommendations = snapshot.data ?? [];
                      final filteredRecommendations = _filterRecommendations(recommendations);

                      if (filteredRecommendations.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lightbulb_outline, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text(
                                'No recommendations yet',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap the button above to generate personalized recommendations',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredRecommendations.length,
                        itemBuilder: (context, index) {
                          return _buildRecommendationCard(filteredRecommendations[index]);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Filter recommendations based on selected filter
  List<Recommendation> _filterRecommendations(List<Recommendation> recommendations) {
    if (_selectedFilter == 'All') return recommendations;
    
    final filterMap = {
      'Learning Resources': RecommendationType.learningResource,
      'Chat Groups': RecommendationType.chatGroup,
      'Study Topics': RecommendationType.studyTopic,
      'Assignments': RecommendationType.assignment,
      'AI Tutor': RecommendationType.aiTutor,
    };
    
    final targetType = filterMap[_selectedFilter];
    if (targetType == null) return recommendations;
    
    return recommendations.where((rec) => rec.type == targetType).toList();
  }

  // Build recommendation card
  Widget _buildRecommendationCard(Recommendation recommendation) {
    final priorityColor = _getPriorityColor(recommendation.priority);
    final typeIcon = _getTypeIcon(recommendation.type);
    final typeColor = _getTypeColor(recommendation.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: priorityColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _onRecommendationTap(recommendation),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(typeIcon, color: typeColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation.title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          _getTypeLabel(recommendation.type),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Priority indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      recommendation.priority.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: priorityColor,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Description
              Text(
                recommendation.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Metadata row
              if (recommendation.metadata.isNotEmpty)
                Row(
                  children: [
                    if (recommendation.metadata['subject'] != null)
                      _buildMetadataChip(
                        'Subject',
                        recommendation.metadata['subject'],
                        Colors.blue,
                      ),
                    if (recommendation.metadata['difficulty'] != null)
                      _buildMetadataChip(
                        'Difficulty',
                        recommendation.metadata['difficulty'],
                        Colors.orange,
                      ),
                    if (recommendation.metadata['estimatedTime'] != null)
                      _buildMetadataChip(
                        'Time',
                        '${recommendation.metadata['estimatedTime']} min',
                        Colors.green,
                      ),
                  ],
                ),
              
              const SizedBox(height: 12),
              
              // Footer row
              Row(
                children: [
                  // Confidence score
                  Row(
                    children: [
                      Icon(Icons.psychology, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        '${(recommendation.confidenceScore * 100).toInt()}% confident',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Action buttons
                  if (!recommendation.isRead)
                    TextButton(
                      onPressed: () => _markAsRead(recommendation.id),
                      child: const Text('Mark Read'),
                    ),
                  
                  if (!recommendation.isAccepted)
                    ElevatedButton(
                      onPressed: () => _acceptRecommendation(recommendation.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Accept'),
                    ),
                  
                  if (recommendation.isAccepted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 16, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            'Accepted',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build metadata chip
  Widget _buildMetadataChip(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Get priority color
  Color _getPriorityColor(RecommendationPriority priority) {
    switch (priority) {
      case RecommendationPriority.low:
        return Colors.green;
      case RecommendationPriority.medium:
        return Colors.orange;
      case RecommendationPriority.high:
        return Colors.red;
      case RecommendationPriority.urgent:
        return Colors.purple;
    }
  }

  // Get type icon
  IconData _getTypeIcon(RecommendationType type) {
    switch (type) {
      case RecommendationType.learningResource:
        return Icons.book;
      case RecommendationType.chatGroup:
        return Icons.group;
      case RecommendationType.studyTopic:
        return Icons.school;
      case RecommendationType.assignment:
        return Icons.assignment;
      case RecommendationType.aiTutor:
        return Icons.smart_toy;
    }
  }

  // Get type color
  Color _getTypeColor(RecommendationType type) {
    switch (type) {
      case RecommendationType.learningResource:
        return Colors.blue;
      case RecommendationType.chatGroup:
        return Colors.green;
      case RecommendationType.studyTopic:
        return Colors.orange;
      case RecommendationType.assignment:
        return Colors.red;
      case RecommendationType.aiTutor:
        return Colors.purple;
    }
  }

  // Get type label
  String _getTypeLabel(RecommendationType type) {
    switch (type) {
      case RecommendationType.learningResource:
        return 'Learning Resource';
      case RecommendationType.chatGroup:
        return 'Chat Group';
      case RecommendationType.studyTopic:
        return 'Study Topic';
      case RecommendationType.assignment:
        return 'Assignment';
      case RecommendationType.aiTutor:
        return 'AI Tutor Session';
    }
  }

  // Handle recommendation tap
  void _onRecommendationTap(Recommendation recommendation) {
    // Mark as read if not already read
    if (!recommendation.isRead) {
      _markAsRead(recommendation.id);
    }
    
    // Navigate based on recommendation type
    switch (recommendation.type) {
      case RecommendationType.learningResource:
        _showResourceDetails(recommendation);
        break;
      case RecommendationType.chatGroup:
        _navigateToChatGroups();
        break;
      case RecommendationType.studyTopic:
        _showStudyTopicDetails(recommendation);
        break;
      case RecommendationType.assignment:
        _navigateToAssignments();
        break;
      case RecommendationType.aiTutor:
        _navigateToAITutor();
        break;
    }
  }

  // Generate new recommendations
  Future<void> _generateNewRecommendations() async {
    if (_recommendationService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recommendations not available on web'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      // Mock data for demonstration - replace with actual data
      final mockAssignments = [
        {'subject': 'Mathematics'},
        {'subject': 'Physics'},
        {'subject': 'Chemistry'},
      ];
      
      final mockGroups = <Group>[
        Group(
          groupId: 'g1',
          groupName: 'Math Study Group',
          members: ['user1', 'user2'],
          createdBy: 'user1',
          createdAt: DateTime.now(), // Temporarily use DateTime instead of Timestamp
        ),
      ];

      await _recommendationService!.generateRecommendations(
        userId: _currentUserId,
        username: _currentUsername,
        assignments: mockAssignments,
        groups: mockGroups,
        limit: 5,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New recommendations generated!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating recommendations: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  // Mark recommendation as read
  Future<void> _markAsRead(String recommendationId) async {
    if (_recommendationService == null) return;
    
    try {
      await _recommendationService!.markAsRead(recommendationId);
    } catch (e) {
      print('Error marking as read: $e');
    }
  }

  // Accept recommendation
  Future<void> _acceptRecommendation(String recommendationId) async {
    if (_recommendationService == null) return;
    
    try {
      await _recommendationService!.markAsAccepted(recommendationId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recommendation accepted!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error accepting recommendation: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Refresh recommendations
  void _refreshRecommendations() {
    setState(() {});
  }

  // Show options menu
  void _showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Recommendation Settings'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('View History'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to history
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & FAQ'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show help
              },
            ),
          ],
        ),
      ),
    );
  }

  // Show resource details
  void _showResourceDetails(Recommendation recommendation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(recommendation.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recommendation.description),
            const SizedBox(height: 16),
            if (recommendation.metadata['subject'] != null)
              Text('Subject: ${recommendation.metadata['subject']}'),
            if (recommendation.metadata['difficulty'] != null)
              Text('Difficulty: ${recommendation.metadata['difficulty']}'),
            if (recommendation.metadata['estimatedTime'] != null)
              Text('Estimated Time: ${recommendation.metadata['estimatedTime']} minutes'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Open resource
            },
            child: const Text('Open Resource'),
          ),
        ],
      ),
    );
  }

  // Show study topic details
  void _showStudyTopicDetails(Recommendation recommendation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(recommendation.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recommendation.description),
            const SizedBox(height: 16),
            if (recommendation.metadata['subject'] != null)
              Text('Subject: ${recommendation.metadata['subject']}'),
            if (recommendation.metadata['difficulty'] != null)
              Text('Difficulty: ${recommendation.metadata['difficulty']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Start study session
            },
            child: const Text('Start Studying'),
          ),
        ],
      ),
    );
  }

  // Navigate to chat groups
  void _navigateToChatGroups() {
    // TODO: Navigate to chat groups screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Chat Groups')),
    );
  }

  // Navigate to assignments
  void _navigateToAssignments() {
    // TODO: Navigate to assignments screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Assignments')),
    );
  }

  // Navigate to AI tutor
  void _navigateToAITutor() {
    // TODO: Navigate to AI tutor screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to AI Tutor')),
    );
  }
}
