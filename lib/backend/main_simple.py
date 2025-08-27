from fastapi import FastAPI, HTTPException, UploadFile, File, Form
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Dict, Any, Optional
import uvicorn
import logging
import json

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="EduChat AI Tutor API (Simple Version)",
    description="AI-powered tutoring system - Simplified for Python 3.13",
    version="1.0.0"
)

# Add CORS middleware for Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Simple in-memory knowledge base
KNOWLEDGE_BASE = {
    "Mathematics": {
        "Algebra": [
            "Algebra is a branch of mathematics that deals with symbols and variables.",
            "Linear equations have the form ax + b = c where a, b, c are constants.",
            "Quadratic equations have the form ax² + bx + c = 0.",
            "To solve quadratic equations, use the quadratic formula: x = (-b ± √(b² - 4ac)) / 2a"
        ],
        "Calculus": [
            "Calculus is the study of continuous change and includes differentiation and integration.",
            "The derivative of x² is 2x.",
            "The derivative of x³ is 3x².",
            "Integration is the reverse process of differentiation."
        ],
        "Geometry": [
            "Geometry studies shapes, sizes, and properties of space.",
            "The area of a circle is πr² where r is the radius.",
            "The Pythagorean theorem states: a² + b² = c² in a right triangle.",
            "The sum of angles in a triangle is 180 degrees."
        ]
    },
    "Physics": {
        "Mechanics": [
            "Mechanics is the study of motion and forces.",
            "Newton's First Law: An object at rest stays at rest unless acted upon by a force.",
            "Newton's Second Law: F = ma (Force equals mass times acceleration).",
            "Newton's Third Law: For every action, there is an equal and opposite reaction."
        ],
        "Thermodynamics": [
            "Thermodynamics studies heat and energy transfer.",
            "The First Law: Energy cannot be created or destroyed, only transformed.",
            "The Second Law: Entropy always increases in isolated systems.",
            "Temperature is a measure of average kinetic energy of particles."
        ]
    },
    "Chemistry": {
        "Organic Chemistry": [
            "Organic chemistry studies carbon-based compounds.",
            "Hydrocarbons contain only carbon and hydrogen atoms.",
            "Alkanes have single bonds, alkenes have double bonds, alkynes have triple bonds.",
            "Functional groups give organic compounds their characteristic properties."
        ],
        "Inorganic Chemistry": [
            "Inorganic chemistry studies non-carbon compounds.",
            "Acids donate protons (H⁺ ions) in solution.",
            "Bases accept protons in solution.",
            "pH measures acidity: pH < 7 is acidic, pH > 7 is basic."
        ]
    }
}

@app.on_event("startup")
async def startup_event():
    """Initialize the simple AI tutor system"""
    logger.info("Simple AI Tutor system initialized with knowledge base")

@app.get("/")
def read_root():
    return {"message": "EduChat AI Tutor API (Simple Version) is running!"}

@app.get("/health")
def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "service": "Simple AI Tutor API"}

@app.post("/chat")
async def chat_with_tutor(
    question: str = Form(...),
    subject: Optional[str] = Form(None),
    tutor_id: Optional[str] = Form(None)
):
    """
    Chat with an AI tutor using simple knowledge base
    """
    try:
        if not question.strip():
            raise HTTPException(status_code=400, detail="Question cannot be empty")
        
        # Simple keyword-based response generation
        response = generate_simple_response(question, subject)
        
        return {
            "success": True,
            "question": question,
            "answer": [response],
            "documents": [f"Knowledge base: {subject or 'General'}"],
            "subject": subject,
            "tutor_id": tutor_id
        }
        
    except Exception as e:
        logger.error(f"Error in chat endpoint: {e}")
        raise HTTPException(status_code=500, detail=str(e))

def generate_simple_response(question: str, subject: str = None) -> str:
    """Generate a simple response based on keywords"""
    question_lower = question.lower()
    
    # Check for subject-specific knowledge
    if subject and subject in KNOWLEDGE_BASE:
        for topic, facts in KNOWLEDGE_BASE[subject].items():
            for fact in facts:
                if any(keyword in question_lower for keyword in topic.lower().split()):
                    return f"Based on {topic}: {fact}"
    
    # General responses based on keywords
    if "algebra" in question_lower or "equation" in question_lower:
        return "In algebra, we work with variables and equations. For example, to solve 2x + 5 = 13, subtract 5 from both sides to get 2x = 8, then divide by 2 to get x = 4."
    
    elif "calculus" in question_lower or "derivative" in question_lower:
        return "Calculus involves studying rates of change. The derivative measures how a function changes as its input changes. For example, the derivative of x² is 2x."
    
    elif "physics" in question_lower or "force" in question_lower:
        return "Physics studies the fundamental laws of nature. Newton's laws describe how forces affect motion. Force equals mass times acceleration (F = ma)."
    
    elif "chemistry" in question_lower or "molecule" in question_lower:
        return "Chemistry studies matter and its transformations. Atoms combine to form molecules, and chemical reactions involve breaking and forming bonds."
    
    elif "help" in question_lower or "explain" in question_lower:
        return "I'm here to help! I can explain concepts in Mathematics, Physics, and Chemistry. Try asking about specific topics like algebra, calculus, mechanics, or organic chemistry."
    
    else:
        return "I'm a simple AI tutor focused on Mathematics, Physics, and Chemistry. I can help explain concepts, solve problems, and provide examples. What specific topic would you like to learn about?"

@app.get("/subjects")
def get_available_subjects():
    """Get list of available subjects"""
    try:
        subjects = [
            {"name": "Mathematics", "expertise": "High", "topics": list(KNOWLEDGE_BASE["Mathematics"].keys())},
            {"name": "Physics", "expertise": "High", "topics": list(KNOWLEDGE_BASE["Physics"].keys())},
            {"name": "Chemistry", "expertise": "High", "topics": list(KNOWLEDGE_BASE["Chemistry"].keys())}
        ]
        
        return {"subjects": subjects}
        
    except Exception as e:
        logger.error(f"Error getting subjects: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/tutor/{tutor_id}")
def get_tutor_info(tutor_id: str):
    """Get information about a specific AI tutor"""
    try:
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
    """Generate a practice quiz using knowledge base"""
    try:
        if subject in KNOWLEDGE_BASE and topic in KNOWLEDGE_BASE[subject]:
            facts = KNOWLEDGE_BASE[subject][topic]
            questions = []
            
            for i, fact in enumerate(facts[:3]):  # Generate up to 3 questions
                questions.append({
                    "question": f"Question {i+1}: What do you know about {topic.lower()}?",
                    "options": [fact, "I don't know", "Need more information", "Ask the tutor"],
                    "correct": 0,
                    "explanation": fact
                })
            
            return {
                "success": True,
                "subject": subject,
                "topic": topic,
                "difficulty": difficulty,
                "questions": questions
            }
        else:
            return {
                "success": True,
                "subject": subject,
                "topic": topic,
                "difficulty": difficulty,
                "questions": []
            }
        
    except Exception as e:
        logger.error(f"Error generating quiz: {e}")
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
