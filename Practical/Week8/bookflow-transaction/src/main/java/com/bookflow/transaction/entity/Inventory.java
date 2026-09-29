package com.bookflow.transaction.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

@Entity
@Table(name = "inventory")
public class Inventory {

    // bookId comes from the FastAPI book service, so it is NOT auto-generated
    @Id
    @Column(name = "book_id")
    private Long bookId;

    @NotNull
    @Min(value = 0, message = "Total stock cannot be negative")
    @Column(name = "total_stock", nullable = false)
    private Integer totalStock;

    @NotNull
    @Min(value = 0, message = "Available stock cannot be negative")
    @Column(name = "available_stock", nullable = false)
    private Integer availableStock;

    public Inventory() {
    }

    public Inventory(Long bookId, Integer totalStock, Integer availableStock) {
        this.bookId = bookId;
        this.totalStock = totalStock;
        this.availableStock = availableStock;
    }

    public Long getBookId() { return bookId; }
    public void setBookId(Long bookId) { this.bookId = bookId; }

    public Integer getTotalStock() { return totalStock; }
    public void setTotalStock(Integer totalStock) { this.totalStock = totalStock; }

    public Integer getAvailableStock() { return availableStock; }
    public void setAvailableStock(Integer availableStock) { this.availableStock = availableStock; }
}
