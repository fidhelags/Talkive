package com.example.counsellingapp.controller;

import com.example.counsellingapp.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/midtrans")
public class MidtransWebhookController {

    @Autowired
    private BookingService bookingService;

    @PostMapping("/notification")
    public String handleMidtransNotification(@RequestBody Map<String, Object> payload) {

        String orderId = (String) payload.get("order_id");
        String transactionStatus = (String) payload.get("transaction_status");
        
        String finalStatus = "PENDING"; 

        if (transactionStatus.equals("settlement") || transactionStatus.equals("capture")) {
            finalStatus = "PAID";
        } else if (transactionStatus.equals("pending")) {
            finalStatus = "PENDING";
        } else if (transactionStatus.equals("deny") || transactionStatus.equals("cancel") || transactionStatus.equals("expire")) {
            finalStatus = "FAILED";
        } else {
            System.out.println("Status Midtrans tidak terduga: " + transactionStatus + " untuk Order ID: " + orderId);
            return "OK"; 
        }

        bookingService.updateBookingStatus(orderId, finalStatus);
        
        System.out.println("Status Booking ID " + orderId + " berhasil diubah menjadi: " + finalStatus);

        return "OK"; 
    }
}