from fastapi import FastAPI, HTTPException, UploadFile, File, Form
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from typing import List, Dict, Any, Optional
import uvicorn
import logging

# Import our Haystack components
from haystack_config import haystack_config
from document_processor import document_processor

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="EduChat AI Tutor API",
    description="AI-powered tutoring system using Haystack",
    version="1.0.0"
)

# Add CORS middleware for Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, restrict this to your Flutter app domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
async def startup_event():
    """Initialize Haystack and load sample content on startup"""
    try:
        # Load sample educational content
        sample_docs = document_processor.create_sample_educational_content()
        haystack_config.add_documents(sample_docs)
        logger.info("AI Tutor system initialized with sample content")
    except Exception as e:
        logger.error(f"Error during startup: {e}")

@app.get("/")
def read_root():
    return {"message": "EduChat AI Tutor API is running with Haystack!"}

@app.get("/health")
def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "service": "AI Tutor API"}

@app.post("/chat")
async def chat_with_tutor(
    question: str = Form(...),
    subject: Optional[str] = Form(None),
    tutor_id: Optional[str] = Form(None)
):
    """
    Chat with an AI tutor using Haystack
    """
    try:
        if not question.strip():
            raise HTTPException(status_code=400, detail="Question cannot be empty")
        
        # Get response from Haystack
        response = haystack_config.query(question)
        
        if "error" in response:
            raise HTTPException(status_code=500, detail=response["error"])
        
        return {
            "success": True,
            "question": question,
            "answer": response.get("answer", []),
            "documents": response.get("documents", []),
            "subject": subject,
            "tutor_id": tutor_id
        }
        
    except Exception as e:
        logger.error(f"Error in chat endpoint: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/upload-document")
async def upload_document(
    file: UploadFile = File(...),
    subject: str = Form(...),
    topic: Optional[str] = Form(None)
):
    """
    Upload and process educational documents
    """
    try:
        # Save uploaded file temporarily
        file_path = f"temp_{file.filename}"
        with open(file_path, "wb") as buffer:
            content = await file.read()
            buffer.write(content)
        
        # Process the document
        documents = document_processor.process_file(file_path, subject)
        
        if not documents:
            raise HTTPException(status_code=400, detail="Failed to process document")
        
        # Add to Haystack document store
        haystack_config.add_documents(documents)
        
        # Clean up temporary file
        import os
        os.remove(file_path)
        
        return {
            "success": True,
            "message": f"Document processed and added successfully",
            "document_count": len(documents),
            "subject": subject,
            "topic": topic
        }
        
    except Exception as e:
        logger.error(f"Error uploading document: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/subjects")
def get_available_subjects():
    """Get list of available subjects with expertise levels"""
    try:
        subjects = [
            {"name": "Mathematics", "expertise": "High", "topics": ["Algebra", "Calculus", "Geometry", "Statistics"]},
            {"name": "Physics", "expertise": "High", "topics": ["Mechanics", "Thermodynamics", "Quantum Physics", "Electromagnetism"]},
            {"name": "Chemistry", "expertise": "High", "topics": ["Organic Chemistry", "Inorganic Chemistry", "Biochemistry", "Analytical Chemistry"]},
            {"name": "Biology", "expertise": "Medium", "topics": ["Cell Biology", "Genetics", "Evolutionary Biology", "Ecology"]},
            {"name": "English Literature", "expertise": "Medium", "topics": ["Literature Analysis", "Essay Writing", "Grammar", "Creative Writing"]},
            {"name": "History", "expertise": "Medium", "topics": ["World History", "Political Science", "Cultural Studies", "Geography"]}
        ]
        
        return {"subjects": subjects}
        
    except Exception as e:
        logger.error(f"Error getting subjects: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/tutor/{tutor_id}")
def get_tutor_info(tutor_id: str):
    """Get information about a specific AI tutor"""
    try:
        # This would typically come from a database
        # For now, return mock data
        tutors = {
            "1": {
                "id": "1",
                "name": "MathGPT",
                "specialization": "Mathematics",
                "description": "Expert in algebra, calculus, geometry, and statistics",
                "expertise_level": "High",
                "subjects": ["Algebra", "Calculus", "Geometry", "Statistics"],
                "sample_questions": [
                    "How do I solve quadratic equations?",
                    "What is the derivative of x²?",
                    "Explain the Pythagorean theorem"
                ]
            },
            "2": {
                "id": "2",
                "name": "PhysicsAI",
                "specialization": "Physics",
                "description": "Specialized in mechanics, thermodynamics, and quantum physics",
                "expertise_level": "High",
                "subjects": ["Mechanics", "Thermodynamics", "Quantum Physics", "Electromagnetism"],
                "sample_questions": [
                    "What is Newton's second law?",
                    "How does entropy work?",
                    "Explain quantum superposition"
                ]
            }
        }
        
        if tutor_id not in tutors:
            raise HTTPException(status_code=404, detail="Tutor not found")
        
        return tutors[tutor_id]
        
    except Exception as e:
        logger.error(f"Error getting tutor info: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/practice-quiz")
async def generate_practice_quiz(
    subject: str = Form(...),
    topic: str = Form(...),
    difficulty: str = Form("medium")
):
    """
    Generate a practice quiz using Haystack
    """
    try:
        # This would use Haystack to generate questions based on the subject/topic
        # For now, return sample questions
        sample_questions = {
            "Mathematics": {
                "Algebra": [
                    {
                        "question": "Solve for x: 2x + 5 = 13",
                        "options": ["x = 4", "x = 3", "x = 5", "x = 6"],
                        "correct": 0,
                        "explanation": "Subtract 5 from both sides: 2x = 8, then divide by 2: x = 4"
                    }
                ],
                "Calculus": [
                    {
                        "question": "What is the derivative of f(x) = x³?",
                        "options": ["3x²", "x²", "3x", "x³"],
                        "correct": 0,
                        "explanation": "Using the power rule: d/dx(x^n) = nx^(n-1), so d/dx(x³) = 3x²"
                    }
                ]
            }
        }
        
        questions = sample_questions.get(subject, {}).get(topic, [])
        
        return {
            "success": True,
            "subject": subject,
            "topic": topic,
            "difficulty": difficulty,
            "questions": questions
        }
        
    except Exception as e:
        logger.error(f"Error generating quiz: {e}")
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
