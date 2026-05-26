package com.example.counsellingapp.controller;

import com.example.counsellingapp.model.User;
import com.example.counsellingapp.model.Tutor;
import com.example.counsellingapp.service.UserService;
import com.example.counsellingapp.service.TutorService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Controller
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private TutorService tutorService;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    // Halaman login
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    // Proses login
    @PostMapping("/login")
    public String login(
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            Model model
    ) {
        // Cek user
        Optional<User> userOpt = userService.findByEmail(email);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (user.getPassword() != null && passwordEncoder.matches(password, user.getPassword())) {
                session.setAttribute("loggedInUser", user); // session konsisten
                session.setAttribute("role", "USER");
                return "redirect:/user/dashboard";
            } else {
                model.addAttribute("errorMessage", "Invalid email or password.");
                return "login";
            }
        }

        // Cek psikiater
        Optional<Tutor> psychOpt = tutorService.findByEmail(email);
        if (psychOpt.isPresent()) {
            Tutor tutor = psychOpt.get();
            if (tutor.getPassword() != null && passwordEncoder.matches(password, tutor.getPassword())) {
                session.setAttribute("loggedInUser", tutor);
                session.setAttribute("role", "TUTOR");
                return "redirect:/tutor/dashboard";
            } else {
                model.addAttribute("errorMessage", "Invalid email or password.");
                return "login";
            }
        }

        model.addAttribute("errorMessage", "Invalid email or password.");
        return "login";
    }

    // Halaman register
    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    // Proses register
    @PostMapping("/register")
    public String registerUser(
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String role,
            @RequestParam(required = false) String certification,
            @RequestParam(required = false) String language,
            @RequestParam(required = false) Integer yearsExperience,
            Model model
    ) {
        boolean isRegistered = false;
        String hashedPassword = passwordEncoder.encode(password); // hash dulu

        if ("USER".equalsIgnoreCase(role)) {
            isRegistered = userService.registerUser(name, email, hashedPassword) != null;
        } else if ("TUTOR".equalsIgnoreCase(role)) {
            isRegistered = tutorService.registerTutor(
                    name, email, hashedPassword, certification, language, yearsExperience) != null;
        }

        if (isRegistered) {
            return "redirect:/auth/login";
        } else {
            model.addAttribute("errorMessage", "Registration failed. Try again.");
            return "register";
        }
    }

    // Logout
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/auth/login";
    }
}
