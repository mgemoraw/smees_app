from fastapi import APIRouter
from uuid import UUID
from schemas.schemas import User


router = APIRouter()



@router.get('/', status_code=200, response_model=User)
async def test():
    return {"data": "Test Success!"}

@router.get('/{qid}', status_code=200, response_model=User)
async def test(qid: UUID):
    return {"data": "Test Success!"}

