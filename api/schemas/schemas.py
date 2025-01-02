from pydantic import BaseModel, Field
from typing import Optional
from uuid import UUID, uuid4


class University(BaseModel):
    id: int
    name: str
    code: str
    description: str


class Department(BaseModel):
    id: int
    name: str
    description: str


class Module(BaseModel):
    id: int
    code: str
    name: str

class Course(BaseModel):
    id: int
    code: str
    name: str


class Option(BaseModel):
    """option model"""
    id: str
    label: str
    content: str


class Question(BaseModel):
    """
    Question model
    """
    uid: UUID = Field(default=uuid4())
    qid: int
    module: str

    question: str
    options: list
    answer: str


class User(BaseModel):
    id: int
    username: str
    email: str
    password: str
    first_name: str
    last_name: str
    age: int
    department: str
    university: University


class LoggedUser(BaseModel):
    id: int
    username: str
    email: str
    password: str
    user: User 

