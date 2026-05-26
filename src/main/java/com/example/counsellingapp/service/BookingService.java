package com.example.counsellingapp.service;

import java.util.List;
import java.util.Optional;

import com.example.counsellingapp.model.Booking;
import com.example.counsellingapp.model.Slot;
import com.example.counsellingapp.model.User;

public interface BookingService {
    Booking saveBooking(Booking booking);
    Optional<Booking> findById(Long id);
    Optional<Booking> findBySlot(Slot slot);
    Optional<Booking> findByMidtransOrderId(String midtransOrderId);
    List<Booking> findByUser(User user);
    List<Booking> findAll();
    List<Booking> findAllBookings();
    List<Booking> findAllBookingsByUser(User user);

    void updateBookingStatus(String orderId, String newStatusString);
    
    void deleteById(Long id);

    List<Booking> findByTutorId(Long id);
    
    Booking getBookingById(Long id);
}
