package com.example.counsellingapp.controller;

import com.example.counsellingapp.model.User;
import com.example.counsellingapp.model.Psychiatrist;
import com.example.counsellingapp.service.UserService;
import com.example.counsellingapp.service.PsychiatristService;
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
    private PsychiatristService psychiatristService;

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
        Optional<Psychiatrist> psychOpt = psychiatristService.findByEmail(email);
        if (psychOpt.isPresent()) {
            Psychiatrist psychiatrist = psychOpt.get();
            if (psychiatrist.getPassword() != null && passwordEncoder.matches(password, psychiatrist.getPassword())) {
                session.setAttribute("loggedInUser", psychiatrist);
                session.setAttribute("role", "PSYCHIATRIST");
                return "redirect:/psychiatrist/dashboard";
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
            @RequestParam(required = false) String strNumber,
            @RequestParam(required = false) String specialization,
            @RequestParam(required = false) Integer yearsExperience,
            Model model
    ) {
        boolean isRegistered = false;
        String hashedPassword = passwordEncoder.encode(password); // hash dulu

        if ("USER".equalsIgnoreCase(role)) {
            isRegistered = userService.registerUser(name, email, hashedPassword) != null;
        } else if ("PSYCHIATRIST".equalsIgnoreCase(role)) {
            isRegistered = psychiatristService.registerPsychiatrist(
                    name, email, hashedPassword, strNumber, specialization, yearsExperience) != null;
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
