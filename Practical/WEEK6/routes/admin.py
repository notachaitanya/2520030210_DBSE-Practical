from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field
from routes.catalog import books

router = APIRouter()


class Book(BaseModel):
    title: str
    author: str
    price: float = Field(ge=0)
    isbn: str
    status: str


@router.post("/admin/books")
def add_book(book: Book):
    new_id = max([b["id"] for b in books], default=100) + 1
    new_book = {
        "id": new_id,
        **book.model_dump()
    }
    books.append(new_book)
    return {
        "message": "Book added successfully",
        "book": new_book
    }


@router.put("/admin/books/{book_id}")
def update_book(book_id: int, book: Book):
    for index, existing_book in enumerate(books):
        if existing_book["id"] == book_id:
            updated_book = {
                "id": book_id,
                **book.model_dump()
            }
            books[index] = updated_book
            return {
                "message": "Book updated successfully",
                "book": updated_book
            }

    raise HTTPException(status_code=404, detail="Book not found")


@router.delete("/admin/books/{book_id}")
def delete_book(book_id: int):
    for index, book in enumerate(books):
        if book["id"] == book_id:
            deleted_book = books.pop(index)
            return {
                "message": "Book deleted successfully",
                "book": deleted_book
            }

    raise HTTPException(status_code=404, detail="Book not found")
