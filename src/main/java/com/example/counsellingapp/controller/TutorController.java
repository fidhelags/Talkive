package com.example.counsellingapp.controller;

import java.util.List;
import java.util.Optional;
import java.util.stream.Stream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.counsellingapp.model.Booking;
import com.example.counsellingapp.model.Tutor;
import com.example.counsellingapp.model.Slot;
import com.example.counsellingapp.service.BookingService;
import com.example.counsellingapp.service.TutorService;
import com.example.counsellingapp.service.SlotService;
import com.example.counsellingapp.service.UserService;
import com.example.counsellingapp.service.FCMService;
import com.example.counsellingapp.model.User;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;

@Controller
@RequestMapping("/tutor")
public class TutorController {

    @Autowired
    private UserService userService;

    @Autowired
    private TutorService tutorService;

    @Autowired
    private SlotService slotService;

    @Autowired
    private BookingService bookingService;

    @Autowired
    private FCMService fcmService;

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        Tutor tutor = (Tutor) session.getAttribute("loggedInUser");
        if (tutor == null) {
            return "redirect:/login";
        }

        List<Slot> slots = slotService.findByTutor(tutor);
        List<Booking> bookings = slots.stream()
                .flatMap(s -> s.getBookings() != null ? s.getBookings().stream() : Stream.empty())
                .toList();

        int completedSessionsCount = bookings.stream()
                .filter(b -> b.getPaymentStatus() == Booking.PaymentStatus.PAID)
                .mapToInt(b -> 1)
                .sum();

        model.addAttribute("tutor", tutor);
        model.addAttribute("slots", slots);
        model.addAttribute("bookings", bookings);
        model.addAttribute("completedSessionsCount", completedSessionsCount);

        return "tutor_dashboard";
    }

    @GetMapping("/bookings")
    public String viewBookings(HttpSession session, Model model) {
        Tutor tutor = (Tutor) session.getAttribute("loggedInUser");

        if (tutor == null) {
            return "redirect:/auth/login";
        }

        List<Booking> bookings = bookingService.findByTutorId(tutor.getId());

        model.addAttribute("tutor", tutor);
        model.addAttribute("bookings", bookings);

        return "booking_list"; 
    }

    @PostMapping("/slots")
    public String saveSlot(@ModelAttribute Slot slot, HttpSession session) {
        Tutor tutor = (Tutor) session.getAttribute("loggedInUser");
        if (tutor == null) {
            return "redirect:/login";
        }

        LocalDateTime slotEnd = LocalDateTime.of(slot.getDate(), slot.getEndTime());

        if (slotEnd.isBefore(LocalDateTime.now())) {
            return "redirect:/tutor/dashboard?error=slot_past";
        }

        if (slot.getEndTime().isBefore(slot.getStartTime())
                || slot.getEndTime().equals(slot.getStartTime())) {
            return "redirect:/tutor/dashboard?error=invalid_time_range";
        }

        slot.setTutor(tutor);
        slotService.saveSlot(slot);

        return "redirect:/tutor/dashboard?success=slot_added";
    }


    @GetMapping("/bookings/{id}/send-link")
    public String sendMeetingLinkForm(@PathVariable Long id, HttpSession session, Model model) {
        Tutor tutor = (Tutor) session.getAttribute("loggedInUser");
        if (tutor == null) {
            return "redirect:/login";
        }

        Optional<Booking> bookingOpt = bookingService.findById(id);
        if (bookingOpt.isPresent()) {
            model.addAttribute("booking", bookingOpt.get());
            return "send_link_form"; 
        } else {
            return "redirect:/tutor/dashboard";
        }
    }

    @PostMapping("/bookings/{id}/send-link")
    public String sendMeetingLink(
            @PathVariable Long id,
            @RequestParam String meetingLink,
            HttpSession session
    ) {
        Tutor tutor = (Tutor) session.getAttribute("loggedInUser");
        if (tutor == null) {
            return "redirect:/login";
        }

        Booking booking = bookingService.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found"));

        if (booking.getPaymentStatus() != Booking.PaymentStatus.PAID &&
            booking.getPaymentStatus() != Booking.PaymentStatus.LINK_SENT) {
            return "redirect:/tutor/dashboard?error=booking_not_paid";
        }

        booking.setMeetingLink(meetingLink);
        booking.setPaymentStatus(Booking.PaymentStatus.LINK_SENT);
        bookingService.saveBooking(booking);

        // Kirim notif ke student
        User student = booking.getUser();
        
        if (student.getFcmToken() != null) {
            fcmService.sendNotification(
                student.getFcmToken(),
                "Meeting Link Ready 🎯",
                "Your tutor has sent the meeting link. Join your session now!"
            );
        }

        return "redirect:/tutor/bookings?success=link_sent";
    }


    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        Tutor tutor = (Tutor) session.getAttribute("loggedInUser");
        if (tutor == null) {
            return "redirect:/login";
        }

        model.addAttribute("tutor", tutor);
        return "profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute Tutor tutor, HttpSession session) {

        Tutor existing = tutorService.findById(tutor.getId())
                .orElseThrow(() -> new IllegalArgumentException("Tutor not found"));

        // =========================
        // EMAIL VALIDATION (CROSS ROLE)
        // =========================
        String newEmail = tutor.getEmail();
        String oldEmail = existing.getEmail();

        if (newEmail != null && !newEmail.equalsIgnoreCase(oldEmail)) {

            boolean emailUsedByUser = userService.existsByEmail(newEmail);
            boolean emailUsedByTutor = tutorService.existsByEmail(newEmail);

            if (emailUsedByUser || emailUsedByTutor) {
                return "redirect:/tutor/profile?error=email_taken";
            }

            existing.setEmail(newEmail);
        }

        existing.setName(tutor.getName());
        existing.setCertification(tutor.getCertification());
        existing.setLanguage(tutor.getLanguage());
        existing.setYearsExperience(tutor.getYearsExperience());

        if (tutor.getPassword() != null && !tutor.getPassword().isBlank()) {
            BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
            existing.setPassword(encoder.encode(tutor.getPassword()));
        }

        tutorService.saveTutor(existing);
        session.setAttribute("loggedInUser", existing);

        return "redirect:/tutor/profile?success=true";
    }

    @PostMapping("/slots/{id}")
    public String updateSlot(@PathVariable Long id, @ModelAttribute Slot slot, HttpSession session) {
        Tutor tutor = (Tutor) session.getAttribute("loggedInUser");
        if (tutor == null) {
            return "redirect:/login";
        }

        LocalDateTime slotStart = LocalDateTime.of(slot.getDate(), slot.getStartTime());
        LocalDateTime slotEnd   = LocalDateTime.of(slot.getDate(), slot.getEndTime());

        if (slotEnd.isBefore(LocalDateTime.now())) {
            return "redirect:/tutor/dashboard?error=slot_past";
        }

        if (!slotEnd.isAfter(slotStart)) {
            return "redirect:/tutor/dashboard?error=invalid_time_range";
        }

        Optional<Slot> existingSlotOpt = slotService.findById(id);
        if (existingSlotOpt.isPresent()) {
            Slot existingSlot = existingSlotOpt.get();
            existingSlot.setDate(slot.getDate());
            existingSlot.setStartTime(slot.getStartTime());
            existingSlot.setEndTime(slot.getEndTime());
            existingSlot.setPrice(slot.getPrice());
            existingSlot.setDuration(slot.getDuration());
            existingSlot.setLevel(slot.getLevel());
            existingSlot.setLessonType(slot.getLessonType());
            existingSlot.setDescription(slot.getDescription());
            slotService.saveSlot(existingSlot);
        }

        return "redirect:/tutor/dashboard?success=slot_updated";
    }



    @GetMapping("/slots/delete/{id}")
    public String deleteSlot(@PathVariable Long id, HttpSession session) {

        Tutor tutor = (Tutor) session.getAttribute("loggedInUser");
        if (tutor == null) {
            return "redirect:/login";
        }

        Optional<Slot> slotOpt = slotService.findById(id);
        if (slotOpt.isEmpty()) {
            return "redirect:/tutor/dashboard?error=slot_not_found";
        }

        Slot slot = slotOpt.get();

        if (!slot.getTutor().getId().equals(tutor.getId())) {
            return "redirect:/tutor/dashboard?error=unauthorized";
        }

        boolean isBooked = bookingService.findBySlot(slot).isPresent()
                || slot.getStatus() != Slot.SlotStatus.AVAILABLE;

        if (isBooked) {
            return "redirect:/tutor/dashboard?error=slot_already_booked";
        }

        slotService.deleteById(id);
        return "redirect:/tutor/dashboard?success=slot_deleted";
    }
    
     @GetMapping("/profile/delete")
    public String deleteProfile(HttpSession session) {
        Tutor tutor = (Tutor) session.getAttribute("loggedInUser");

        // Jika user tidak login, redirect ke login
        if (tutor == null) {
            return "redirect:/auth/login";
        }

        // Hapus user dari database
        tutorService.deleteById(tutor.getId());

        // Hapus session
        session.invalidate();

        // Redirect ke login page dengan pesan sukses
        return "redirect:/auth/login?deleted=true";
    }
    
    @PostMapping("/slots/range")
    public String addSlotsRange(
            @RequestParam LocalDate startDate,
            @RequestParam LocalDate endDate,
            @RequestParam LocalTime startTime,
            @RequestParam LocalTime endTime,
            @RequestParam Double price,
            @RequestParam Integer duration,
            @RequestParam String level,
            @RequestParam String lessonType,
            @RequestParam(required = false) String description,
            HttpSession session
    ) {
        Tutor tutor = (Tutor) session.getAttribute("loggedInUser");
        if (tutor == null) {
            return "redirect:/login";
        }

        // ❌ validasi jam (cukup sekali)
        if (!endTime.isAfter(startTime)) {
            return "redirect:/tutor/dashboard?error=invalid_time_range";
        }

        LocalDate date = startDate;

        while (!date.isAfter(endDate)) {

            LocalDateTime slotEnd = LocalDateTime.of(date, endTime);

            // ❌ skip slot yang sudah lewat
            if (slotEnd.isBefore(LocalDateTime.now())) {
                date = date.plusDays(1);
                continue;
            }

            Slot slot = new Slot();
            slot.setDate(date);
            slot.setStartTime(startTime);
            slot.setEndTime(endTime);
            slot.setPrice(price.intValue());
            slot.setDuration(duration);
            slot.setLevel(level);
            slot.setLessonType(lessonType);
            slot.setDescription(description);
            slot.setTutor(tutor);

            slotService.saveSlot(slot);

            date = date.plusDays(1);
        }

        return "redirect:/tutor/dashboard?success=slot_range_added";
    }


}