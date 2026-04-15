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
import com.example.counsellingapp.model.Psychiatrist;
import com.example.counsellingapp.model.Slot;
import com.example.counsellingapp.service.BookingService;
import com.example.counsellingapp.service.PsychiatristService;
import com.example.counsellingapp.service.SlotService;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;

@Controller
@RequestMapping("/psychiatrist")
public class PsychiatristController {

    @Autowired
    private PsychiatristService psychiatristService;

    @Autowired
    private SlotService slotService;

    @Autowired
    private BookingService bookingService;

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        Psychiatrist psychiatrist = (Psychiatrist) session.getAttribute("loggedInUser");
        if (psychiatrist == null) {
            return "redirect:/login";
        }

        List<Slot> slots = slotService.findByPsychiatrist(psychiatrist);
        List<Booking> bookings = slots.stream()
                .flatMap(s -> s.getBookings() != null ? s.getBookings().stream() : Stream.empty())
                .toList();

        int completedSessionsCount = bookings.stream()
                .filter(b -> b.getPaymentStatus() == Booking.PaymentStatus.PAID)
                .mapToInt(b -> 1)
                .sum();

        model.addAttribute("psychiatrist", psychiatrist);
        model.addAttribute("slots", slots);
        model.addAttribute("bookings", bookings);
        model.addAttribute("completedSessionsCount", completedSessionsCount);

        return "psychiatrist_dashboard";
    }

    @GetMapping("/bookings")
    public String viewBookings(HttpSession session, Model model) {
        Psychiatrist psychiatrist = (Psychiatrist) session.getAttribute("loggedInUser");

        if (psychiatrist == null) {
            return "redirect:/auth/login";
        }

        List<Booking> bookings = bookingService.findByPsychiatristId(psychiatrist.getId());

        model.addAttribute("psychiatrist", psychiatrist);
        model.addAttribute("bookings", bookings);

        return "booking_list"; 
    }

    @PostMapping("/slots")
    public String saveSlot(@ModelAttribute Slot slot, HttpSession session) {
        Psychiatrist psychiatrist = (Psychiatrist) session.getAttribute("loggedInUser");
        if (psychiatrist == null) {
            return "redirect:/login";
        }

        LocalDateTime slotEnd = LocalDateTime.of(slot.getDate(), slot.getEndTime());

        if (slotEnd.isBefore(LocalDateTime.now())) {
            return "redirect:/psychiatrist/dashboard?error=slot_past";
        }

        if (slot.getEndTime().isBefore(slot.getStartTime())
                || slot.getEndTime().equals(slot.getStartTime())) {
            return "redirect:/psychiatrist/dashboard?error=invalid_time_range";
        }

        slot.setPsychiatrist(psychiatrist);
        slotService.saveSlot(slot);

        return "redirect:/psychiatrist/dashboard?success=slot_added";
    }


    @GetMapping("/bookings/{id}/send-link")
    public String sendMeetingLinkForm(@PathVariable Long id, HttpSession session, Model model) {
        Psychiatrist psychiatrist = (Psychiatrist) session.getAttribute("loggedInUser");
        if (psychiatrist == null) {
            return "redirect:/login";
        }

        Optional<Booking> bookingOpt = bookingService.findById(id);
        if (bookingOpt.isPresent()) {
            model.addAttribute("booking", bookingOpt.get());
            return "send_link_form"; 
        } else {
            return "redirect:/psychiatrist/dashboard";
        }
    }

    @PostMapping("/bookings/{id}/send-link")
    public String sendMeetingLink(
            @PathVariable Long id,
            @RequestParam String meetingLink,
            HttpSession session
    ) {
        Psychiatrist psychiatrist = (Psychiatrist) session.getAttribute("loggedInUser");
        if (psychiatrist == null) {
            return "redirect:/login";
        }

        Booking booking = bookingService.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found"));

        if (booking.getPaymentStatus() != Booking.PaymentStatus.PAID) {
            return "redirect:/psychiatrist/dashboard?error=booking_not_paid";
        }

        booking.setMeetingLink(meetingLink);

        booking.setPaymentStatus(Booking.PaymentStatus.LINK_SENT);

        bookingService.saveBooking(booking);

        return "redirect:/psychiatrist/dashboard?success=link_sent";
    }


    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        Psychiatrist psychiatrist = (Psychiatrist) session.getAttribute("loggedInUser");
        if (psychiatrist == null) {
            return "redirect:/login";
        }

        model.addAttribute("psychiatrist", psychiatrist);
        return "profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute Psychiatrist psychiatrist, HttpSession session) {
        Psychiatrist existing = psychiatristService.findById(psychiatrist.getId())
                .orElseThrow(() -> new IllegalArgumentException("Psychiatrist not found"));

        existing.setName(psychiatrist.getName());
        existing.setEmail(psychiatrist.getEmail());
        existing.setStrNumber(psychiatrist.getStrNumber());
        existing.setSpecialization(psychiatrist.getSpecialization());
        existing.setYearsExperience(psychiatrist.getYearsExperience());

        if (psychiatrist.getPassword() != null && !psychiatrist.getPassword().isBlank()) {
            BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
            String hashedPassword = passwordEncoder.encode(psychiatrist.getPassword());
            existing.setPassword(hashedPassword);
        }

        psychiatristService.savePsychiatrist(existing);
        session.setAttribute("loggedInUser", existing);
        return "redirect:/psychiatrist/profile?success=true";
    }

    @PostMapping("/slots/{id}")
    public String updateSlot(@PathVariable Long id, @ModelAttribute Slot slot, HttpSession session) {
        Psychiatrist psychiatrist = (Psychiatrist) session.getAttribute("loggedInUser");
        if (psychiatrist == null) {
            return "redirect:/login";
        }

        LocalDateTime slotStart = LocalDateTime.of(slot.getDate(), slot.getStartTime());
        LocalDateTime slotEnd   = LocalDateTime.of(slot.getDate(), slot.getEndTime());

        if (slotEnd.isBefore(LocalDateTime.now())) {
            return "redirect:/psychiatrist/dashboard?error=slot_past";
        }

        if (!slotEnd.isAfter(slotStart)) {
            return "redirect:/psychiatrist/dashboard?error=invalid_time_range";
        }

        Optional<Slot> existingSlotOpt = slotService.findById(id);
        if (existingSlotOpt.isPresent()) {
            Slot existingSlot = existingSlotOpt.get();
            existingSlot.setDate(slot.getDate());
            existingSlot.setStartTime(slot.getStartTime());
            existingSlot.setEndTime(slot.getEndTime());
            existingSlot.setPrice(slot.getPrice());
            slotService.saveSlot(existingSlot);
        }

        return "redirect:/psychiatrist/dashboard?success=slot_updated";
    }



    @GetMapping("/slots/delete/{id}")
    public String deleteSlot(@PathVariable Long id, HttpSession session) {

        Psychiatrist psychiatrist = (Psychiatrist) session.getAttribute("loggedInUser");
        if (psychiatrist == null) {
            return "redirect:/login";
        }

        Optional<Slot> slotOpt = slotService.findById(id);
        if (slotOpt.isEmpty()) {
            return "redirect:/psychiatrist/dashboard?error=slot_not_found";
        }

        Slot slot = slotOpt.get();

        if (!slot.getPsychiatrist().getId().equals(psychiatrist.getId())) {
            return "redirect:/psychiatrist/dashboard?error=unauthorized";
        }

        boolean isBooked = bookingService.findBySlot(slot).isPresent()
                || slot.getStatus() != Slot.SlotStatus.AVAILABLE;

        if (isBooked) {
            return "redirect:/psychiatrist/dashboard?error=slot_already_booked";
        }

        slotService.deleteById(id);
        return "redirect:/psychiatrist/dashboard?success=slot_deleted";
    }
    
     @GetMapping("/profile/delete")
    public String deleteProfile(HttpSession session) {
        Psychiatrist psychiatrist = (Psychiatrist) session.getAttribute("loggedInUser");

        // Jika user tidak login, redirect ke login
        if (psychiatrist == null) {
            return "redirect:/auth/login";
        }

        // Hapus user dari database
        psychiatristService.deleteById(psychiatrist.getId());

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
            HttpSession session
    ) {
        Psychiatrist psychiatrist = (Psychiatrist) session.getAttribute("loggedInUser");
        if (psychiatrist == null) {
            return "redirect:/login";
        }

        // ❌ validasi jam (cukup sekali)
        if (!endTime.isAfter(startTime)) {
            return "redirect:/psychiatrist/dashboard?error=invalid_time_range";
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
            slot.setPsychiatrist(psychiatrist);

            slotService.saveSlot(slot);

            date = date.plusDays(1);
        }

        return "redirect:/psychiatrist/dashboard?success=slot_range_added";
    }


}