package com.bookflow.transaction.dto;

import jakarta.validation.constraints.NotNull;

public class OrderRequest {

    @NotNull(message = "userId is required")
    private Long userId;

    @NotNull(message = "bookId is required")
    private Long bookId;

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Long getBookId() { return bookId; }
    public void setBookId(Long bookId) { this.bookId = bookId; }
}
