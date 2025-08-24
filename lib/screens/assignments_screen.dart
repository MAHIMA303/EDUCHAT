import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  final List<Map<String, dynamic>> _assignments = [
    {
      'subject': 'Mathematics',
      'title': 'Quadratic Equations',
      'description': 'Solve problems 1-15 from Chapter 5',
      'dueDate': DateTime.now().add(const Duration(days: 3)),
      'priority': 'High',
      'completed': false,
    },
    {
      'subject': 'Physics',
      'title': 'Newton\'s Laws Lab Report',
      'description': 'Write a detailed report on the experiment',
      'dueDate': DateTime.now().add(const Duration(days: 7)),
      'priority': 'Medium',
      'completed': false,
    },
    {
      'subject': 'Chemistry',
      'title': 'Chemical Reactions Quiz',
      'description': 'Study chapters 8-10 for the quiz',
      'dueDate': DateTime.now().add(const Duration(days: 1)),
      'priority': 'High',
      'completed': false,
    },
    {
      'subject': 'English',
      'title': 'Essay on Shakespeare',
      'description': 'Write a 1000-word essay on Hamlet',
      'dueDate': DateTime.now().add(const Duration(days: 5)),
      'priority': 'Medium',
      'completed': true,
    },
    {
      'subject': 'History',
      'title': 'World War II Timeline',
      'description': 'Create a detailed timeline of major events',
      'dueDate': DateTime.now().add(const Duration(days: 10)),
      'priority': 'Low',
      'completed': false,
    },
  ];

  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Assignments',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4B6CB7),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF4B6CB7)),
            onPressed: () {
              _showSearchDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF4B6CB7)),
            onPressed: () {
              _showChatOptions();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header section
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
                    Icons.assignment,
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
                        _searchQuery.isNotEmpty ? 'Search Results' : 'Track Your Progress',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _searchQuery.isNotEmpty 
                            ? '${_getFilteredAssignments().length} assignments found for "$_searchQuery"'
                            : '${_assignments.length} assignments • ${_assignments.where((a) => a['completed']).length} completed',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                    icon: const Icon(Icons.clear, color: Colors.white),
                    tooltip: 'Clear Search',
                  ),
              ],
            ),
          ),

          // Filter tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterTab('All', _selectedFilter == 'All'),
                ),
                Expanded(
                  child: _buildFilterTab('Pending', _selectedFilter == 'Pending'),
                ),
                Expanded(
                  child: _buildFilterTab('Completed', _selectedFilter == 'Completed'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Assignments list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _getFilteredAssignments().length,
              itemBuilder: (context, index) {
                final assignment = _getFilteredAssignments()[index];
                return _buildAssignmentCard(assignment);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAssignmentDialog();
        },
        backgroundColor: const Color(0xFF4B6CB7),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildFilterTab(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4B6CB7) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assignment) {
    final isCompleted = assignment['completed'] as bool;
    final priority = assignment['priority'] as String;
    final dueDate = assignment['dueDate'] as DateTime;
    
    Color priorityColor;
    switch (priority) {
      case 'High':
        priorityColor = AppColors.error;
        break;
      case 'Medium':
        priorityColor = AppColors.warning;
        break;
      case 'Low':
        priorityColor = AppColors.success;
        break;
      default:
        priorityColor = AppColors.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCompleted 
                  ? AppColors.success.withOpacity(0.3)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              // Header with gradient
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isCompleted
                        ? [AppColors.success.withOpacity(0.8), AppColors.success.withOpacity(0.6)]
                        : [AppColors.gradientBlueStart, AppColors.gradientBlueEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getSubjectIcon(assignment['subject']),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assignment['subject'],
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            priority,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Priority indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: priorityColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        priority,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            assignment['title'],
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                        if (isCompleted)
                          Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 24,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      assignment['description'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDueDate(dueDate),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (!isCompleted) ...[
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context, 
                                    '/assignment-detail',
                                    arguments: assignment,
                                  );
                                },
                                child: Text(
                                  'Submit Assignment',
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () {
                                  _toggleAssignmentStatus(assignment);
                                },
                                child: Text(
                                  'Mark Complete',
                                  style: TextStyle(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                            if (isCompleted)
                              TextButton(
                                onPressed: () {
                                  _toggleAssignmentStatus(assignment);
                                },
                                child: Text(
                                  'Mark Incomplete',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'mathematics':
        return Icons.functions;
      case 'physics':
        return Icons.science;
      case 'chemistry':
        return Icons.science_outlined;
      case 'english':
        return Icons.book;
      case 'history':
        return Icons.history_edu;
      default:
        return Icons.school;
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    
    if (difference.isNegative) {
      return 'Overdue';
    } else if (difference.inDays == 0) {
      return 'Due today';
    } else if (difference.inDays == 1) {
      return 'Due tomorrow';
    } else {
      return 'Due in ${difference.inDays} days';
    }
  }

  void _toggleAssignmentStatus(Map<String, dynamic> assignment) {
    setState(() {
      assignment['completed'] = !assignment['completed'];
    });
  }

  void _showAddAssignmentDialog() {
    Navigator.pushNamed(context, '/add-assignment');
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.search, color: Color(0xFF4B6CB7)),
              title: Text(
                'Search Assignments',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showSearchDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Color(0xFF4B6CB7)),
              title: Text(
                'Notification Settings',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement notification settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive, color: Color(0xFF4B6CB7)),
              title: Text(
                'Archived Assignments',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement archived assignments
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    _searchController.text = _searchQuery;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Search Assignments',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by title, subject, or description...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  Navigator.of(context).pop();
                },
              ),
              if (_searchQuery.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _searchController.clear();
                      });
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Clear Search'),
                  ),
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(color: Colors.grey[600]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = _searchController.text;
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B6CB7),
                foregroundColor: Colors.white,
              ),
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _getFilteredAssignments() {
    List<Map<String, dynamic>> filteredAssignments = _assignments;
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredAssignments = filteredAssignments.where((assignment) {
        final title = assignment['title'].toString().toLowerCase();
        final subject = assignment['subject'].toString().toLowerCase();
        final description = assignment['description'].toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        
        return title.contains(query) || 
               subject.contains(query) || 
               description.contains(query);
      }).toList();
    }
    
    // Apply status filter
    if (_selectedFilter == 'All') {
      return filteredAssignments;
    } else if (_selectedFilter == 'Pending') {
      return filteredAssignments.where((a) => !a['completed']).toList();
    } else if (_selectedFilter == 'Completed') {
      return filteredAssignments.where((a) => a['completed']).toList();
    }
    return filteredAssignments;
  }
}
