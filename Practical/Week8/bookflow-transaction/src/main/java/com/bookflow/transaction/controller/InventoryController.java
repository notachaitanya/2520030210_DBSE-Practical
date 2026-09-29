package com.bookflow.transaction.controller;

import com.bookflow.transaction.dto.InventoryRequest;
import com.bookflow.transaction.entity.Inventory;
import com.bookflow.transaction.service.InventoryService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/inventory")
public class InventoryController {

    private final InventoryService inventoryService;

    public InventoryController(InventoryService inventoryService) {
        this.inventoryService = inventoryService;
    }

    @GetMapping("/{bookId}")
    public Inventory getInventory(@PathVariable Long bookId) {
        return inventoryService.getInventory(bookId);
    }

    // Extra endpoint: add stock for a book without using pgAdmin
    @PostMapping
    public Inventory saveInventory(@Valid @RequestBody InventoryRequest request) {
        return inventoryService.saveInventory(request);
    }
}
