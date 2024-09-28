from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from models import Course  # Absolute import
from schemas import CourseCreate, Course as CourseSchema  # Absolute import:
from database import engine, get_db  # Corrected import from your local file

# Create the database tables
Course.metadata.create_all(bind=engine)

app = FastAPI()

# POST API to create a new course
@app.post("/courses/", response_model=CourseSchema)
def create_course(course: CourseCreate, db: Session = Depends(get_db)):
    db_course = Course(title=course.title, description=course.description)
    db.add(db_course)
    db.commit()
    db.refresh(db_course)
    return db_course

# GET API to fetch all courses
@app.get("/courses/", response_model=list[CourseSchema])
def get_courses(db: Session = Depends(get_db)):
    courses = db.query(Course).all()
    return courses
