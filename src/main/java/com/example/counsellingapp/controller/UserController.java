package com.example.counsellingapp.controller;

import com.example.counsellingapp.model.Booking;
import com.example.counsellingapp.model.Slot;
import com.example.counsellingapp.model.User;
import com.example.counsellingapp.service.BookingService;
import com.example.counsellingapp.service.SlotService;
import com.example.counsellingapp.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
@RequestMapping("/user")
public class UserController {

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

        List<Booking> bookings = bookingService.findAllBookingsByUser(user);
        model.addAttribute("user", user);
        model.addAttribute("bookings", bookings);
        model.addAttribute("page", "dashboard");
        return "user_dashboard";
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
            // Filter berdasarkan tanggal
            slots = slotService.findByStatusAndDate(Slot.SlotStatus.AVAILABLE, date);
        } else {
            // Default: semua slot available
            slots = slotService.findByStatus(Slot.SlotStatus.AVAILABLE);
        }
        
        if (language != null && !language.isEmpty()) {
            slots = slots.stream()
                    .filter(s -> s.getPsychiatrist().getSpecialization().equalsIgnoreCase(language))
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

        model.addAttribute("user", user); 
        model.addAttribute("slots", slots);
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
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("user", user);
        return "user_profile";
    }
    
    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute User user, HttpSession session) {
        User existing = userService.findById(user.getId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        existing.setName(user.getName());;
        existing.setEmail(user.getEmail());

        if (user.getPassword() != null && !user.getPassword().isBlank()) {
            BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
            String hashedPassword = passwordEncoder.encode(user.getPassword());
            existing.setPassword(hashedPassword);
        }

        userService.saveUser(existing);
        session.setAttribute("loggedInUser", existing);
        return "redirect:/user/profile?success=true";
    }
    
    @GetMapping("/profile/delete")
    public String deleteProfile(HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");

        // Jika user tidak login, redirect ke login
        if (user == null) {
            return "redirect:/auth/login";
        }

        // Hapus user dari database
        userService.deleteById(user.getId());

        // Hapus session
        session.invalidate();

        // Redirect ke login page dengan pesan sukses
        return "redirect:/auth/login?deleted=true";
    }

}