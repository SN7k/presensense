"""
Initialize PostgreSQL Database Tables
This script creates all necessary tables in your Alwaysdata PostgreSQL database
"""
import sys
from urllib.parse import quote_plus

print("=" * 60)
print("PostgreSQL Database Table Initialization")
print("=" * 60)
print()

# Get password
password = input("Enter your Alwaysdata password (572486@Snk): ").strip()
if not password:
    print("❌ Password cannot be empty!")
    sys.exit(1)

# URL encode password
encoded_password = quote_plus(password)

# Build connection string
DATABASE_URL = f"postgresql://snk007:{encoded_password}@postgresql-snk007.alwaysdata.net:5432/snk007_ai"

print()
print("Connecting to database...")
print()

try:
    from sqlalchemy import create_engine, inspect
    from db import Base, User, Attendance, EmotionSession, EmotionRecord
    
    # Create engine
    engine = create_engine(DATABASE_URL)
    
    # Check existing tables
    inspector = inspect(engine)
    existing_tables = inspector.get_table_names()
    
    print("📊 Existing tables in database:")
    if existing_tables:
        for table in existing_tables:
            print(f"  - {table}")
    else:
        print("  (No tables found)")
    
    print()
    print("🔨 Creating tables...")
    
    # Create all tables
    Base.metadata.create_all(bind=engine)
    
    print("✅ Tables created successfully!")
    print()
    
    # Check tables again
    inspector = inspect(engine)
    new_tables = inspector.get_table_names()
    
    print("📊 Tables now in database:")
    for table in new_tables:
        print(f"  ✅ {table}")
    
    print()
    print("=" * 60)
    print("✅ DATABASE INITIALIZATION COMPLETE!")
    print("=" * 60)
    print()
    print("Your database is now ready to use!")
    print()
    
    # Show table details
    print("📋 Table Details:")
    print()
    
    for table_name in new_tables:
        columns = inspector.get_columns(table_name)
        print(f"Table: {table_name}")
        for col in columns:
            print(f"  - {col['name']}: {col['type']}")
        print()
    
except ImportError as e:
    print(f"❌ Missing required package: {e}")
    print()
    print("Please install required packages:")
    print("  pip install sqlalchemy psycopg2-binary")
    sys.exit(1)
    
except Exception as e:
    print(f"❌ Error: {e}")
    print()
    import traceback
    traceback.print_exc()
    sys.exit(1)
