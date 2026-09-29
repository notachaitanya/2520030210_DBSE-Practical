package com.bookflow.transaction.exception;

public class BookOutOfStockException extends RuntimeException {

    public BookOutOfStockException(String message) {
        super(message);
    }
}
