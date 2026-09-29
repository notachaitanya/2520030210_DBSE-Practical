package com.bookflow.transaction.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public class InventoryRequest {

    @NotNull(message = "bookId is required")
    private Long bookId;

    @NotNull(message = "totalStock is required")
    @Min(value = 0, message = "Total stock cannot be negative")
    private Integer totalStock;

    @NotNull(message = "availableStock is required")
    @Min(value = 0, message = "Available stock cannot be negative")
    private Integer availableStock;

    public Long getBookId() { return bookId; }
    public void setBookId(Long bookId) { this.bookId = bookId; }

    public Integer getTotalStock() { return totalStock; }
    public void setTotalStock(Integer totalStock) { this.totalStock = totalStock; }

    public Integer getAvailableStock() { return availableStock; }
    public void setAvailableStock(Integer availableStock) { this.availableStock = availableStock; }
}
