package com.example.counsellingapp.controller;

import com.example.counsellingapp.model.Tutor;
import com.example.counsellingapp.model.User;
import com.example.counsellingapp.service.TutorService;
import com.example.counsellingapp.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Optional;

@Controller
public class ForgotPasswordController {

    @Autowired
    private UserService userService;

    @Autowired
    private TutorService tutorService;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @GetMapping("/forgot-password")
    public String showForgotPassword() {
        return "forgot_password";
    }

    @PostMapping("/forgot-password")
    public String resetPassword(
            @RequestParam String email,
            @RequestParam String newPassword,
            Model model) {

        Optional<User> userOpt = userService.findByEmail(email);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setPassword(passwordEncoder.encode(newPassword));
            userService.saveUser(user);
            model.addAttribute("successMessage", "Password changed successfully. Please login.");
            return "forgot_password";
        }

        Optional<Tutor> tutorOpt = tutorService.findByEmail(email);
        if (tutorOpt.isPresent()) {
            Tutor tutor = tutorOpt.get();
            tutor.setPassword(passwordEncoder.encode(newPassword));
            tutorService.saveTutor(tutor);
            model.addAttribute("successMessage", "Password changed successfully. Please login.");
            return "forgot_password";
        }

        model.addAttribute("errorMessage", "Email not found.");
        return "forgot_password";
    }
}