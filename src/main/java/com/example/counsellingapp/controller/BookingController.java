package com.example.counsellingapp.controller;

import com.example.counsellingapp.model.Booking;
import com.example.counsellingapp.model.ConsultationReport;
import com.example.counsellingapp.model.Slot;
import com.example.counsellingapp.model.User;
import com.example.counsellingapp.service.BookingService;
import com.example.counsellingapp.service.EmailService;
import com.example.counsellingapp.service.PdfReportService;
import com.example.counsellingapp.service.SlotService;
import com.example.counsellingapp.utils.MidtransPaymentUtil;
import com.midtrans.httpclient.error.MidtransError;
import org.springframework.ui.Model;
import java.util.Map; 
import org.springframework.beans.factory.annotation.Value; 
import jakarta.annotation.PostConstruct; 

import jakarta.mail.MessagingException;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.example.counsellingapp.service.FCMService;

import java.util.Optional;
import java.util.UUID;

@Controller
public class BookingController {

    @Value("${midtrans.server.key}")
    private String midtransServerKey;

    @Value("${midtrans.client-key}")
    private String midtransClientKey;

    @Value("${midtrans.is-production}")
    private boolean midtransIsProduction;

    @Autowired
    private SlotService slotService;

    @Autowired
    private BookingService bookingService;

    @Autowired
    private PdfReportService pdfService;

    @Autowired
    private EmailService emailService;

    @Autowired
    private FCMService fcmService;

    @GetMapping("/bookings/create/{slotId}")
    @Transactional
    public String createBooking(@PathVariable Long slotId, HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/auth/login";

        Optional<Slot> slotOpt = slotService.findById(slotId);
        if (slotOpt.isEmpty()) return "redirect:/user/slots?error=invalid_slot";

        Slot slot = slotOpt.get();
        if (bookingService.findBySlot(slot).isPresent() || slot.getStatus() != Slot.SlotStatus.AVAILABLE)
            return "redirect:/user/slots?error=slot_unavailable";

        String orderId = "CSL-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        Booking booking = new Booking(user, slot);
        booking.setMidtransOrderId(orderId);

        try {
            Booking savedBooking = bookingService.saveBooking(booking);
            slot.setStatus(Slot.SlotStatus.PENDING);
            slotService.saveSlot(slot);

            
            Map<String, String> snapResult = MidtransPaymentUtil.createSnapTransaction(
                orderId,
                slot.getPrice(),
                "Consultation with " + slot.getTutor().getName(),
                user,
                "http://localhost:8080/user/dashboard",
                "http://localhost:8080/user/dashboard",
                "http://localhost:8080/user/dashboard");

            String redirectUrl = snapResult.get("redirect_url"); 

            return "redirect:" + redirectUrl;
        } catch (MidtransError e) {
            slot.setStatus(Slot.SlotStatus.AVAILABLE);
            slotService.saveSlot(slot);
            bookingService.deleteById(booking.getId());
            return "redirect:/user/slots?error=payment";
        }
    }

    @PostMapping("/tutor/bookings/{bookingId}/generate-report")
    @Transactional
    public String generateAndSaveReport(
            @PathVariable Long bookingId,
            @RequestParam String sessionSummary,
            @RequestParam String studentProgress,
            @RequestParam String strengths,
            @RequestParam String weaknesses, // Now we can actually use this
            @RequestParam String improvement,
            @RequestParam String recommendation
    ) {
        Booking booking = bookingService.findById(bookingId).orElse(null);
        if (booking == null) return "redirect:/tutor/bookings?error=booking_not_found";

        try {
            ConsultationReport report = new ConsultationReport();
            report.setBooking(booking);
            report.setSessionSummary(sessionSummary);
            report.setStudentProgress(studentProgress);
            report.setStrengths(strengths);
            report.setWeaknesses(weaknesses); // This will now work
            report.setImprovement(improvement);
            report.setRecommendation(recommendation);
            
            booking.setConsultationReport(report);
            booking.setPaymentStatus(Booking.PaymentStatus.COMPLETED); 
            
            bookingService.saveBooking(booking); 

            User student = booking.getUser();

            if (student.getFcmToken() != null) {
                fcmService.sendNotification(
                    student.getFcmToken(),
                    "Session Report Ready 📋",
                    "Your tutor has submitted your session report. Tap to view."
                );
            }

            return "redirect:/tutor/bookings?success=report_saved";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/tutor/bookings?error=save_failed";
        }
    }

    @GetMapping("/user/bookings/{bookingId}/pdf/download")
    public void downloadReport(@PathVariable Long bookingId, HttpServletResponse response) throws Exception {

        Booking booking = bookingService.findById(bookingId).orElse(null);

        if (booking == null || booking.getConsultationReport() == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Report not found");
            return;
        }

        ConsultationReport report = booking.getConsultationReport();

        String fullReport =
                "Student Progress:\n" + report.getStudentProgress() + "\n\n" +
                "Strengths:\n" + report.getStrengths() + "\n\n" +
                "Areas for Improvement:\n" + report.getImprovement() + "\n\n" +
                "Practice Recommendation:\n" + report.getRecommendation();

        // Pass 7 arguments to match PdfReportService
        byte[] pdfBytes = pdfService.generateReport(
                booking,
                report.getSessionSummary(),
                report.getStudentProgress(),
                report.getStrengths(),
                report.getWeaknesses(),
                report.getImprovement(),
                report.getRecommendation()
        );

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Learning_Session_Report.pdf");

        response.getOutputStream().write(pdfBytes);
    }

    @GetMapping("/user/bookings/{bookingId}/pdf/view")
    public void viewReport(@PathVariable Long bookingId, HttpServletResponse response) throws Exception {
        Booking booking = bookingService.findById(bookingId).orElse(null);

        if (booking == null || booking.getConsultationReport() == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Report not found");
            return;
        }

        ConsultationReport report = booking.getConsultationReport();

        // Call the service with the actual weaknesses from the database
        byte[] pdfBytes = pdfService.generateReport(
                booking,
                report.getSessionSummary(),
                report.getStudentProgress(),
                report.getStrengths(),
                report.getWeaknesses(),
                report.getImprovement(),
                report.getRecommendation()
        );

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=Session_Report.pdf");
        response.getOutputStream().write(pdfBytes);
    }

    @PostMapping("/bookings/update-payment/{orderId}/{status}")
    public String updatePaymentStatus(
            @PathVariable String orderId,
            @PathVariable String status) {

        bookingService.updateBookingStatus(orderId, status);
        return "redirect:/user/dashboard?payment_updated";
    }

    @GetMapping("/user/bookings/{id}/pay")
    public String redirectToPayment(@PathVariable Long id, HttpSession session) {
        Booking booking = bookingService.getBookingById(id);
        if (booking == null) return "redirect:/user/dashboard?error=booking_not_found";

        if (booking.getPaymentStatus().equals("PAID")) {
            return "redirect:/user/dashboard?info=already_paid";
        }

        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/auth/login";

        String orderId = booking.getMidtransOrderId();
        Slot slot = booking.getSlot();

        try {
            String oldOrderId = booking.getMidtransOrderId();

            String newOrderId = "CSL-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            
            booking.setMidtransOrderId(newOrderId);
            bookingService.saveBooking(booking);
            
            Map<String, String> snap = MidtransPaymentUtil.createSnapTransaction(
                newOrderId,
                slot.getPrice(),
                "Consultation with " + slot.getTutor().getName(),
                user,
                "http://localhost:8080/user/dashboard",
                "http://localhost:8080/user/dashboard",
                "http://localhost:8080/user/dashboard");

            String redirectUrl = snap.get("redirect_url");
            return "redirect:" + redirectUrl;

        } catch (MidtransError e) {
            e.printStackTrace();
            return "redirect:/user/dashboard?error=payment_midtrans_failed";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/user/dashboard?error=payment_general_failed";
        }
    }
}