from pydantic import BaseModel

# Pydantic schema for creating a course
class CourseCreate(BaseModel):
    title: str
    description: str

# Pydantic schema for reading a course
class Course(BaseModel):
    id: int
    title: str
    description: str

    class Config:
        orm_mode = True
