from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# SQLite URL for database
SQLALCHEMY_DATABASE_URL = "sqlite:///./courses.db"

# Create the SQLAlchemy engine
engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})

# Create a configured "SessionLocal" class
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base class that our models will inherit from
Base = declarative_base()

# Dependency that provides a session to the route
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
