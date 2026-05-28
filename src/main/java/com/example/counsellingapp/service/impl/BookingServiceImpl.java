package com.example.counsellingapp.service.impl;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.counsellingapp.model.Booking;
import com.example.counsellingapp.model.Booking.PaymentStatus;
import com.example.counsellingapp.model.Slot;
import com.example.counsellingapp.model.User;
import com.example.counsellingapp.repository.BookingRepository;
import com.example.counsellingapp.service.BookingService;
import com.example.counsellingapp.service.SlotService; 
import com.example.counsellingapp.service.FCMService;


@Service
public class BookingServiceImpl implements BookingService {

    private final BookingRepository bookingRepository;
    private final SlotService slotService; 
    private final FCMService fcmService; 

    @Autowired
    public BookingServiceImpl(BookingRepository bookingRepository, SlotService slotService, FCMService fcmService) {
        this.bookingRepository = bookingRepository;
        this.slotService = slotService;
        this.fcmService = fcmService;
    }

    @Override
    public Booking saveBooking(Booking booking) {
        return bookingRepository.save(booking);
    }

    @Override
    public Optional<Booking> findById(Long id) {
        return bookingRepository.findById(id);
    }

    @Override
    public Optional<Booking> findBySlot(Slot slot) {
        return bookingRepository.findBySlot(slot);
    }

    @Override
    public Optional<Booking> findByMidtransOrderId(String midtransOrderId) {
        return bookingRepository.findByMidtransOrderId(midtransOrderId);
    }

    @Override
    public List<Booking> findByUser(User user) {
        return bookingRepository.findByUser(user);
    }

    @Override
    public List<Booking> findAll() {
        return bookingRepository.findAll();
    }

    @Override
    public List<Booking> findAllBookings() {
        return bookingRepository.findAll();
    }

    @Override
    public void deleteById(Long id) {
        bookingRepository.deleteById(id);
    }

    @Override
    public List<Booking> findAllBookingsByUser(User user) {
        return bookingRepository.findByUser(user);
    }

    @Override
    public List<Booking> findByTutorId(Long id) {
        return bookingRepository.findByTutorId(id);
    }

    @Override
    public Booking getBookingById(Long id) {
        return bookingRepository.findById(id).orElse(null);
    }
    

    @Override
    @Transactional 
    public void updateBookingStatus(String orderId, String newStatusString) {
        
        Optional<Booking> bookingOpt = bookingRepository.findByMidtransOrderId(orderId);
        
        if (bookingOpt.isPresent()) {
            Booking booking = bookingOpt.get();
            
            PaymentStatus newStatus;
            try {
                 newStatus = PaymentStatus.valueOf(newStatusString);
            } catch (IllegalArgumentException e) {
                 System.err.println("Status Midtrans tidak valid: " + newStatusString);
                 return; 
            }
            
            if (booking.getPaymentStatus() != PaymentStatus.PAID) {

                booking.setPaymentStatus(newStatus); 
                bookingRepository.save(booking);

                if (newStatus == PaymentStatus.PAID) {
                    try {
                        Slot slot = booking.getSlot();

                        if (slot.getDate().isBefore(LocalDate.now())) {
                            System.err.println("Warning: Slot ID " + slot.getId() + " sudah lewat tanggal. Status slot TIDAK diubah.");
                        } else {
                            slot.setStatus(Slot.SlotStatus.BOOKED);
                            slotService.saveSlot(slot);
                            System.out.println("Booking PAID → Slot " + slot.getId() + " berhasil dikunci.");
                        }

                        User user = booking.getUser();
                        if (user != null && user.getFcmToken() != null && !user.getFcmToken().isEmpty()) {
                            fcmService.sendNotification(
                                user.getFcmToken(),
                                "Pembayaran Berhasil! 🎉",
                                "Booking kamu dengan " + slot.getTutor().getName() + " sudah dikonfirmasi."
                            );
                        }
                    } catch (Exception slotException) {
                        System.err.println("ERROR saat mengupdate Slot status: " + slotException.getMessage());
                    }
                }
                
                System.out.println("Status Booking ID " + orderId + " berhasil diubah menjadi: " + newStatusString);

            } else {
                System.out.println("Info: Booking ID " + orderId + " sudah PAID. Mengabaikan notifikasi.");
            }

        } else {
            System.err.println("Error: Booking dengan Order ID " + orderId + " tidak ditemukan di database.");
        }
    }

}