# 🎓 Haystack Integration for EduChat AI Tutor

This guide explains how to implement and use Haystack in your EduChat AI Tutor system.

## 🚀 What is Haystack?

**Haystack** is an open-source framework by deepset for building production-ready applications with Large Language Models (LLMs). It's perfect for:

- **Retrieval-Augmented Generation (RAG)**: Combine your documents with AI responses
- **Question Answering**: Build AI systems that answer based on specific knowledge
- **Document Processing**: Handle PDFs, Word docs, PowerPoint, and more
- **Vector Search**: Find relevant information quickly

## 📋 Prerequisites

- Python 3.8+ (you have 3.13.3 ✅)
- Flutter SDK
- Basic understanding of Python and Flutter

## 🛠️ Installation & Setup

### Step 1: Install Python Dependencies

Navigate to the backend directory and install requirements:

```bash
cd lib/backend
python -m pip install -r requirements.txt
```

### Step 2: Download spaCy Model

```bash
python -m spacy download en_core_web_sm
```

### Step 3: Start the Backend Server

**Option A: Use the startup script (Recommended)**
```bash
python start_server.py
```

**Option B: Manual start**
```bash
python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

### Step 4: Test the Backend

Open your browser and go to: `http://localhost:8000`

You should see: `{"message": "EduChat AI Tutor API is running with Haystack!"}`

## 🏗️ Architecture Overview

```
Flutter App (Frontend)
       ↓
   AIService (HTTP Client)
       ↓
   FastAPI Backend
       ↓
   Haystack Pipeline
       ↓
   Document Store + AI Models
```

## 📚 How It Works

### 1. Document Processing
- Upload educational documents (PDF, Word, PowerPoint, Text)
- Haystack processes and chunks them into searchable pieces
- Documents are stored in a vector database

### 2. AI Tutoring
- Student asks a question
- Haystack finds relevant document chunks
- AI generates contextual answers using the retrieved information
- Responses include source references

### 3. Subject Specialization
- Each AI tutor specializes in specific subjects
- Documents are tagged by subject and topic
- Responses are tailored to the tutor's expertise

## 🔧 Configuration

### Backend Configuration (`haystack_config.py`)

```python
# Document Store
document_store = ChromaDocumentStore(
    embedding_dim=768,
    embedding_function="sentence-transformers/all-MiniLM-L6-v2"
)

# Retriever
retriever = EmbeddingRetriever(
    document_store=document_store,
    embedding_model="sentence-transformers/all-MiniLM-L6-v2",
    top_k=5
)
```

### Flutter Configuration (`ai_service.dart`)

```dart
static const String baseUrl = 'http://localhost:8000';
// Change this to your backend URL in production
```

## 📱 Using the AI Tutor

### 1. Start a Chat Session
- Navigate to AI Tutor screen
- Select a tutor (MathGPT, PhysicsAI, etc.)
- Click "Start Chat"

### 2. Ask Questions
- Type your question in the chat
- AI tutor responds using Haystack knowledge
- See related source documents

### 3. Upload Documents
- Add your own educational materials
- AI tutor learns from your content
- Improve response quality over time

## 🎯 API Endpoints

### Chat with Tutor
```
POST /chat
Body: question, subject, tutor_id
```

### Upload Document
```
POST /upload-document
Body: file, subject, topic
```

### Get Subjects
```
GET /subjects
```

### Generate Quiz
```
POST /practice-quiz
Body: subject, topic, difficulty
```

## 🔍 Troubleshooting

### Common Issues

**1. Backend Connection Failed**
- Check if Python server is running
- Verify port 8000 is not blocked
- Check firewall settings

**2. Import Errors**
- Ensure all requirements are installed
- Check Python version compatibility
- Restart the server

**3. Document Processing Fails**
- Verify file format is supported
- Check file permissions
- Ensure sufficient disk space

### Debug Mode

Enable detailed logging in `haystack_config.py`:

```python
logging.basicConfig(level=logging.DEBUG)
```

## 🚀 Advanced Features

### 1. Custom Document Processing
Add new file types in `document_processor.py`:

```python
def process_custom_file(self, file_path: str, subject: str):
    # Your custom processing logic
    pass
```

### 2. Custom AI Models
Modify `haystack_config.py` to use different models:

```python
self.prompt_node = PromptNode(
    model_name_or_path="your-model-name",
    # ... other settings
)
```

### 3. Vector Database Options
Switch from ChromaDB to other databases:

```python
# PostgreSQL
from haystack.document_stores import SQLDocumentStore
document_store = SQLDocumentStore(url="postgresql://...")

# Elasticsearch
from haystack.document_stores import ElasticsearchDocumentStore
document_store = ElasticsearchDocumentStore(host="localhost", port=9200)
```

## 📊 Performance Optimization

### 1. Document Chunking
Adjust chunk size in `document_processor.py`:

```python
self.preprocessor = PreProcessor(
    split_by="word",
    split_length=200,  # Increase for longer chunks
    split_overlap=20   # Adjust overlap
)
```

### 2. Caching
Enable response caching:

```python
from haystack.nodes import CacheablePromptNode
self.prompt_node = CacheablePromptNode(
    model_name_or_path="gpt2",
    cache_dir="./cache"
)
```

### 3. Batch Processing
Process multiple documents at once:

```python
documents = document_processor.process_directory("./documents", "Mathematics")
haystack_config.add_documents(documents)
```

## 🔒 Security Considerations

### 1. API Security
- Restrict CORS origins in production
- Add authentication middleware
- Rate limiting for API endpoints

### 2. Document Security
- Validate file uploads
- Scan for malicious content
- Implement access controls

### 3. Data Privacy
- Encrypt sensitive documents
- Implement data retention policies
- GDPR compliance considerations

## 📈 Monitoring & Analytics

### 1. Logging
Monitor system performance:

```python
import logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
```

### 2. Metrics
Track usage patterns:

```python
# Add to your API endpoints
@app.middleware("http")
async def log_requests(request: Request, call_next):
    start_time = time.time()
    response = await call_next(request)
    process_time = time.time() - start_time
    logger.info(f"Request processed in {process_time:.2f}s")
    return response
```

## 🎓 Educational Use Cases

### 1. Homework Help
- Students upload assignment documents
- AI tutor provides step-by-step solutions
- Include relevant formulas and concepts

### 2. Study Guides
- Create subject-specific knowledge bases
- Generate practice questions
- Track learning progress

### 3. Research Assistance
- Process research papers
- Extract key findings
- Generate summaries

## 🔮 Future Enhancements

### 1. Multi-language Support
- Add language detection
- Support for non-English documents
- Localized AI responses

### 2. Voice Integration
- Speech-to-text for questions
- Text-to-speech for answers
- Voice-based tutoring sessions

### 3. Advanced Analytics
- Learning pattern analysis
- Difficulty assessment
- Personalized recommendations

## 📞 Support

If you encounter issues:

1. Check the logs in your terminal
2. Verify all dependencies are installed
3. Ensure Python version compatibility
4. Check network connectivity

## 🎉 Congratulations!

You've successfully implemented Haystack in your EduChat AI Tutor system! The AI tutors can now:

- ✅ Process educational documents
- ✅ Provide contextual answers
- ✅ Learn from your content
- ✅ Specialize in different subjects
- ✅ Generate practice materials

Your students now have access to intelligent, knowledge-based AI tutoring powered by cutting-edge NLP technology!
