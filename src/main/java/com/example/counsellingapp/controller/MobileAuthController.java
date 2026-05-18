package com.example.counsellingapp.controller;

import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@CrossOrigin(origins = "*")
@RestController
public class MobileAuthController {

    private final JdbcTemplate jdbcTemplate;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public MobileAuthController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @PostMapping("/api/auth/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> request) {
        String email = Objects.toString(request.get("email"), "").trim();
        String password = Objects.toString(request.get("password"), "");

        if (email.isEmpty() || password.isEmpty()) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("message", "Email dan password wajib diisi"));
        }

        List<Map<String, Object>> users = jdbcTemplate.queryForList(
                "SELECT id, email, password FROM users WHERE LOWER(email) = LOWER(?) ORDER BY id DESC LIMIT 1",
                email
        );

        if (users.isEmpty()) {
            System.out.println("LOGIN API: Email tidak ditemukan = " + email);

            return ResponseEntity
                    .status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("message", "Email atau password salah"));
        }

        Map<String, Object> user = users.get(0);
        String hashedPassword = Objects.toString(user.get("password"), "").trim();

        System.out.println("LOGIN API EMAIL: " + email);
        System.out.println("LOGIN API USER ID: " + user.get("id"));
        System.out.println("LOGIN API HASH LENGTH: " + hashedPassword.length());

        if (hashedPassword.length() >= 7) {
            System.out.println("LOGIN API HASH PREFIX: " + hashedPassword.substring(0, 7));
        }

        boolean passwordMatch = passwordEncoder.matches(password, hashedPassword);

        System.out.println("LOGIN API PASSWORD MATCH: " + passwordMatch);

        if (!passwordMatch) {
            return ResponseEntity
                    .status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("message", "Email atau password salah"));
        }

        return ResponseEntity.ok(
                Map.of(
                        "message", "Login berhasil",
                        "id", user.get("id"),
                        "email", user.get("email")
                )
        );
    }
}