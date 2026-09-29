package com.bookflow.transaction.controller;

import java.util.List;

import com.bookflow.transaction.dto.OrderRequest;
import com.bookflow.transaction.entity.Order;
import com.bookflow.transaction.service.OrderService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/orders")
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Order borrowBook(@Valid @RequestBody OrderRequest request) {
        return orderService.borrowBook(request);
    }

    // Extra endpoint: list all orders (handy for screenshots)
    @GetMapping
    public List<Order> getAllOrders() {
        return orderService.getAllOrders();
    }
}
