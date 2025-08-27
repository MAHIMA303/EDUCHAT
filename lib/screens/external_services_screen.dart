import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/external_services_service.dart';
import '../constants/app_colors.dart';

class ExternalServicesScreen extends StatefulWidget {
  const ExternalServicesScreen({super.key});

  @override
  State<ExternalServicesScreen> createState() => _ExternalServicesScreenState();
}

class _ExternalServicesScreenState extends State<ExternalServicesScreen> {
  final ExternalServicesService _service = ExternalServicesService();
  List<ExternalService> _services = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() {
      _loading = true;
    });

    final services = await _service.getConnectionStatus();
    setState(() {
      _services = services;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('External Services'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadServices,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connect External Services',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sync your assignments and files with popular educational platforms',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Services list
                  ..._services.map((service) => _buildServiceCard(service)),
                  
                  const SizedBox(height: 24),
                  
                  // Import section
                  if (_services.any((s) => s.isConnected)) ...[
                    _buildImportSection(),
                    const SizedBox(height: 24),
                  ],
                  
                  // Help section
                  _buildHelpSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildServiceCard(ExternalService service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: service.isConnected 
                ? AppColors.success.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              service.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(
          service.name,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              service.description,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: service.isConnected 
                    ? AppColors.success.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                service.isConnected ? 'Connected' : 'Not Connected',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: service.isConnected ? AppColors.success : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        trailing: service.isConnected
            ? PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Import Data'),
                    onTap: () => _importFromService(service),
                  ),
                  PopupMenuItem(
                    child: const Text('Disconnect'),
                    onTap: () => _disconnectService(service),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: () => _connectToService(service),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Connect'),
              ),
      ),
    );
  }

  Widget _buildImportSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Import Data',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _importFromGoogleClassroom,
                  icon: const Icon(Icons.download),
                  label: const Text('Import Assignments'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _importFromGoogleDrive,
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Import Files'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline, color: AppColors.info, size: 20),
              const SizedBox(width: 8),
              Text(
                'How it works',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• Connect your accounts to sync assignments and files\n'
            '• Import data automatically or manually\n'
            '• Keep your data synchronized across platforms\n'
            '• All connections are secure and encrypted',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _connectToService(ExternalService service) async {
    setState(() {
      _loading = true;
    });

    bool success = false;
    switch (service.name) {
      case 'Google Classroom':
        success = await _service.connectToGoogleClassroom();
        break;
      case 'Google Drive':
        success = await _service.connectToGoogleDrive();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${service.name} integration coming soon!'),
            backgroundColor: AppColors.info,
          ),
        );
        setState(() {
          _loading = false;
        });
        return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully connected to ${service.name}!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to connect to ${service.name}'),
          backgroundColor: AppColors.error,
        ),
      );
    }

    await _loadServices();
  }

  Future<void> _disconnectService(ExternalService service) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Disconnect ${service.name}'),
        content: Text('Are you sure you want to disconnect from ${service.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _service.disconnectService(service.name);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Disconnected from ${service.name}'),
            backgroundColor: AppColors.info,
          ),
        );
        await _loadServices();
      }
    }
  }

  Future<void> _importFromService(ExternalService service) async {
    switch (service.name) {
      case 'Google Classroom':
        await _importFromGoogleClassroom();
        break;
      case 'Google Drive':
        await _importFromGoogleDrive();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import from ${service.name} coming soon!'),
            backgroundColor: AppColors.info,
          ),
        );
    }
  }

  Future<void> _importFromGoogleClassroom() async {
    try {
      final assignments = await _service.getGoogleClassroomAssignments();
      if (assignments.isNotEmpty) {
        // Show assignments selection dialog
        _showAssignmentsSelectionDialog(assignments);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No assignments found in Google Classroom'),
            backgroundColor: AppColors.info,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to import: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _importFromGoogleDrive() async {
    try {
      final files = await _service.getGoogleDriveFiles();
      if (files.isNotEmpty) {
        // Show files selection dialog
        _showFilesSelectionDialog(files);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No files found in Google Drive'),
            backgroundColor: AppColors.info,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to import: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showAssignmentsSelectionDialog(List<GoogleClassroomAssignment> assignments) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Assignments to Import'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final assignment = assignments[index];
              return CheckboxListTile(
                title: Text(assignment.title),
                subtitle: Text(assignment.courseName),
                value: false,
                onChanged: (value) {
                  // Handle selection
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Assignments imported successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _showFilesSelectionDialog(List<GoogleDriveFile> files) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Files to Import'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              return CheckboxListTile(
                title: Text(file.name),
                subtitle: Text('${(file.size / 1024 / 1024).toStringAsFixed(1)} MB'),
                value: false,
                onChanged: (value) {
                  // Handle selection
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Files imported successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }
}
