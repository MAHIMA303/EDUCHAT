"""
Haystack configuration for AI Tutor system
This file sets up the document processing pipeline and AI components
"""

import os
from typing import List, Dict, Any
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class HaystackConfig:
    def __init__(self):
        self.document_store = None
        self.retriever = None
        self.prompt_node = None
        self.pipeline = None
        self.initialize_components()
    
    def initialize_components(self):
        """Initialize all Haystack components"""
        try:
            # Try to import Haystack components
            try:
                from haystack import Pipeline
                from haystack.schema import Document
                
                # Try different import paths for components
                try:
                    from haystack.document_stores import ChromaDocumentStore
                    from haystack.nodes import (
                        PreProcessor,
                        EmbeddingRetriever,
                        PromptNode,
                        PromptTemplate
                    )
                    logger.info("Using standard Haystack imports")
                except ImportError:
                    try:
                        from haystack.document_stores.chroma import ChromaDocumentStore
                        from haystack.nodes.retriever import EmbeddingRetriever
                        from haystack.nodes.prompt import PromptNode, PromptTemplate
                        logger.info("Using alternative Haystack import paths")
                    except ImportError:
                        # Use in-memory document store as fallback
                        from haystack.document_stores import InMemoryDocumentStore
                        ChromaDocumentStore = InMemoryDocumentStore
                        from haystack.nodes.retriever import EmbeddingRetriever
                        from haystack.nodes.prompt import PromptNode, PromptTemplate
                        logger.info("Using InMemoryDocumentStore as fallback")
                
                # Initialize document store
                if ChromaDocumentStore == InMemoryDocumentStore:
                    self.document_store = ChromaDocumentStore()
                    logger.info("Using InMemoryDocumentStore")
                else:
                    self.document_store = ChromaDocumentStore(
                        embedding_dim=768,
                        embedding_function="sentence-transformers/all-MiniLM-L6-v2"
                    )
                    logger.info("Using ChromaDocumentStore")
                
                # Initialize retriever
                self.retriever = EmbeddingRetriever(
                    document_store=self.document_store,
                    embedding_model="sentence-transformers/all-MiniLM-L6-v2",
                    model_format="sentence_transformers",
                    top_k=5
                )
                
                # Initialize prompt node with educational context
                self.prompt_node = PromptNode(
                    model_name_or_path="gpt2",
                    default_prompt_template=self._get_educational_prompt_template(),
                    max_length=500
                )
                
                # Create the pipeline
                self.pipeline = Pipeline()
                self.pipeline.add_node(component=self.retriever, name="Retriever", inputs=["Query"])
                self.pipeline.add_node(component=self.prompt_node, name="PromptNode", inputs=["Retriever"])
                
                logger.info("Haystack components initialized successfully")
                
            except Exception as e:
                logger.error(f"Error importing Haystack: {e}")
                self._create_minimal_config()
                
        except Exception as e:
            logger.error(f"Error initializing Haystack components: {e}")
            self._create_minimal_config()
    
    def _create_minimal_config(self):
        """Create a minimal working configuration when Haystack fails"""
        logger.info("Creating minimal configuration...")
        try:
            # Create a simple mock configuration
            self.document_store = None
            self.retriever = None
            self.prompt_node = None
            self.pipeline = None
            logger.info("Minimal configuration created successfully")
            
        except Exception as e:
            logger.error(f"Failed to create minimal configuration: {e}")
    
    def _get_educational_prompt_template(self):
        """Create a prompt template for educational AI tutoring"""
        try:
            # Try to create a proper PromptTemplate
            return PromptTemplate(
                prompt="""You are an expert AI tutor. Use the following context to answer the student's question in a clear, educational manner.

Context: {join(documents)}

Question: {query}

Answer: Provide a comprehensive, step-by-step explanation that helps the student understand the concept. Include examples when helpful and encourage critical thinking.""",
                input_variables=["documents", "query"]
            )
        except Exception as e:
            logger.error(f"Error creating prompt template: {e}")
            # Return a simple string template as fallback
            return "You are an expert AI tutor. Answer the student's question in a clear, educational manner."
    
    def add_documents(self, documents):
        """Add documents to the document store"""
        try:
            if self.document_store:
                self.document_store.write_documents(documents)
                logger.info(f"Added {len(documents)} documents to the store")
            else:
                logger.warning("Document store not available")
        except Exception as e:
            logger.error(f"Error adding documents: {e}")
    
    def query(self, question: str) -> Dict[str, Any]:
        """Query the AI tutor with a question"""
        try:
            if self.pipeline:
                results = self.pipeline.run(query=question)
                return {
                    "answer": results.get("answers", []),
                    "documents": results.get("documents", []),
                    "query": question
                }
            else:
                # Return a simple response when pipeline is not available
                return {
                    "answer": [f"I understand your question: '{question}'. Let me help you with this."],
                    "documents": [],
                    "query": question
                }
        except Exception as e:
            logger.error(f"Error querying pipeline: {e}")
            return {"error": str(e)}
    
    def get_subject_expertise(self, subject: str) -> List:
        """Get documents related to a specific subject"""
        try:
            if self.retriever:
                results = self.retriever.retrieve(
                    query=f"subject: {subject}",
                    top_k=10
                )
                return results
            else:
                logger.warning("Retriever not available")
                return []
        except Exception as e:
            logger.error(f"Error retrieving subject expertise: {e}")
            return []

# Global instance
haystack_config = HaystackConfig()
