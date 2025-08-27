# Personalized Content Recommendations System

## Overview

The Personalized Content Recommendations System is an AI-powered feature that analyzes user behavior, assignments, chat history, and study patterns to provide intelligent, personalized learning recommendations.

## Features

### 🎯 Smart Recommendations
- **Learning Resources**: Suggested study materials, videos, and practice problems
- **Chat Groups**: Recommended study groups based on interests and current subjects
- **Study Topics**: Personalized study topics that build on recent conversations
- **Assignments**: Suggested tasks that complement current workload
- **AI Tutor Sessions**: Recommended AI tutoring for challenging subjects

### 🤖 AI-Powered Analysis
- Uses OpenAI GPT-3.5-turbo for intelligent recommendation generation
- Analyzes user context from multiple data sources
- Provides confidence scores for each recommendation
- Learns from user feedback to improve future suggestions

### 📱 User Experience
- Beautiful, intuitive interface with filterable recommendations
- Priority-based organization (low, medium, high, urgent)
- Interactive cards with metadata and action buttons
- Real-time updates using Firestore streams

## Architecture

### Components

1. **Recommendation Model** (`lib/models/recommendation.dart`)
   - Data structure for recommendations
   - Type-safe enums for recommendation types and priorities
   - Firestore integration with proper serialization

2. **Recommendation Service** (`lib/services/recommendation_service.dart`)
   - Core business logic for recommendation generation
   - OpenAI API integration
   - Firestore CRUD operations
   - Fallback recommendation system

3. **Recommendations Screen** (`lib/screens/recommendations_screen.dart`)
   - Main UI for displaying recommendations
   - Filtering and sorting capabilities
   - Interactive recommendation cards
   - Action handling (accept, reject, mark as read)

### Data Flow

```
User Data → AI Analysis → Recommendation Generation → Firestore Storage → UI Display
    ↓              ↓              ↓                    ↓              ↓
Assignments   Chat History   OpenAI API         Real-time Stream   Interactive Cards
Study Groups  User Profile   Context Building   User Actions      Filter & Sort
```

## Setup & Configuration

### Prerequisites

1. **OpenAI API Key**: Set your OpenAI API key as an environment variable:
   ```bash
   export OPENAI_API_KEY="your-api-key-here"
   ```

2. **Firebase Configuration**: Ensure Firebase is properly configured in your project

3. **Dependencies**: The following packages are required:
   ```yaml
   dependencies:
     cloud_firestore: ^4.15.5
     http: ^1.2.2
     uuid: ^4.4.0
   ```

### Firestore Setup

1. **Create the recommendations collection** with the following security rules:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /recommendations/{recommendationId} {
         allow read, write: if request.auth != null && 
           request.auth.uid == resource.data.userId;
         allow create: if request.auth != null && 
           request.auth.uid == request.resource.data.userId;
       }
     }
   }
   ```

2. **Set up indexes** for optimal performance:
   - `userId` (ascending) + `createdAt` (descending)
   - `userId` (ascending) + `type` (ascending)
   - `userId` (ascending) + `priority` (ascending)

### Integration

1. **Add to Navigation**: The recommendations screen is automatically added to the main navigation
2. **Import Service**: Import `RecommendationService` where needed
3. **User Context**: Pass user data to generate personalized recommendations

## Usage

### Basic Implementation

```dart
import 'package:your_app/services/recommendation_service.dart';

final recommendationService = RecommendationService();

// Generate recommendations for a user
final recommendations = await recommendationService.generateRecommendations(
  userId: 'user123',
  username: 'John Doe',
  assignments: userAssignments,
  groups: userGroups,
  limit: 5,
);

// Get real-time recommendations stream
final recommendationsStream = recommendationService.getUserRecommendations('user123');
```

### Customization

1. **Recommendation Types**: Add new types in the `RecommendationType` enum
2. **Metadata Fields**: Extend the metadata map for additional context
3. **AI Prompts**: Customize the OpenAI prompt in `RecommendationService`
4. **UI Components**: Modify the recommendation cards for your design system

## API Reference

### RecommendationService

#### Methods

- `generateRecommendations()`: Generate AI-based recommendations
- `getUserRecommendations()`: Get real-time recommendations stream
- `markAsRead()`: Mark recommendation as read
- `markAsAccepted()`: Mark recommendation as accepted
- `deleteRecommendation()`: Remove a recommendation

#### Parameters

- `userId`: Unique identifier for the user
- `username`: Display name for the user
- `chatHistory`: Recent chat messages for context
- `assignments`: Current assignments and subjects
- `groups`: Study groups and interests
- `limit`: Maximum number of recommendations to generate

### Recommendation Model

#### Properties

- `id`: Unique identifier
- `title`: Short, descriptive title
- `description`: Detailed explanation
- `type`: Category (learningResource, chatGroup, studyTopic, assignment, aiTutor)
- `priority`: Importance level (low, medium, high, urgent)
- `metadata`: Additional context-specific information
- `confidenceScore`: AI confidence (0.0 to 1.0)

## Best Practices

### Performance

1. **Limit Results**: Use pagination for large recommendation sets
2. **Cache Data**: Implement local caching for frequently accessed recommendations
3. **Batch Operations**: Use Firestore batch writes for multiple recommendations
4. **Real-time Updates**: Leverage Firestore streams for live data

### User Experience

1. **Progressive Disclosure**: Show essential information first, details on demand
2. **Clear Actions**: Provide obvious next steps for each recommendation
3. **Feedback Loops**: Track user interactions to improve future recommendations
4. **Personalization**: Use user preferences and history for better suggestions

### AI Integration

1. **Context Building**: Provide rich context for better AI recommendations
2. **Error Handling**: Implement fallback recommendations when AI fails
3. **Rate Limiting**: Respect API rate limits and implement retry logic
4. **Prompt Engineering**: Continuously improve AI prompts for better results

## Troubleshooting

### Common Issues

1. **OpenAI API Errors**: Check API key and rate limits
2. **Firestore Permission Denied**: Verify security rules and user authentication
3. **Empty Recommendations**: Ensure user data is available for context
4. **Performance Issues**: Check Firestore indexes and query optimization

### Debug Mode

Enable debug logging by setting the log level:
```dart
// In your main.dart or configuration
if (kDebugMode) {
  // Enable detailed logging
}
```

## Future Enhancements

### Planned Features

1. **Machine Learning**: Implement custom ML models for better recommendations
2. **Collaborative Filtering**: Use peer data for group-based suggestions
3. **Content Curation**: Integrate with external educational content providers
4. **Predictive Analytics**: Anticipate user needs before they arise

### Technical Improvements

1. **Offline Support**: Cache recommendations for offline access
2. **Push Notifications**: Alert users to new recommendations
3. **A/B Testing**: Test different recommendation strategies
4. **Analytics Dashboard**: Monitor recommendation performance and user engagement

## Contributing

1. **Code Style**: Follow the existing Flutter/Dart conventions
2. **Testing**: Add unit tests for new functionality
3. **Documentation**: Update this README for any changes
4. **Performance**: Ensure new features don't impact app performance

## Support

For questions or issues with the recommendations system:

1. Check the troubleshooting section above
2. Review the Firestore schema documentation
3. Examine the example implementations
4. Create an issue in the project repository

---

**Note**: This system requires an active OpenAI API key and Firebase configuration to function properly. Ensure all prerequisites are met before implementation.
