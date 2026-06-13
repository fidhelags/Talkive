package com.example.counsellingapp.controller.api;

import com.example.counsellingapp.model.Tutor;
import com.example.counsellingapp.model.User;
import com.example.counsellingapp.service.TutorService;
import com.example.counsellingapp.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
public class ApiAuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private TutorService tutorService;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    /**
     * POST /api/auth/login  — khusus User (student) saja.
     * Jika email terdaftar sebagai Tutor, kembalikan error dengan pesan khusus.
     *
     * Body: { "email": "...", "password": "..." }
     * Response OK:    { "success": true, "id": 1, "name": "...", "email": "...", "preferredLanguage": "..." }
     * Response 401:   { "success": false, "message": "..." }
     * Response 403:   { "success": false, "message": "tutor_use_website" }  ← kode khusus buat Flutter
     */
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body) {
        String email    = body.get("email");
        String password = body.get("password");
        Map<String, Object> response = new HashMap<>();

        // Cek apakah email ini milik Tutor → tolak dengan kode khusus
        Optional<Tutor> tutorOpt = tutorService.findByEmail(email);
        if (tutorOpt.isPresent()) {
            response.put("success", false);
            response.put("code", "tutor_use_website");
            response.put("message", "Akun tutor tidak dapat login melalui aplikasi mobile. Silakan gunakan website Talkive.");
            return ResponseEntity.status(403).body(response);
        }

        // Cek User
        Optional<User> userOpt = userService.findByEmail(email);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (passwordEncoder.matches(password, user.getPassword())) {
                response.put("success", true);
                response.put("id", user.getId());
                response.put("name", user.getName());
                response.put("email", user.getEmail());
                response.put("preferredLanguage", user.getPreferredLanguage());
                return ResponseEntity.ok(response);
            }
        }

        response.put("success", false);
        response.put("message", "Email atau password salah.");
        return ResponseEntity.status(401).body(response);
    }

    /**
     * POST /api/auth/register  — mendaftarkan User (student) saja.
     * Field "role" tidak diperlukan dari client; selalu didaftarkan sebagai USER.
     *
     * Body: { "name": "...", "email": "...", "password": "..." }
     * Response OK:  { "success": true, "id": 1, "message": "Registration successful." }
     * Response 409: { "success": false, "message": "Email already registered." }
     */
    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(@RequestBody Map<String, Object> body) {
        String name     = (String) body.get("name");
        String email    = (String) body.get("email");
        String password = (String) body.get("password");
        Map<String, Object> response = new HashMap<>();

        // Cek duplikat email (baik di tabel users maupun tutors)
        if (userService.existsByEmail(email) || tutorService.existsByEmail(email)) {
            response.put("success", false);
            response.put("message", "Email sudah terdaftar. Silakan gunakan email lain.");
            return ResponseEntity.status(409).body(response);
        }

        User newUser = userService.registerUser(name, email, password);

        if (newUser != null) {
            response.put("success", true);
            response.put("message", "Registrasi berhasil. Silakan login.");
            response.put("id", newUser.getId());
            return ResponseEntity.ok(response);
        }

        response.put("success", false);
        response.put("message", "Registrasi gagal. Silakan coba lagi.");
        return ResponseEntity.status(400).body(response);
    }
    
    @PostMapping("/reset-password")
    public ResponseEntity<Map<String, Object>> resetPassword(
            @RequestBody Map<String, String> body) {

        String email = body.get("email");
        String newPassword = body.get("newPassword");

        Map<String, Object> response = new HashMap<>();

        // Cari di User
        Optional<User> userOpt = userService.findByEmail(email);

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setPassword(passwordEncoder.encode(newPassword));
            userService.saveUser(user);

            response.put("success", true);
            response.put("message", "Password berhasil diubah.");
            return ResponseEntity.ok(response);
        }

        // Cari di Tutor
        Optional<Tutor> tutorOpt = tutorService.findByEmail(email);

        if (tutorOpt.isPresent()) {
            Tutor tutor = tutorOpt.get();
            tutor.setPassword(passwordEncoder.encode(newPassword));
            tutorService.saveTutor(tutor);

            response.put("success", true);
            response.put("message", "Password berhasil diubah.");
            return ResponseEntity.ok(response);
        }

        response.put("success", false);
        response.put("message", "Email tidak ditemukan.");
        return ResponseEntity.status(404).body(response);
    }
}
