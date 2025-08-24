# EduChatBot - AI-Powered Learning Assistant

A modern, professional Flutter mobile app designed to help students solve academic doubts using AI-powered chatbot technology.

## 🎯 App Concept

EduChatBot is an AI-powered doubt-solving application for students that leverages Natural Language Processing (NLP) to provide instant, intelligent responses to academic questions. The app features a clean, modern interface with smooth animations and a comprehensive learning management system.

## ✨ Features

### 🎨 Design & UI
- **Modern Material Design 3** with custom theming
- **Futuristic educational theme** using shades of blue and purple
- **Smooth animations** and page transitions
- **Dark mode support** with automatic theme switching
- **Responsive design** optimized for mobile devices
- **Custom color scheme** with consistent branding

### 📱 Screens & Navigation
1. **Splash Screen** - Animated logo with gradient background
2. **Onboarding** - 3-slide introduction with smooth page transitions
3. **Authentication** - Login/Signup with guest access option
4. **Home Screen** - Bottom navigation with Chats, Assignments, and Profile tabs
5. **Chat Interface** - WhatsApp-like chat UI with AI responses
6. **Assignments** - Task management with priority levels and due dates
7. **Profile** - User information and statistics
8. **Settings** - App preferences and configuration

### 🚀 Core Functionality
- **AI Chatbot** - Intelligent doubt resolution system
- **Assignment Tracking** - Manage academic tasks and deadlines
- **Progress Monitoring** - Track learning journey and achievements
- **Subject Organization** - Categorized learning by academic subjects
- **Real-time Updates** - Live chat and notification system

### 🎭 Animations & Interactions
- **Page Transitions** - Slide from right with fade effects
- **Loading Animations** - Smooth loading indicators and progress bars
- **Interactive Elements** - Ripple effects and scale animations
- **Floating Action Buttons** - Bounce animations for better UX
- **Lottie Integration** - Rich animated illustrations

## 🛠️ Technical Stack

### Frontend
- **Flutter** - Cross-platform mobile development framework
- **Dart** - Programming language
- **Material Design 3** - UI component library

### State Management
- **Provider** - State management solution
- **GoRouter** - Declarative routing for Flutter

### Animations
- **flutter_animate** - Declarative animations
- **Lottie** - High-quality vector animations

### UI Components
- **Google Fonts** - Typography system
- **Custom Theme** - Consistent design language

## 📁 Project Structure

```
lib/
├── constants/
│   └── app_colors.dart          # Color definitions
├── models/
│   └── chat_message.dart        # Data models
├── screens/
│   ├── splash_screen.dart       # App launch screen
│   ├── onboarding_screen.dart   # User introduction
│   ├── auth_screen.dart         # Authentication
│   ├── home_screen.dart         # Main navigation
│   ├── chat_screen.dart         # AI chat interface
│   ├── assignments_screen.dart  # Task management
│   ├── profile_screen.dart      # User profile
│   └── settings_screen.dart     # App configuration
├── theme/
│   └── app_theme.dart           # Theme configuration
├── widgets/
│   ├── chat_list_item.dart      # Chat list component
│   └── assignment_card.dart     # Assignment display
└── main.dart                    # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.8.1)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or Physical Device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd educhat_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Dependencies

The app uses the following key dependencies:

```yaml
dependencies:
  flutter: sdk: flutter
  go_router: ^13.2.0          # Navigation
  lottie: ^3.1.0              # Animations
  flutter_animate: ^4.5.0     # UI animations
  provider: ^6.1.1            # State management
  google_fonts: ^6.1.0        # Typography
  shared_preferences: ^2.2.2  # Local storage
```

## 🎨 Design System

### Color Palette
- **Primary Blue**: #4A90E2
- **Primary Purple**: #9B59B6
- **Gradient Start**: #667EEA
- **Gradient End**: #764BA2
- **Success**: #27AE60
- **Warning**: #F39C12
- **Error**: #E74C3C

### Typography
- **Headings**: Poppins (Bold, SemiBold)
- **Body Text**: Inter (Regular, Medium)
- **Consistent sizing** and weight hierarchy

### Components
- **Rounded corners** (12-24px radius)
- **Elevated cards** with subtle shadows
- **Gradient backgrounds** for visual appeal
- **Consistent spacing** using 8px grid system

## 🔧 Configuration

### Theme Switching
The app supports automatic theme switching based on system preferences:
- Light theme for daytime use
- Dark theme for low-light environments
- Custom color schemes for both themes

### Localization
- English language support (expandable)
- RTL layout support ready
- Localized date and time formatting

## 📱 Platform Support

- **Android**: API level 21+ (Android 5.0+)
- **iOS**: iOS 11.0+
- **Web**: Modern browsers with Flutter web support
- **Desktop**: Windows, macOS, Linux (Flutter desktop)

## 🚧 Future Enhancements

### Planned Features
- [ ] **Voice Input** - Speech-to-text for questions
- [ ] **Image Recognition** - Photo-based problem solving
- [ ] **Offline Mode** - Cached responses and offline access
- [ ] **Multi-language Support** - Internationalization
- [ ] **Advanced Analytics** - Learning progress insights
- [ ] **Social Features** - Study groups and peer learning

### Technical Improvements
- [ ] **Backend Integration** - Real AI service connection
- [ ] **Push Notifications** - Real-time updates
- [ ] **Data Persistence** - Local database integration
- [ ] **Performance Optimization** - Lazy loading and caching
- [ ] **Testing Suite** - Unit and widget tests

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for design guidelines
- Lottie team for animation support
- Open source community for various packages

## 📞 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

---

**EduChatBot** - Empowering students with AI-driven learning assistance 🚀
