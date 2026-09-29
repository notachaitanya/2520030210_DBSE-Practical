package com.bookflow.transaction.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

// "order" is a reserved word in SQL, so the table is named "orders"
@Entity
@Table(name = "orders")
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;      // comes from the Node.js user service

    @Column(name = "book_id", nullable = false)
    private Long bookId;      // comes from the FastAPI book service

    @Column(nullable = false, length = 20)
    private String status;    // BORROWED or RETURNED

    public Order() {
    }

    public Order(Long userId, Long bookId, String status) {
        this.userId = userId;
        this.bookId = bookId;
        this.status = status;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Long getBookId() { return bookId; }
    public void setBookId(Long bookId) { this.bookId = bookId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
