import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class ResourceLibraryScreen extends StatefulWidget {
  const ResourceLibraryScreen({super.key});

  @override
  State<ResourceLibraryScreen> createState() => _ResourceLibraryScreenState();
}

class _ResourceLibraryScreenState extends State<ResourceLibraryScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  final List<Map<String, dynamic>> _resources = [
    {
      'name': 'Mathematics Formulas.pdf',
      'type': 'PDF',
      'subject': 'Mathematics',
      'size': '2.3 MB',
      'uploadDate': '2024-01-15',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
    {
      'name': 'Physics Lab Report.docx',
      'type': 'Document',
      'subject': 'Physics',
      'size': '1.8 MB',
      'uploadDate': '2024-01-14',
      'icon': Icons.description,
      'color': Colors.blue,
    },
    {
      'name': 'Chemistry Notes.pdf',
      'type': 'PDF',
      'subject': 'Chemistry',
      'size': '3.1 MB',
      'uploadDate': '2024-01-13',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
    {
      'name': 'English Essay.pdf',
      'type': 'PDF',
      'subject': 'English',
      'size': '1.2 MB',
      'uploadDate': '2024-01-12',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
    {
      'name': 'History Timeline.pptx',
      'type': 'Presentation',
      'subject': 'History',
      'size': '5.2 MB',
      'uploadDate': '2024-01-11',
      'icon': Icons.slideshow,
      'color': Colors.orange,
    },
    {
      'name': 'Biology Study Guide.pdf',
      'type': 'PDF',
      'subject': 'Biology',
      'size': '4.7 MB',
      'uploadDate': '2024-01-10',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
  ];

  final List<String> _categories = ['All', 'PDFs', 'Documents', 'Presentations', 'Images', 'Videos'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showUploadDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Upload Resource',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4B6CB7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.upload_file,
                  color: Color(0xFF4B6CB7),
                ),
              ),
              title: Text(
                'Choose File',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Select file from device'),
              onTap: () {
                Navigator.pop(context);
                _uploadFile();
              },
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4B6CB7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Color(0xFF4B6CB7),
                ),
              ),
              title: Text(
                'Take Photo',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Capture document or image'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _uploadFile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File upload feature coming soon!'),
        backgroundColor: Color(0xFF4B6CB7),
      ),
    );
  }

  void _takePhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Camera feature coming soon!'),
        backgroundColor: Color(0xFF4B6CB7),
      ),
    );
  }

  void _showStorageInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Storage Information',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Where are your resources stored?',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              '• Local Device Storage: Files are saved on your device\n'
              '• Cloud Backup: Automatic backup to secure cloud storage\n'
              '• Offline Access: Available even without internet\n'
              '• Sync Across Devices: Access from any device',
              style: GoogleFonts.inter(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4B6CB7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.security,
                    color: Color(0xFF4B6CB7),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your files are encrypted and secure',
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
            child: Text(
              'Got it',
              style: GoogleFonts.inter(color: const Color(0xFF4B6CB7)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Resource Library',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4B6CB7),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Color(0xFF4B6CB7)),
            onPressed: _showStorageInfo,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(20),
            child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search resources...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                style: GoogleFonts.inter(fontSize: 16),
                        ),
                      ),
                    ),

          // Category Tabs
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xFF4B6CB7),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
              tabs: _categories.map((category) => Tab(text: category)).toList(),
            ),
          ),

          const SizedBox(height: 20),
          
          // Resources List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((category) {
                return _buildResourcesList(category);
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showUploadDialog,
        backgroundColor: const Color(0xFF4B6CB7),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildResourcesList(String category) {
    List<Map<String, dynamic>> filteredResources = _resources;
    
    if (category != 'All') {
      filteredResources = _resources.where((resource) {
        if (category == 'PDFs') return resource['type'] == 'PDF';
        if (category == 'Documents') return resource['type'] == 'Document';
        if (category == 'Presentations') return resource['type'] == 'Presentation';
        if (category == 'Images') return resource['type'] == 'Image';
        if (category == 'Videos') return resource['type'] == 'Video';
        return true;
      }).toList();
    }

    if (filteredResources.isEmpty) {
      return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 64,
              color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No resources found',
              style: GoogleFonts.poppins(
                            fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
              'Upload your first resource',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
      );
    }

    return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredResources.length,
      itemBuilder: (context, index) {
        final resource = filteredResources[index];
        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
              width: 50,
              height: 50,
                              decoration: BoxDecoration(
                color: resource['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Icon(
                                resource['icon'],
                                color: resource['color'],
                                size: 24,
                              ),
                            ),
                            title: Text(
              resource['name'],
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                                fontSize: 16,
                color: Colors.black87,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                    Text(
                  '${resource['subject']} • ${resource['size']}',
                                      style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                                    Text(
                  'Uploaded: ${resource['uploadDate']}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                    color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
            trailing: PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('Download'),
                            onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Downloading ${resource['name']}'),
                        backgroundColor: const Color(0xFF4B6CB7),
                      ),
                    );
                  },
                ),
                PopupMenuItem(
                  child: const Text('Share'),
                                        onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sharing ${resource['name']}'),
                        backgroundColor: const Color(0xFF4B6CB7),
                      ),
                    );
                  },
                ),
                PopupMenuItem(
                  child: const Text('Delete'),
                                        onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Deleting ${resource['name']}'),
                        backgroundColor: const Color(0xFF4B6CB7),
                      ),
                    );
                                        },
                                      ),
                                    ],
                                  ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening ${resource['name']}'),
                  backgroundColor: const Color(0xFF4B6CB7),
                                ),
                              );
                            },
                        ),
                      );
                    },
    );
  }
}
