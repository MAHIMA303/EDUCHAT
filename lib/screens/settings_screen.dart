import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Temporarily disabled
import '../services/role_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'English';
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _isTeacher = false;
  bool _roleLoaded = false;

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Preferences',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            
            if (_roleLoaded && (_isTeacher || kDebugMode)) ...[
              _buildSectionHeader('Teacher', Icons.analytics, 100),
              Card(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.analytics,
                      color: AppColors.primaryBlue,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    'Analytics Dashboard',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    kDebugMode ? 'Track student engagement metrics (Demo Mode)' : 'Track student engagement metrics',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.pushNamed(context, '/analytics'),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: AppColors.primaryPurple,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    'Collaborative Whiteboard',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Real-time collaborative drawing and editing',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.pushNamed(context, '/whiteboard'),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Appearance section
            _buildSectionHeader('Appearance', Icons.palette, 0),
            _buildSwitchTile(
              'Dark Mode',
              'Switch between light and dark themes',
              Icons.dark_mode,
              _isDarkMode,
              (value) {
                setState(() {
                  _isDarkMode = value;
                });
                // TODO: Implement theme switching
              },
              1,
            ),
            
            const SizedBox(height: 20),
            
            // Language section
            _buildSectionHeader('Language', Icons.language, 2),
            _buildDropdownTile(
              'Language',
              'Choose your preferred language',
              Icons.translate,
              _selectedLanguage,
              _languages,
              (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                // TODO: Implement language switching
              },
              3,
            ),
            
            const SizedBox(height: 20),
            
            // Notifications section
            _buildSectionHeader('Notifications', Icons.notifications, 4),
            _buildSwitchTile(
              'Enable Notifications',
              'Receive push notifications for new messages',
              Icons.notifications_active,
              _notificationsEnabled,
              (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                // TODO: Implement notification settings
              },
              5,
            ),
            
            if (_notificationsEnabled) ...[
              const SizedBox(height: 16),
              _buildSwitchTile(
                'Sound',
                'Play sound for notifications',
                Icons.volume_up,
                _soundEnabled,
                (value) {
                  setState(() {
                    _soundEnabled = value;
                  });
                },
                6,
              ),
              
              const SizedBox(height: 16),
              _buildSwitchTile(
                'Vibration',
                'Vibrate for notifications',
                Icons.vibration,
                _vibrationEnabled,
                (value) {
                  setState(() {
                    _vibrationEnabled = value;
                  });
                },
                7,
              ),
            ],
            
            const SizedBox(height: 20),
            
            // Privacy section
            _buildSectionHeader('Privacy & Security', Icons.security, 8),
            _buildActionTile(
              'Change Password',
              'Update your account password',
              Icons.lock,
              AppColors.primaryBlue,
              () {
                // TODO: Implement password change
              },
              9,
            ),
            
            const SizedBox(height: 16),
            
            _buildActionTile(
              'Privacy Policy',
              'Read our privacy policy',
              Icons.privacy_tip,
              AppColors.info,
              () {
                // TODO: Show privacy policy
              },
              10,
            ),
            
            const SizedBox(height: 16),
            
            _buildActionTile(
              'Terms of Service',
              'Read our terms of service',
              Icons.description,
              AppColors.info,
              () {
                // TODO: Show terms of service
              },
              11,
            ),
            
            const SizedBox(height: 20),
            
            // Integration section
            _buildSectionHeader('Integrations', Icons.link, 12),
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.cloud_sync,
                    color: AppColors.success,
                    size: 24,
                  ),
                ),
                title: Text(
                  'External Services',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Connect Google Classroom, Drive, and LMS systems',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.pushNamed(context, '/external-services'),
              ),
            ),
            const SizedBox(height: 20),
            
            // Support section
            _buildSectionHeader('Support', Icons.help, 13),
            _buildActionTile(
              'Help Center',
              'Get help and find answers',
              Icons.help_center,
              AppColors.success,
              () {
                // TODO: Open help center
              },
              14,
            ),
            
            const SizedBox(height: 16),
            
            _buildActionTile(
              'Contact Support',
              'Get in touch with our team',
              Icons.support_agent,
              AppColors.primaryPurple,
              () {
                // TODO: Contact support
              },
              15,
            ),
            
            const SizedBox(height: 16),
            
            _buildActionTile(
              'Report a Bug',
              'Help us improve by reporting issues',
              Icons.bug_report,
              AppColors.warning,
              () {
                // TODO: Report bug
              },
              16,
            ),
            
            const SizedBox(height: 20),
            
            // About section
            _buildSectionHeader('About', Icons.info, 17),
            _buildInfoTile(
              'App Version',
              '1.0.0',
              Icons.info,
              18,
            ),
            
            const SizedBox(height: 16),
            
            _buildInfoTile(
              'Build Number',
              '2024.1.0',
              Icons.build,
              19,
            ),
            
            const SizedBox(height: 20),
            
            // Encryption Demo Section
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.security,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                title: Text(
                  'Encryption Demo',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Test AES-256 message encryption',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pushNamed(context, '/encryption-demo');
                },
              ),
            ),

            // Logout button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    try {
      // final uid = FirebaseAuth.instance.currentUser?.uid ?? 'u_current';
      final uid = 'u_current'; // Temporarily use static user ID
      final role = await RoleService().getCurrentUserRole(uid);
      if (!mounted) return;
      setState(() {
        _isTeacher = role == UserRole.teacher;
        _roleLoaded = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isTeacher = false;
        _roleLoaded = true;
      });
    }
  }

  Widget _buildSectionHeader(String title, IconData icon, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryBlue,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryBlue,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildDropdownTile(String title, String subtitle, IconData icon, String value, List<String> options, ValueChanged<String?> onChanged, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryPurple,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          underline: Container(),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, Color color, VoidCallback onTap, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textSecondary,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/auth');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
