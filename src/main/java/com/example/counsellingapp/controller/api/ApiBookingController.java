package com.example.counsellingapp.controller.api;

import com.example.counsellingapp.model.Booking;
import com.example.counsellingapp.model.Slot;
import com.example.counsellingapp.model.User;
import com.example.counsellingapp.model.ConsultationReport;
import com.example.counsellingapp.service.BookingService;
import com.example.counsellingapp.service.SlotService;
import com.example.counsellingapp.service.UserService;
import com.example.counsellingapp.utils.MidtransPaymentUtil;
import com.midtrans.httpclient.error.MidtransError;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/api/bookings")
public class ApiBookingController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private SlotService slotService;

    @Autowired
    private UserService userService;

    /**
     * GET /api/bookings/user/{userId}
     * Semua booking milik user
     */
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Map<String, Object>>> getBookingsByUser(@PathVariable Long userId) {
        Optional<User> userOpt = userService.findById(userId);
        if (userOpt.isEmpty()) return ResponseEntity.notFound().build();

        List<Booking> bookings = bookingService.findAllBookingsByUser(userOpt.get());
        List<Map<String, Object>> result = bookings.stream().map(this::bookingToMap).toList();
        return ResponseEntity.ok(result);
    }

    /**
     * GET /api/bookings/tutor/{tutorId}
     * Semua booking yang masuk ke tutor
     */
    @GetMapping("/tutor/{tutorId}")
    public ResponseEntity<List<Map<String, Object>>> getBookingsByTutor(@PathVariable Long tutorId) {
        List<Booking> bookings = bookingService.findByTutorId(tutorId);
        List<Map<String, Object>> result = bookings.stream().map(this::bookingToMap).toList();
        return ResponseEntity.ok(result);
    }

    /**
     * GET /api/bookings/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getBookingById(@PathVariable Long id) {
        Optional<Booking> bookingOpt = bookingService.findById(id);
        if (bookingOpt.isEmpty()) return ResponseEntity.notFound().build();
        return ResponseEntity.ok(bookingToMap(bookingOpt.get()));
    }

    /**
     * POST /api/bookings
     * Buat booking + generate Midtrans Snap token
     * Body: { "userId": 1, "slotId": 5 }
     * Response: { "success": true, "bookingId": 10, "snapToken": "...", "redirectUrl": "..." }
     */
    @PostMapping
    @Transactional
    public ResponseEntity<Map<String, Object>> createBooking(@RequestBody Map<String, Object> body) {
        Map<String, Object> response = new HashMap<>();
        Long userId = Long.parseLong(body.get("userId").toString());
        Long slotId = Long.parseLong(body.get("slotId").toString());

        String source = (String) body.getOrDefault("source", "web");
        String finishUrl = source.equals("mobile")
            ? "talkive://payment?status=finish"
            : "http://localhost:8080/user/dashboard";
        String errorUrl = source.equals("mobile")
            ? "talkive://payment?status=error"
            : "http://localhost:8080/user/dashboard";
        String pendingUrl = source.equals("mobile")
            ? "talkive://payment?status=pending"
            : "http://localhost:8080/user/dashboard";

        Optional<User> userOpt = userService.findById(userId);
        Optional<Slot> slotOpt = slotService.findById(slotId);

        if (userOpt.isEmpty() || slotOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "User or Slot not found.");
            return ResponseEntity.status(404).body(response);
        }

        Slot slot = slotOpt.get();
        if (slot.getStatus() != Slot.SlotStatus.AVAILABLE) {
            response.put("success", false);
            response.put("message", "Slot is not available.");
            return ResponseEntity.status(409).body(response);
        }

        if (bookingService.findBySlot(slot).isPresent()) {
            response.put("success", false);
            response.put("message", "Slot already booked.");
            return ResponseEntity.status(409).body(response);
        }

        User user = userOpt.get();
        String orderId = "CSL-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        Booking booking = new Booking(user, slot);
        booking.setMidtransOrderId(orderId);

        try {
            Booking saved = bookingService.saveBooking(booking);
            slot.setStatus(Slot.SlotStatus.PENDING);
            slotService.saveSlot(slot);

            Map<String, String> snapResult = MidtransPaymentUtil.createSnapTransaction(
                orderId, slot.getPrice(),
                "Consultation with " + slot.getTutor().getName(), user,
                finishUrl, errorUrl, pendingUrl);

            response.put("success", true);
            response.put("bookingId", saved.getId());
            response.put("orderId", orderId);
            response.put("snapToken", snapResult.get("token"));
            response.put("redirectUrl", snapResult.get("redirect_url"));
            return ResponseEntity.ok(response);

        } catch (MidtransError e) {
            slot.setStatus(Slot.SlotStatus.AVAILABLE);
            slotService.saveSlot(slot);
            if (booking.getId() != null) bookingService.deleteById(booking.getId());
            response.put("success", false);
            response.put("message", "Payment gateway error: " + e.getMessage());
            return ResponseEntity.status(502).body(response);
        }
    }

    /**
     * POST /api/bookings/{id}/repay
     * Generate ulang Midtrans token untuk booking yang PENDING
     */
    @PostMapping("/{id}/repay")
    @Transactional
    public ResponseEntity<Map<String, Object>> repayBooking(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        Optional<Booking> bookingOpt = bookingService.findById(id);
        if (bookingOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "Booking not found.");
            return ResponseEntity.status(404).body(response);
        }

        Booking booking = bookingOpt.get();
        if (booking.getPaymentStatus() == Booking.PaymentStatus.PAID) {
            response.put("success", false);
            response.put("message", "Booking already paid.");
            return ResponseEntity.status(409).body(response);
        }

        String newOrderId = "CSL-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        booking.setMidtransOrderId(newOrderId);
        bookingService.saveBooking(booking);

        Slot slot = booking.getSlot();
        User user = booking.getUser();

        String repayFinishUrl = "talkive://payment?status=finish";
        String repayErrorUrl = "talkive://payment?status=error";
        String repayPendingUrl = "talkive://payment?status=pending";

        try {
            Map<String, String> snap = MidtransPaymentUtil.createSnapTransaction(
                newOrderId, slot.getPrice(),
                "Consultation with " + slot.getTutor().getName(), user,
                repayFinishUrl, repayErrorUrl, repayPendingUrl);

            response.put("success", true);
            response.put("orderId", newOrderId);
            response.put("snapToken", snap.get("token"));
            response.put("redirectUrl", snap.get("redirect_url"));
            return ResponseEntity.ok(response);
        } catch (MidtransError e) {
            response.put("success", false);
            response.put("message", "Payment gateway error.");
            return ResponseEntity.status(502).body(response);
        }
    }

    /**
     * POST /api/bookings/{id}/send-link
     * Tutor kirim meeting link
     * Body: { "meetingLink": "https://meet.google.com/..." }
     */
    @PostMapping("/{id}/send-link")
    public ResponseEntity<Map<String, Object>> sendMeetingLink(
            @PathVariable Long id, @RequestBody Map<String, String> body) {
        Map<String, Object> response = new HashMap<>();
        Optional<Booking> bookingOpt = bookingService.findById(id);
        if (bookingOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "Booking not found.");
            return ResponseEntity.status(404).body(response);
        }

        Booking booking = bookingOpt.get();
        if (booking.getPaymentStatus() != Booking.PaymentStatus.PAID) {
            response.put("success", false);
            response.put("message", "Booking is not paid yet.");
            return ResponseEntity.status(400).body(response);
        }

        booking.setMeetingLink(body.get("meetingLink"));
        booking.setPaymentStatus(Booking.PaymentStatus.LINK_SENT);
        bookingService.saveBooking(booking);

        response.put("success", true);
        response.put("message", "Meeting link sent.");
        return ResponseEntity.ok(response);
    }

    /**
     * POST /api/bookings/payment-callback
     * Webhook Midtrans update status
     * Body: { "orderId": "CSL-XXX", "status": "PAID"/"PENDING"/"FAILED" }
     */
    @PostMapping("/payment-callback")
    public ResponseEntity<Map<String, Object>> updatePaymentStatus(@RequestBody Map<String, String> body) {
        Map<String, Object> response = new HashMap<>();
        String orderId = body.get("orderId");
        String status = body.get("status");
        bookingService.updateBookingStatus(orderId, status);
        response.put("success", true);
        return ResponseEntity.ok(response);
    }

    // Helper: convert Booking to Map (JSON-safe, no circular refs)
    private Map<String, Object> bookingToMap(Booking b) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", b.getId());
        map.put("paymentStatus", b.getPaymentStatus().name());
        map.put("meetingLink", b.getMeetingLink());
        map.put("orderId", b.getMidtransOrderId());
        map.put("createdAt", b.getCreatedAt() != null ? b.getCreatedAt().toString() : null);

        // User info
        if (b.getUser() != null) {
            Map<String, Object> userMap = new HashMap<>();
            userMap.put("id", b.getUser().getId());
            userMap.put("name", b.getUser().getName());
            userMap.put("email", b.getUser().getEmail());
            map.put("user", userMap);
        }

        // Slot + Tutor info
        if (b.getSlot() != null) {
            Slot s = b.getSlot();
            Map<String, Object> slotMap = new HashMap<>();
            slotMap.put("id", s.getId());
            slotMap.put("date", s.getDate().toString());
            slotMap.put("startTime", s.getStartTime().toString());
            slotMap.put("endTime", s.getEndTime().toString());
            slotMap.put("price", s.getPrice());
            slotMap.put("level", s.getLevel());
            slotMap.put("lessonType", s.getLessonType());
            slotMap.put("duration", s.getDuration());
            slotMap.put("description", s.getDescription());

            if (s.getTutor() != null) {
                Map<String, Object> tutorMap = new HashMap<>();
                tutorMap.put("id", s.getTutor().getId());
                tutorMap.put("name", s.getTutor().getName());
                tutorMap.put("language", s.getTutor().getLanguage());
                tutorMap.put("yearsExperience", s.getTutor().getYearsExperience());
                slotMap.put("tutor", tutorMap);
            }
            map.put("slot", slotMap);
        }

        // Consultation Report
        if (b.getConsultationReport() != null) {
            ConsultationReport r = b.getConsultationReport();
            Map<String, Object> reportMap = new HashMap<>();
            reportMap.put("id", r.getId());
            reportMap.put("sessionSummary", r.getSessionSummary());
            reportMap.put("studentProgress", r.getStudentProgress());
            reportMap.put("strengths", r.getStrengths());
            reportMap.put("weaknesses", r.getWeaknesses());
            reportMap.put("improvement", r.getImprovement());
            reportMap.put("recommendation", r.getRecommendation());
            map.put("consultationReport", reportMap);
        }

        return map;
    }
}
