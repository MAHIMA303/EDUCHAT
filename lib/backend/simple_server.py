from fastapi import FastAPI, HTTPException, Form
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import uvicorn
import logging
import json

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="EduChat AI Tutor API",
    description="Simple AI-powered tutoring system",
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

# Simple educational responses
EDUCATIONAL_RESPONSES = {
    "math": [
        "Mathematics is the language of the universe. Let me help you understand this concept step by step.",
        "Great question! Let's break this down into smaller, manageable parts.",
        "Remember, practice makes perfect in mathematics. Let's work through this together."
    ],
    "science": [
        "Science is all about asking questions and finding evidence. Let's explore this topic!",
        "This is a fascinating concept! Let me explain the underlying principles.",
        "In science, we always start with observations. What have you noticed about this?"
    ],
    "english": [
        "Language is a powerful tool for communication. Let's enhance your understanding.",
        "Great question about English! Let me help you master this concept.",
        "Remember, reading and writing go hand in hand. Let's practice together."
    ],
    "default": [
        "I'm here to help you learn! What specific question do you have?",
        "That's an interesting topic! Let me break it down for you.",
        "Learning is a journey, and I'm here to guide you through it."
    ]
}

@app.get("/")
def read_root():
    return {"message": "EduChat AI Tutor API is running!"}

@app.get("/health")
def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "service": "AI Tutor API"}

@app.post("/chat")
async def chat_with_tutor(
    question: str = Form(...),
    subject: str = Form(None),
    tutor_id: str = Form(None)
):
    """
    Simple chat with an AI tutor
    """
    try:
        if not question.strip():
            raise HTTPException(status_code=400, detail="Question cannot be empty")
        
        # Simple response generation based on subject
        subject = subject.lower() if subject else "default"
        responses = EDUCATIONAL_RESPONSES.get(subject, EDUCATIONAL_RESPONSES["default"])
        
        # Generate a simple response
        import random
        base_response = random.choice(responses)
        
        # Add some context to the response
        response = f"{base_response}\n\nYour question: '{question}'\n\nI understand you're asking about this topic. Let me provide you with a comprehensive explanation that will help you grasp the concept better."
        
        return {
            "success": True,
            "question": question,
            "answer": response,
            "subject": subject,
            "tutor_id": tutor_id
        }
        
    except Exception as e:
        logger.error(f"Error in chat endpoint: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/chat-json")
async def chat_with_tutor_json(
    data: dict
):
    """
    Chat endpoint that accepts JSON data
    """
    try:
        question = data.get("user_message", "").lower()
        messages = data.get("messages", [])
        
        if not question.strip():
            raise HTTPException(status_code=400, detail="Question cannot be empty")
        
        # Generate educational responses based on the question content
        response = generate_educational_response(question)
        
        return {
            "success": True,
            "response": response,
            "question": question
        }
        
    except Exception as e:
        logger.error(f"Error in chat-json endpoint: {e}")
        raise HTTPException(status_code=500, detail=str(e))

def generate_educational_response(question: str) -> str:
    """
    Generate educational responses based on question content
    """
    question = question.lower()
    
    # Physics responses
    if "newton" in question and "first law" in question:
        return """Newton's First Law of Motion, also known as the Law of Inertia, states that:

**"An object at rest stays at rest and an object in motion stays in motion with the same speed and in the same direction unless acted upon by an unbalanced force."**

**Key Points:**
• **Inertia**: The tendency of objects to resist changes in their motion
• **At Rest**: Objects naturally stay still unless pushed/pulled
• **In Motion**: Objects keep moving in straight lines unless forces act on them

**Real Examples:**
• A book stays on a table until you push it
• A car continues rolling on ice (low friction) until friction stops it
• Your body keeps moving forward when a car suddenly stops

**Why It Matters:**
This law explains why seatbelts are important - your body wants to keep moving forward even when the car stops!"""
    
    elif "newton" in question and "second law" in question:
        return """Newton's Second Law of Motion states that:

**"The acceleration of an object is directly proportional to the net force acting on it and inversely proportional to its mass."**

**Formula: F = ma**
• F = Force (in Newtons)
• m = Mass (in kilograms)  
• a = Acceleration (in m/s²)

**Key Concepts:**
• **More Force = More Acceleration**
• **More Mass = Less Acceleration**
• **Direction Matters**: Force and acceleration are vectors

**Examples:**
• Pushing a shopping cart harder makes it accelerate faster
• A heavy truck needs more force to accelerate than a small car
• Gravity pulls all objects at 9.8 m/s² (on Earth)"""
    
    elif "newton" in question and "third law" in question:
        return """Newton's Third Law of Motion states that:

**"For every action, there is an equal and opposite reaction."**

**Key Points:**
• **Action-Reaction Pairs**: Forces always come in pairs
• **Equal Magnitude**: Both forces have the same strength
• **Opposite Direction**: Forces act in opposite directions
• **Different Objects**: Each force acts on a different object

**Real Examples:**
• **Rocket Propulsion**: Rocket pushes gas backward, gas pushes rocket forward
• **Walking**: Your foot pushes the ground backward, ground pushes you forward
• **Swimming**: You push water backward, water pushes you forward
• **Balloon**: Air escapes backward, balloon moves forward

**Why It's Important:**
This law explains how rockets work in space (no air to push against!) and why you can walk on Earth."""
    
    # Math responses
    elif "algebra" in question or "equation" in question:
        return """Algebra is a branch of mathematics that uses symbols and letters to represent numbers and quantities.

**Key Concepts:**
• **Variables**: Letters like x, y, z that represent unknown values
• **Equations**: Mathematical statements with equals signs
• **Solving**: Finding the value of variables that make equations true

**Basic Example:**
If x + 5 = 12, then x = 7

**Why Learn Algebra:**
• **Problem Solving**: Break complex problems into simpler parts
• **Real World**: Used in science, engineering, finance
• **Logical Thinking**: Develops critical reasoning skills

**Common Topics:**
• Linear equations
• Quadratic equations  
• Systems of equations
• Inequalities"""
    
    elif "calculus" in question or "derivative" in question or "integral" in question:
        return """Calculus is a branch of mathematics that deals with continuous change and motion.

**Key Concepts:**
• **Derivatives**: Rate of change (how fast something is changing)
• **Integrals**: Accumulation of change (total area under a curve)
• **Limits**: What happens as we get closer and closer to a value

**Real Examples:**
• **Speed**: Derivative of position (how fast you're moving)
• **Acceleration**: Derivative of speed (how fast speed is changing)
• **Distance**: Integral of speed (total distance traveled)

**Why Important:**
Calculus is used in physics, engineering, economics, and many other fields!"""
    
    elif "geometry" in question or "triangle" in question or "circle" in question:
        return """Geometry is the study of shapes, sizes, and spatial relationships.

**Key Concepts:**
• **Points, Lines, Planes**: Basic building blocks
• **Angles**: Measure of rotation between lines
• **Polygons**: Closed shapes with straight sides
• **Circles**: All points equidistant from center

**Common Shapes:**
• **Triangle**: 3 sides, sum of angles = 180°
• **Rectangle**: 4 right angles, opposite sides equal
• **Circle**: All points same distance from center
• **Square**: 4 equal sides, 4 right angles

**Real Applications:**
• Architecture and design
• Navigation and GPS
• Computer graphics and gaming"""
    
    elif "trigonometry" in question or "sine" in question or "cosine" in question:
        return """Trigonometry studies relationships between angles and sides of triangles.

**Key Functions:**
• **Sine (sin)**: Opposite side / Hypotenuse
• **Cosine (cos)**: Adjacent side / Hypotenuse  
• **Tangent (tan)**: Opposite side / Adjacent side

**Unit Circle:**
• Radius = 1 unit
• sin(θ) = y-coordinate
• cos(θ) = x-coordinate
• tan(θ) = sin(θ) / cos(θ)

**Applications:**
• **Physics**: Wave motion, oscillations
• **Engineering**: Building design, bridges
• **Astronomy**: Calculating distances
• **Music**: Sound wave analysis"""
    
    elif "statistics" in question or "mean" in question or "average" in question:
        return """Statistics is the science of collecting, analyzing, and interpreting data.

**Key Concepts:**
• **Mean (Average)**: Sum of values ÷ Number of values
• **Median**: Middle value when data is ordered
• **Mode**: Most frequent value
• **Standard Deviation**: Measure of spread/variability

**Types of Data:**
• **Qualitative**: Categories (colors, names)
• **Quantitative**: Numbers (heights, scores)

**Real Uses:**
• **Business**: Market research, quality control
• **Medicine**: Clinical trials, disease studies
• **Sports**: Player performance analysis
• **Education**: Test score analysis"""
    
    # Chemistry responses
    elif "atom" in question or "molecule" in question:
        return """Atoms and molecules are the building blocks of matter!

**Atoms:**
• **Smallest unit** of an element that retains its properties
• Made of **protons** (positive), **neutrons** (neutral), **electrons** (negative)
• **Nucleus**: Center containing protons and neutrons
• **Electron Cloud**: Outer region where electrons orbit

**Molecules:**
• **Two or more atoms** bonded together
• Can be same element (O₂ = oxygen gas) or different (H₂O = water)
• **Chemical bonds** hold atoms together

**Examples:**
• **H₂O**: 2 hydrogen + 1 oxygen = water
• **CO₂**: 1 carbon + 2 oxygen = carbon dioxide
• **NaCl**: 1 sodium + 1 chlorine = table salt

**Why Important:**
Understanding atoms helps explain how everything around us works!"""
    
    elif "chemical reaction" in question or "bond" in question or "compound" in question:
        return """Chemical reactions are processes where substances change into new substances.

**Key Concepts:**
• **Reactants**: Starting substances
• **Products**: New substances formed
• **Chemical Bonds**: Forces holding atoms together
• **Energy**: Released or absorbed during reactions

**Types of Reactions:**
• **Synthesis**: A + B → AB (combining)
• **Decomposition**: AB → A + B (breaking apart)
• **Single Replacement**: A + BC → AC + B
• **Double Replacement**: AB + CD → AD + CB

**Examples:**
• **Photosynthesis**: CO₂ + H₂O → C₆H₁₂O₆ + O₂
• **Combustion**: CH₄ + 2O₂ → CO₂ + 2H₂O
• **Rusting**: Fe + O₂ → Fe₂O₃

**Real Applications:**
• Cooking and food preparation
• Medicine and drug development
• Environmental processes"""
    
    elif "periodic table" in question or "element" in question:
        return """The Periodic Table organizes all known chemical elements.

**Organization:**
• **Rows (Periods)**: Number of electron shells
• **Columns (Groups)**: Similar chemical properties
• **Atomic Number**: Number of protons (defines element)
• **Atomic Mass**: Average mass of isotopes

**Key Groups:**
• **Alkali Metals** (Group 1): Very reactive (Na, K)
• **Noble Gases** (Group 18): Unreactive (He, Ne, Ar)
• **Halogens** (Group 17): Form salts (F, Cl, Br)
• **Transition Metals**: Middle of table (Fe, Cu, Au)

**Patterns:**
• **Reactivity**: Increases down alkali metals, decreases down noble gases
• **Atomic Size**: Increases down groups, decreases across periods
• **Electronegativity**: Increases across periods, decreases down groups

**Why Important:**
Predicts element properties and chemical behavior!"""
    
    # Biology responses
    elif "cell" in question or "organism" in question or "biology" in question:
        return """Biology is the study of living organisms and life processes.

**Cell Theory:**
• All living things are made of cells
• Cells are the basic unit of life
• New cells come from existing cells

**Cell Types:**
• **Prokaryotic**: Simple, no nucleus (bacteria)
• **Eukaryotic**: Complex, has nucleus (plants, animals)

**Cell Parts:**
• **Nucleus**: Contains DNA (genetic material)
• **Mitochondria**: Produces energy (powerhouse)
• **Cell Membrane**: Controls what enters/exits
• **Cytoplasm**: Jelly-like substance inside cell

**Levels of Organization:**
Cells → Tissues → Organs → Organ Systems → Organisms

**Real Applications:**
• Medicine and healthcare
• Agriculture and food production
• Environmental conservation"""
    
    elif "photosynthesis" in question or "plant" in question:
        return """Photosynthesis is how plants make their own food using sunlight.

**Process:**
• **Inputs**: Carbon dioxide (CO₂) + Water (H₂O) + Sunlight
• **Outputs**: Glucose (sugar) + Oxygen (O₂)
• **Location**: Chloroplasts (green parts of plants)

**Chemical Equation:**
6CO₂ + 6H₂O + Light → C₆H₁₂O₆ + 6O₂

**Why Important:**
• **Food Source**: Plants are the base of food chains
• **Oxygen**: Produces oxygen we breathe
• **Carbon Cycle**: Removes CO₂ from atmosphere
• **Energy**: Converts solar energy to chemical energy

**Real Examples:**
• Trees producing oxygen
• Crops growing for food
• Algae in oceans
• Grass in lawns

**Human Impact:**
Deforestation reduces photosynthesis and oxygen production!"""
    
    # General learning response
    else:
        return f"""Great question! You asked: "{question}"

I'm here to help you learn and understand this topic better. Let me break this down:

**What I Understand:**
You're asking about {question}, which shows you're curious and want to learn more.

**How I Can Help:**
• Explain concepts clearly with examples
• Break down complex topics into simple parts
• Connect ideas to real-world applications
• Answer follow-up questions

**Next Steps:**
Could you be more specific about what aspect of {question} you'd like me to explain? For example:
• The basic definition?
• How it works?
• Real-world examples?
• Related concepts?

This will help me give you the most helpful and accurate answer!"""

@app.get("/subjects")
def get_available_subjects():
    """Get available subjects"""
    return {
        "subjects": [
            {"id": "math", "name": "Mathematics", "description": "Numbers, equations, and problem solving"},
            {"id": "science", "name": "Science", "description": "Physics, chemistry, and biology"},
            {"id": "english", "name": "English", "description": "Language, literature, and writing"},
            {"id": "history", "name": "History", "description": "Past events and their significance"},
            {"id": "geography", "name": "Geography", "description": "Earth, places, and environments"}
        ]
    }

if __name__ == "__main__":
    print("🎓 EduChat Simple AI Tutor Backend")
    print("==================================")
    print("🚀 Starting server...")
    print("📱 Your Flutter app can now connect to: http://localhost:8000")
    
    uvicorn.run(
        "simple_server:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )
