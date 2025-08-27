# Firestore Schema Documentation

## Collections

### 1. recommendations

Stores personalized content recommendations for users.

**Document ID**: Auto-generated UUID

**Fields**:
```typescript
{
  id: string,                    // Unique identifier
  userId: string,               // User ID this recommendation is for
  title: string,                // Short title of the recommendation
  description: string,          // Detailed description
  type: string,                 // Recommendation type (learningResource, chatGroup, studyTopic, assignment, aiTutor)
  priority: string,             // Priority level (low, medium, high, urgent)
  metadata: {                   // Additional context-specific data
    subject?: string,           // Academic subject
    difficulty?: string,        // Difficulty level (beginner, intermediate, advanced)
    estimatedTime?: number,     // Estimated time in minutes
    tags?: string[],           // Array of tags
    groupSize?: string,        // For chat groups
    focus?: string,            // Focus area
    meetingTime?: string,      // Meeting schedule
    // Add more metadata fields as needed
  },
  isRead: boolean,              // Whether user has read the recommendation
  isAccepted: boolean,          // Whether user has accepted the recommendation
  createdAt: timestamp,         // When recommendation was created
  expiresAt?: timestamp,        // When recommendation expires (optional)
  confidenceScore: number       // AI confidence score (0.0 to 1.0)
}
```

**Indexes**:
- `userId` (ascending) + `createdAt` (descending)
- `userId` (ascending) + `type` (ascending)
- `userId` (ascending) + `priority` (ascending)
- `userId` (ascending) + `isRead` (ascending)

**Example Document**:
```json
{
  "id": "rec_123456789",
  "userId": "user_abc123",
  "title": "Mathematics Practice",
  "description": "Based on your recent assignments, practice quadratic equations and calculus concepts.",
  "type": "learningResource",
  "priority": "medium",
  "metadata": {
    "subject": "Mathematics",
    "difficulty": "intermediate",
    "estimatedTime": 45,
    "tags": ["math", "practice", "calculus"]
  },
  "isRead": false,
  "isAccepted": false,
  "createdAt": "2024-01-15T10:30:00Z",
  "expiresAt": "2024-02-15T10:30:00Z",
  "confidenceScore": 0.85
}
```

### 2. users (existing)

**Fields to add for recommendations**:
```typescript
{
  // ... existing fields
  recommendationPreferences: {
    subjects: string[],         // Preferred subjects
    difficultyLevel: string,    // Preferred difficulty
    timeAvailability: number,   // Available time per day in minutes
    learningStyle: string[],    // Preferred learning methods
    notificationSettings: {
      recommendations: boolean, // Whether to receive recommendation notifications
      frequency: string        // How often (daily, weekly, monthly)
    }
  },
  lastRecommendationUpdate: timestamp, // When recommendations were last updated
  recommendationHistory: {
    totalGenerated: number,     // Total recommendations generated
    totalAccepted: number,      // Total recommendations accepted
    totalRejected: number,      // Total recommendations rejected
    averageConfidence: number   // Average confidence score of accepted recommendations
  }
}
```

### 3. assignments (existing)

**Fields to add for recommendations**:
```typescript
{
  // ... existing fields
  recommendationTags: string[], // Tags for recommendation matching
  difficulty: string,           // Difficulty level
  estimatedTime: number,        // Estimated completion time
  prerequisites: string[],      // Required knowledge/skills
  relatedTopics: string[]       // Related study topics
}
```

### 4. chat_messages (existing)

**Fields to add for recommendations**:
```typescript
{
  // ... existing fields
  topic: string,                // Main topic of the message
  subject: string,              // Academic subject
  difficulty: string,           // Difficulty level
  tags: string[]                // Topic tags
}
```

### 5. groups (existing)

**Fields to add for recommendations**:
```typescript
{
  // ... existing fields
  studyFocus: string[],         // Main study topics
  difficultyLevel: string,      // Group difficulty level
  meetingSchedule: string,      // Meeting frequency
  maxMembers: number,           // Maximum group size
  currentMembers: number,       // Current member count
  activityLevel: string         // How active the group is
}
```

## Security Rules

### recommendations collection
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /recommendations/{recommendationId} {
      // Users can only read/write their own recommendations
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
      
      // Users can only create recommendations for themselves
      allow create: if request.auth != null && 
        request.auth.uid == request.resource.data.userId;
    }
  }
}
```

## Data Flow

1. **Recommendation Generation**:
   - AI service analyzes user data (assignments, chat history, groups)
   - Generates personalized recommendations using OpenAI API
   - Stores recommendations in Firestore

2. **Recommendation Retrieval**:
   - App fetches recommendations for current user
   - Filters by type, priority, and other criteria
   - Displays in recommendations screen

3. **User Interaction**:
   - Users can mark recommendations as read
   - Users can accept/reject recommendations
   - Actions are tracked for future recommendation improvements

4. **Analytics**:
   - Track recommendation performance
   - Improve AI model based on user feedback
   - Personalize future recommendations

## Performance Considerations

1. **Indexing**: Create composite indexes for common query patterns
2. **Pagination**: Limit results and implement pagination for large datasets
3. **Caching**: Cache frequently accessed recommendations
4. **Batch Operations**: Use batch writes for multiple recommendations
5. **Real-time Updates**: Use Firestore streams for live updates

## Migration Guide

1. **Add new fields to existing collections**:
   - Use optional fields to avoid breaking existing data
   - Gradually populate new fields
   - Update security rules accordingly

2. **Create new collections**:
   - Set up proper indexes
   - Configure security rules
   - Test with sample data

3. **Update existing queries**:
   - Modify queries to include new fields
   - Handle cases where new fields might be null
   - Update UI to display new information
