package com.bookflow.transaction.service;

import com.bookflow.transaction.dto.InventoryRequest;
import com.bookflow.transaction.entity.Inventory;
import com.bookflow.transaction.exception.BookNotFoundException;
import com.bookflow.transaction.repository.InventoryRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class InventoryService {

    private final InventoryRepository inventoryRepository;

    public InventoryService(InventoryRepository inventoryRepository) {
        this.inventoryRepository = inventoryRepository;
    }

    @Transactional(readOnly = true)
    public Inventory getInventory(Long bookId) {
        return inventoryRepository.findById(bookId)
                .orElseThrow(() -> new BookNotFoundException(
                        "No inventory record for book " + bookId));
    }

    // Adds a new inventory row, or overwrites the row if the book already exists
    @Transactional
    public Inventory saveInventory(InventoryRequest request) {
        if (request.getAvailableStock() > request.getTotalStock()) {
            throw new IllegalArgumentException(
                    "Available stock cannot be greater than total stock");
        }
        Inventory inventory = new Inventory(
                request.getBookId(),
                request.getTotalStock(),
                request.getAvailableStock());
        return inventoryRepository.save(inventory);
    }
}
