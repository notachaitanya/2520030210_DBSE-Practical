package com.bookflow.transaction.service;

import java.util.List;

import com.bookflow.transaction.dto.OrderRequest;
import com.bookflow.transaction.entity.Inventory;
import com.bookflow.transaction.entity.Order;
import com.bookflow.transaction.exception.BookNotFoundException;
import com.bookflow.transaction.exception.BookOutOfStockException;
import com.bookflow.transaction.repository.InventoryRepository;
import com.bookflow.transaction.repository.OrderRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class OrderService {

    private final InventoryRepository inventoryRepository;
    private final OrderRepository orderRepository;

    public OrderService(InventoryRepository inventoryRepository,
                        OrderRepository orderRepository) {
        this.inventoryRepository = inventoryRepository;
        this.orderRepository = orderRepository;
    }

    // One database transaction: either BOTH the stock decrease and the new
    // order are saved, or NEITHER is (if anything throws, everything rolls back).
    @Transactional
    public Order borrowBook(OrderRequest request) {

        Inventory inventory = inventoryRepository.findById(request.getBookId())
                .orElseThrow(() -> new BookNotFoundException(
                        "No inventory record for book " + request.getBookId()));

        if (inventory.getAvailableStock() <= 0) {
            throw new BookOutOfStockException(
                    "Book " + request.getBookId() + " is out of stock");
        }

        inventory.setAvailableStock(inventory.getAvailableStock() - 1);
        inventoryRepository.save(inventory);

        Order order = new Order(
                request.getUserId(),
                request.getBookId(),
                "BORROWED");

        return orderRepository.save(order);
    }

    @Transactional(readOnly = true)
    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }
}
