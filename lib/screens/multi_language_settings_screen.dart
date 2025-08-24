import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class MultiLanguageSettingsScreen extends StatefulWidget {
  const MultiLanguageSettingsScreen({super.key});

  @override
  State<MultiLanguageSettingsScreen> createState() => _MultiLanguageSettingsScreenState();
}

class _MultiLanguageSettingsScreenState extends State<MultiLanguageSettingsScreen> {
  String _selectedLanguage = 'English';
  bool _isLoading = false;
  
  final List<Map<String, dynamic>> _languages = [
    {
      'name': 'English',
      'nativeName': 'English',
      'code': 'en',
      'flag': '🇺🇸',
      'isAvailable': true,
    },
    {
      'name': 'Spanish',
      'nativeName': 'Español',
      'code': 'es',
      'flag': '🇪🇸',
      'isAvailable': true,
    },
    {
      'name': 'French',
      'nativeName': 'Français',
      'code': 'fr',
      'flag': '🇫🇷',
      'isAvailable': true,
    },
    {
      'name': 'German',
      'nativeName': 'Deutsch',
      'code': 'de',
      'flag': '🇩🇪',
      'isAvailable': true,
    },
    {
      'name': 'Italian',
      'nativeName': 'Italiano',
      'code': 'it',
      'flag': '🇮🇹',
      'isAvailable': true,
    },
    {
      'name': 'Portuguese',
      'nativeName': 'Português',
      'code': 'pt',
      'flag': '🇵🇹',
      'isAvailable': true,
    },
    {
      'name': 'Russian',
      'nativeName': 'Русский',
      'code': 'ru',
      'flag': '🇷🇺',
      'isAvailable': false,
    },
    {
      'name': 'Chinese (Simplified)',
      'nativeName': '中文 (简体)',
      'code': 'zh-CN',
      'flag': '🇨🇳',
      'isAvailable': false,
    },
    {
      'name': 'Japanese',
      'nativeName': '日本語',
      'code': 'ja',
      'flag': '🇯🇵',
      'isAvailable': false,
    },
    {
      'name': 'Korean',
      'nativeName': '한국어',
      'code': 'ko',
      'flag': '🇰🇷',
      'isAvailable': false,
    },
    {
      'name': 'Arabic',
      'nativeName': 'العربية',
      'code': 'ar',
      'flag': '🇸🇦',
      'isAvailable': false,
    },
    {
      'name': 'Hindi',
      'nativeName': 'हिन्दी',
      'code': 'hi',
      'flag': '🇮🇳',
      'isAvailable': false,
    },
  ];

  final Map<String, Map<String, String>> _previewTexts = {
    'en': {
      'welcome': 'Welcome to EduChat',
      'subtitle': 'Your AI Study Buddy',
      'description': 'Get instant help with your studies, track assignments, and boost your learning with AI-powered tutoring.',
    },
    'es': {
      'welcome': 'Bienvenido a EduChat',
      'subtitle': 'Tu Compañero de Estudio IA',
      'description': 'Obtén ayuda instantánea con tus estudios, rastrea tareas y mejora tu aprendizaje con tutoría impulsada por IA.',
    },
    'fr': {
      'welcome': 'Bienvenue sur EduChat',
      'subtitle': 'Votre Compagnon d\'Étude IA',
      'description': 'Obtenez une aide instantanée pour vos études, suivez vos devoirs et améliorez votre apprentissage avec un tutorat alimenté par l\'IA.',
    },
    'de': {
      'welcome': 'Willkommen bei EduChat',
      'subtitle': 'Ihr KI-Lernbegleiter',
      'description': 'Erhalten Sie sofortige Hilfe bei Ihren Studien, verfolgen Sie Aufgaben und verbessern Sie Ihr Lernen mit KI-gestütztem Tutoring.',
    },
    'it': {
      'welcome': 'Benvenuto su EduChat',
      'subtitle': 'Il Tuo Compagno di Studio IA',
      'description': 'Ottieni aiuto istantaneo per i tuoi studi, traccia i compiti e migliora il tuo apprendimento con il tutoraggio alimentato dall\'IA.',
    },
    'pt': {
      'welcome': 'Bem-vindo ao EduChat',
      'subtitle': 'Seu Companheiro de Estudo IA',
      'description': 'Obtenha ajuda instantânea para seus estudos, acompanhe tarefas e melhore seu aprendizado com tutoria alimentada por IA.',
    },
  };

  String get _currentLanguageCode {
    final language = _languages.firstWhere((lang) => lang['name'] == _selectedLanguage);
    return language['code'];
  }

  Map<String, String> get _currentPreviewText {
    return _previewTexts[_currentLanguageCode] ?? _previewTexts['en']!;
  }

  Future<void> _changeLanguage(String languageName) async {
    if (languageName == _selectedLanguage) return;
    
    setState(() {
      _isLoading = true;
    });

    // Simulate language change process
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _selectedLanguage = languageName;
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Language changed to $languageName'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Language Settings',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Language Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Language',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        _getCurrentLanguageFlag(),
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedLanguage,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              _getCurrentLanguageNativeName(),
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Active',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Language Selection
            Text(
              'Select Language',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  final language = _languages[index];
                  final isSelected = language['name'] == _selectedLanguage;
                  final isAvailable = language['isAvailable'];
                  
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.border,
                          width: index == _languages.length - 1 ? 0 : 1,
                        ),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Text(
                        language['flag'],
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  language['name'],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isAvailable 
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary.withValues(alpha: 0.5),
                                  ),
                                ),
                                Text(
                                  language['nativeName'],
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: isAvailable 
                                        ? AppColors.textSecondary
                                        : AppColors.textSecondary.withValues(alpha: 0.3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isAvailable)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.textSecondary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Coming Soon',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                        ],
                      ),
                      trailing: isSelected
                          ? Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            )
                          : null,
                      onTap: isAvailable ? () => _changeLanguage(language['name']) : null,
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Language Preview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.visibility,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Language Preview',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Preview Content
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentPreviewText['welcome']!,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _currentPreviewText['subtitle']!,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _currentPreviewText['description']!,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Additional Information
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.info,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Language Support',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.info,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Changing the language will update the app interface. Some features may take a moment to update.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.info.withValues(alpha: 0.8),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Language settings saved!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Save Changes',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentLanguageFlag() {
    final language = _languages.firstWhere((lang) => lang['name'] == _selectedLanguage);
    return language['flag'];
  }

  String _getCurrentLanguageNativeName() {
    final language = _languages.firstWhere((lang) => lang['name'] == _selectedLanguage);
    return language['nativeName'];
  }
}
