package com.example.counsellingapp.controller;

import com.example.counsellingapp.model.Booking;
import com.example.counsellingapp.model.Slot;
import com.example.counsellingapp.model.Tutor;
import com.example.counsellingapp.model.User;
import com.example.counsellingapp.service.BookingService;
import com.example.counsellingapp.service.SlotService;
import com.example.counsellingapp.service.TutorService;
import com.example.counsellingapp.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import java.util.Map;
import java.util.HashMap;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private TutorService tutorService;

    @Autowired
    private SlotService slotService;

    @Autowired
    private BookingService bookingService;

    @Autowired
    private UserService userService;

    @GetMapping("/dashboard")
    public String viewDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/auth/login";

        User refreshed = userService.findById(user.getId()).orElse(user);
        session.setAttribute("loggedInUser", refreshed);

        List<Booking> bookings = bookingService.findAllBookingsByUser(refreshed);

        List<Tutor> recommendedTutors;
        if (refreshed.getPreferredLanguage() != null && !refreshed.getPreferredLanguage().isEmpty()) {
            recommendedTutors = tutorService.findAll().stream()
                .filter(t -> t.getLanguage().equalsIgnoreCase(refreshed.getPreferredLanguage()))
                .toList();
        } else {
            recommendedTutors = tutorService.findAll();
        }

        model.addAttribute("user", refreshed);
        model.addAttribute("bookings", bookings);
        model.addAttribute("recommendedTutors", recommendedTutors);
        model.addAttribute("page", "dashboard");
        return "user_dashboard";
    }

    @PostMapping("/preference")
    public String updatePreference(@RequestParam String preferredLanguage, HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/auth/login";

        User existing = userService.findById(user.getId())
            .orElseThrow(() -> new IllegalArgumentException("User not found"));
        existing.setPreferredLanguage(preferredLanguage);
        userService.saveUser(existing);
        session.setAttribute("loggedInUser", existing);

        return "redirect:/user/slots";
    }

    @GetMapping("/slots")
    public String viewAvailableSlots(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            @RequestParam(required = false) String language,
            @RequestParam(required = false) String level,
            @RequestParam(required = false) String lessonType,
            HttpSession session,
            Model model) {

        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/auth/login";

        List<Slot> slots;
        if (date != null) {
            slots = slotService.findByStatusAndDate(Slot.SlotStatus.AVAILABLE, date);
        } else {
            slots = slotService.findByStatus(Slot.SlotStatus.AVAILABLE);
        }

        if (language != null && !language.isEmpty()) {
            slots = slots.stream()
                    .filter(s -> s.getTutor().getLanguage().equalsIgnoreCase(language))
                    .toList();
        }
        if (level != null && !level.isEmpty()) {
            slots = slots.stream()
                    .filter(s -> s.getLevel().equalsIgnoreCase(level))
                    .toList();
        }
        if (lessonType != null && !lessonType.isEmpty()) {
            slots = slots.stream()
                    .filter(s -> s.getLessonType().equalsIgnoreCase(lessonType))
                    .toList();
        }

        // Recommended Tutors
        List<Tutor> recommendedTutors;
        if (user.getPreferredLanguage() != null && !user.getPreferredLanguage().isEmpty()) {
            recommendedTutors = tutorService.findAll().stream()
                .filter(t -> t.getLanguage().equalsIgnoreCase(user.getPreferredLanguage()))
                .toList();
        } else {
            recommendedTutors = tutorService.findAll();
        }

        Map<Long, List<Slot>> tutorSlotsMap = new HashMap<>();
        for (Tutor tutor : recommendedTutors) {
            List<Slot> availableSlots = slotService.findByStatus(Slot.SlotStatus.AVAILABLE).stream()
                .filter(s -> s.getTutor().getId().equals(tutor.getId()))
                .limit(1)
                .toList();
            tutorSlotsMap.put(tutor.getId(), availableSlots);
        }

        recommendedTutors = recommendedTutors.stream()
            .filter(t -> !tutorSlotsMap.get(t.getId()).isEmpty())
            .sorted((a, b) -> b.getYearsExperience() - a.getYearsExperience())
            .limit(3)
            .toList();

        model.addAttribute("user", user);
        model.addAttribute("slots", slots);
        model.addAttribute("recommendedTutors", recommendedTutors);
        model.addAttribute("tutorSlotsMap", tutorSlotsMap);
        model.addAttribute("page", "slots");
        model.addAttribute("currentDate", date);

        return "available_slot";
    }

    @GetMapping("/bookings/{id}/pdf")
    public String viewConsultationPdf(@PathVariable Long id, Model model) {
        Optional<Booking> booking = bookingService.findById(id);
        model.addAttribute("booking", booking);
        return "pdf_view";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/login";

        User refreshed = userService.findById(user.getId()).orElse(user);
        session.setAttribute("loggedInUser", refreshed);
        model.addAttribute("user", refreshed);
        return "user_profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute User user, HttpSession session) {

        User existing = userService.findById(user.getId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        String newEmail = user.getEmail();
        String oldEmail = existing.getEmail();

        if (newEmail != null && !newEmail.equalsIgnoreCase(oldEmail)) {
            boolean emailExistsInUser = userService.existsByEmail(newEmail);
            boolean emailExistsInTutor = tutorService.existsByEmail(newEmail);

            if (emailExistsInUser || emailExistsInTutor) {
                return "redirect:/user/profile?error=email_taken";
            }

            existing.setEmail(newEmail);
        }

        existing.setName(user.getName());

        if (user.getPassword() != null && !user.getPassword().isBlank()) {
            BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
            existing.setPassword(encoder.encode(user.getPassword()));
        }

        userService.saveUser(existing);

        User refreshed = userService.findById(existing.getId()).orElse(existing);
        session.setAttribute("loggedInUser", refreshed);

        return "redirect:/user/profile?success=true";
    }

    @GetMapping("/profile/delete")
    public String deleteProfile(HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/auth/login";

        userService.deleteById(user.getId());
        session.invalidate();

        return "redirect:/auth/login?deleted=true";
    }
}