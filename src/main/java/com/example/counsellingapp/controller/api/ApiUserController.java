package com.example.counsellingapp.controller.api;

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
@RequestMapping("/api/users")
public class ApiUserController {

    @Autowired
    private UserService userService;

    @Autowired
    private TutorService tutorService;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateUser(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body) {

        Map<String, Object> response = new HashMap<>();

        Optional<User> userOpt = userService.findById(id);
        if (userOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "User not found.");
            return ResponseEntity.status(404).body(response);
        }

        User user = userOpt.get();

        // Cek email duplikat
        String newEmail = (String) body.get("email");
        if (newEmail != null && !newEmail.equalsIgnoreCase(user.getEmail())) {
            if (userService.existsByEmail(newEmail) || tutorService.existsByEmail(newEmail)) {
                response.put("success", false);
                response.put("message", "Email sudah digunakan.");
                return ResponseEntity.status(409).body(response);
            }
            user.setEmail(newEmail);
        }

        if (body.get("name") != null) {
            user.setName((String) body.get("name"));
        }

        String newPassword = (String) body.get("password");
        if (newPassword != null && !newPassword.isBlank()) {
            user.setPassword(passwordEncoder.encode(newPassword));
        }

        userService.saveUser(user);

        response.put("success", true);
        response.put("message", "Profile updated.");
        response.put("name", user.getName());
        response.put("email", user.getEmail());
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteUser(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        if (userService.findById(id).isEmpty()) {
            response.put("success", false);
            response.put("message", "User not found.");
            return ResponseEntity.status(404).body(response);
        }
        userService.deleteById(id);
        response.put("success", true);
        response.put("message", "Account deleted.");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getUser(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        Optional<User> userOpt = userService.findById(id);
        if (userOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "User not found.");
            return ResponseEntity.status(404).body(response);
        }
        User user = userOpt.get();
        response.put("id", user.getId());
        response.put("name", user.getName());
        response.put("email", user.getEmail());
        return ResponseEntity.ok(response);
    }

    @PostMapping("/{id}/fcm-token")
    public ResponseEntity<Map<String, Object>> saveFcmToken(
            @PathVariable Long id,
            @RequestBody Map<String, String> body) {
        Map<String, Object> response = new HashMap<>();
        Optional<User> userOpt = userService.findById(id);
        if (userOpt.isEmpty()) {
            response.put("success", false);
            return ResponseEntity.status(404).body(response);
        }
        User user = userOpt.get();
        user.setFcmToken(body.get("token"));
        userService.saveUser(user);
        response.put("success", true);
        return ResponseEntity.ok(response);
    }
}