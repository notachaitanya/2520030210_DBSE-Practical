from fastapi import APIRouter, HTTPException

router = APIRouter()

# In-memory book storage
books = [
    {
        "id": 101,
        "title": "Python Programming",
        "author": "John Smith",
        "price": 450,
        "isbn": "9781234567890",
        "status": "Available"
    },
    {
        "id": 102,
        "title": "Database Management",
        "author": "Robert Brown",
        "price": 550,
        "isbn": "9789876543210",
        "status": "Available"
    }
]


@router.get("/books")
def get_books():
    return books


@router.get("/books/{book_id}")
def get_book(book_id: int):
    for book in books:
        if book["id"] == book_id:
            return book

    raise HTTPException(
        status_code=404,
        detail="Book not found"
    )
