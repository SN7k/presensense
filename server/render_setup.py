#!/usr/bin/env python3
"""
Render Deployment Script
Initializes the database on first deployment
"""
import os
import sys
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

def init_database():
    """Initialize database tables"""
    try:
        logger.info("🚀 Starting database initialization...")
        
        from db import init_db, engine, Base
        from sqlalchemy import inspect
        
        # Check if tables already exist
        inspector = inspect(engine)
        existing_tables = inspector.get_table_names()
        
        if existing_tables:
            logger.info(f"✅ Database tables already exist: {existing_tables}")
        else:
            logger.info("📦 Creating database tables...")
            init_db()
            logger.info("✅ Database tables created successfully!")
        
        return True
    except Exception as e:
        logger.error(f"❌ Database initialization failed: {e}")
        return False

def check_environment():
    """Check required environment variables"""
    logger.info("🔍 Checking environment variables...")
    
    required_vars = ["DATABASE_URL"]
    optional_vars = ["GCP_PROJECT_ID", "GCP_BUCKET_NAME", "MATCH_THRESHOLD"]
    
    missing = []
    for var in required_vars:
        if not os.getenv(var):
            missing.append(var)
        else:
            # Mask sensitive data
            value = os.getenv(var)
            if "postgresql" in value or "sqlite" in value:
                masked = value[:20] + "..." if len(value) > 20 else value
                logger.info(f"  ✅ {var}: {masked}")
            else:
                logger.info(f"  ✅ {var}: {value}")
    
    for var in optional_vars:
        value = os.getenv(var, "Not set")
        logger.info(f"  ℹ️  {var}: {value}")
    
    if missing:
        logger.error(f"❌ Missing required environment variables: {missing}")
        return False
    
    return True

def main():
    """Main setup function"""
    logger.info("=" * 60)
    logger.info("🎯 PresenSense Render Deployment Setup")
    logger.info("=" * 60)
    
    # Check environment
    if not check_environment():
        logger.error("❌ Environment check failed")
        sys.exit(1)
    
    # Initialize database
    if not init_database():
        logger.error("❌ Database initialization failed")
        sys.exit(1)
    
    logger.info("=" * 60)
    logger.info("✅ Setup completed successfully!")
    logger.info("=" * 60)

if __name__ == "__main__":
    main()
