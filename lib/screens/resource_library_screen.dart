import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class ResourceLibraryScreen extends StatefulWidget {
  const ResourceLibraryScreen({super.key});

  @override
  State<ResourceLibraryScreen> createState() => _ResourceLibraryScreenState();
}

class _ResourceLibraryScreenState extends State<ResourceLibraryScreen> {
  int _selectedCategory = 0;
  final List<String> _categories = ['All', 'Notes', 'Documents', 'Saved Chats', 'Videos'];
  
  final List<Map<String, dynamic>> _resources = [
    {
      'id': '1',
      'title': 'Calculus Chapter 1 Notes',
      'category': 'Notes',
      'subject': 'Mathematics',
      'fileSize': '2.4 MB',
      'fileType': 'PDF',
      'downloadCount': 156,
      'uploadDate': DateTime.now().subtract(const Duration(days: 3)),
      'icon': Icons.description,
      'color': AppColors.primary,
      'isDownloaded': false,
    },
    {
      'id': '2',
      'title': 'Physics Formula Sheet',
      'category': 'Documents',
      'subject': 'Physics',
      'fileSize': '1.8 MB',
      'fileType': 'PDF',
      'downloadCount': 89,
      'uploadDate': DateTime.now().subtract(const Duration(days: 5)),
      'icon': Icons.science,
      'color': AppColors.warning,
      'isDownloaded': true,
    },
    {
      'id': '3',
      'title': 'Chemistry Lab Safety Guide',
      'category': 'Documents',
      'subject': 'Chemistry',
      'fileSize': '3.2 MB',
      'fileType': 'PDF',
      'downloadCount': 234,
      'uploadDate': DateTime.now().subtract(const Duration(days: 7)),
      'icon': Icons.science,
      'color': AppColors.warning,
      'isDownloaded': false,
    },
    {
      'id': '4',
      'title': 'AI Chat: Calculus Derivatives',
      'category': 'Saved Chats',
      'subject': 'Mathematics',
      'fileSize': '45 KB',
      'fileType': 'Chat',
      'downloadCount': 12,
      'uploadDate': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.chat_bubble,
      'color': AppColors.info,
      'isDownloaded': false,
    },
    {
      'id': '5',
      'title': 'Biology Cell Division Video',
      'category': 'Videos',
      'subject': 'Biology',
      'fileSize': '15.7 MB',
      'fileType': 'MP4',
      'downloadCount': 67,
      'uploadDate': DateTime.now().subtract(const Duration(days: 10)),
      'icon': Icons.video_library,
      'color': AppColors.accent,
      'isDownloaded': false,
    },
    {
      'id': '6',
      'title': 'English Essay Writing Tips',
      'category': 'Notes',
      'subject': 'English',
      'fileSize': '1.1 MB',
      'fileType': 'PDF',
      'downloadCount': 198,
      'uploadDate': DateTime.now().subtract(const Duration(days: 2)),
      'icon': Icons.description,
      'color': AppColors.primary,
      'isDownloaded': false,
    },
    {
      'id': '7',
      'title': 'History Timeline Reference',
      'category': 'Documents',
      'subject': 'History',
      'fileSize': '4.5 MB',
      'fileType': 'PDF',
      'downloadCount': 123,
      'uploadDate': DateTime.now().subtract(const Duration(days: 15)),
      'icon': Icons.science,
      'color': AppColors.warning,
      'isDownloaded': false,
    },
    {
      'id': '8',
      'title': 'AI Chat: Physics Problem Solving',
      'category': 'Saved Chats',
      'subject': 'Physics',
      'fileSize': '32 KB',
      'fileType': 'Chat',
      'downloadCount': 8,
      'uploadDate': DateTime.now().subtract(const Duration(hours: 6)),
      'icon': Icons.chat_bubble,
      'color': AppColors.info,
      'isDownloaded': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredResources {
    if (_selectedCategory == 0) {
      return _resources;
    }
    final category = _categories[_selectedCategory];
    return _resources.where((resource) => resource['category'] == category).toList();
  }

  void _onCategoryTap(int index) {
    setState(() {
      _selectedCategory = index;
    });
  }

  Future<void> _downloadResource(Map<String, dynamic> resource) async {
    // TODO: Implement actual download functionality
    setState(() {
      resource['isDownloaded'] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${resource['title']} downloaded successfully!'),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'Open',
          textColor: Colors.white,
          onPressed: () {
            // TODO: Open downloaded file
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Open file functionality coming soon!'),
                backgroundColor: AppColors.info,
              ),
            );
          },
        ),
      ),
    );
  }

  void _deleteResource(String resourceId) {
    setState(() {
      _resources.removeWhere((resource) => resource['id'] == resourceId);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Resource deleted'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _shareResource(Map<String, dynamic> resource) {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${resource['title']}...'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Resource Library',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.primary),
            onPressed: () {
              // TODO: Implement search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Search functionality coming soon!'),
                  backgroundColor: AppColors.info,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () {
              // TODO: Implement upload functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Upload functionality coming soon!'),
                  backgroundColor: AppColors.info,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: _categories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                final isSelected = index == _selectedCategory;
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onCategoryTap(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        category,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Resources List
          Expanded(
            child: _filteredResources.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 64,
                          color: AppColors.textSecondary.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No resources found',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try selecting a different category',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textSecondary.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredResources.length,
                    itemBuilder: (context, index) {
                      final resource = _filteredResources[index];
                      
                      return Dismissible(
                        key: Key(resource['id']),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                        onDismissed: (direction) {
                          _deleteResource(resource['id']);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: resource['color'].withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                resource['icon'],
                                color: resource['color'],
                                size: 24,
                              ),
                            ),
                            title: Text(
                              resource['title'],
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: resource['color'].withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        resource['subject'],
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: resource['color'],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      resource['fileType'],
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.download,
                                      size: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${resource['downloadCount']}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatDate(resource['uploadDate']),
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  resource['fileSize'],
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (resource['isDownloaded'])
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.success,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  )
                                else
                                  IconButton(
                                    onPressed: () => _downloadResource(resource),
                                    icon: const Icon(
                                      Icons.download,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                  ),
                              ],
                            ),
                            onTap: () {
                              if (resource['isDownloaded']) {
                                // TODO: Open downloaded file
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Open file functionality coming soon!'),
                                    backgroundColor: AppColors.info,
                                  ),
                                );
                              } else {
                                _downloadResource(resource);
                              }
                            },
                            onLongPress: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: AppColors.border,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ListTile(
                                        leading: const Icon(Icons.download, color: AppColors.primary),
                                        title: const Text('Download'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _downloadResource(resource);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.share, color: AppColors.info),
                                        title: const Text('Share'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _shareResource(resource);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.delete, color: AppColors.error),
                                        title: const Text('Delete'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _deleteResource(resource['id']);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
