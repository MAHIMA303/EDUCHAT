import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/group_service.dart';
import '../constants/app_colors.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final Set<String> _selectedUserIds = {};
  bool _saving = false;

  // Placeholder users for selection UI; in real app, fetch from Firestore
  final List<Map<String, String>> _users = const [
    {'id': 'u1', 'name': 'John Doe'},
    {'id': 'u2', 'name': 'Sarah Wilson'},
    {'id': 'u3', 'name': 'Mike Johnson'},
    {'id': 'u4', 'name': 'Emma Davis'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Select Members', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final u = _users[index];
                  final id = u['id']!;
                  final selected = _selectedUserIds.contains(id);
                  return CheckboxListTile(
                    value: selected,
                    onChanged: (v) {
                      setState(() {
                        if (v == true) {
                          _selectedUserIds.add(id);
                        } else {
                          _selectedUserIds.remove(id);
                        }
                      });
                    },
                    title: Text(u['name']!, style: GoogleFonts.inter()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : () async {
                if (_nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a group name'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }
                
                setState(() { _saving = true; });
                
                try {
                  final service = GroupService();
                  const currentUserId = 'u_current';
                  final group = await service.createGroup(
                    groupName: _nameController.text.trim(),
                    createdBy: currentUserId,
                    memberUserIds: _selectedUserIds.toList(),
                  );
                  
                  if (mounted) {
                    setState(() { _saving = false; });
                    
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Group "${group.groupName}" created successfully!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    
                    // Navigate back with group ID
                    Navigator.pop(context, group.groupId);
                  }
                } catch (e) {
                  if (mounted) {
                    setState(() { _saving = false; });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error creating group: $e'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4B6CB7), foregroundColor: Colors.white),
              child: Text(_saving ? 'Creating...' : 'Create Group'),
            ),
          ),
        ),
      ),
    );
  }
}


