package com.example.counsellingapp.controller.api;

import com.example.counsellingapp.model.Tutor;
import com.example.counsellingapp.service.TutorService;
import com.example.counsellingapp.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/tutors")
public class ApiTutorController {

    @Autowired
    private TutorService tutorService;

    @Autowired
    private UserService userService;

    /**
     * GET /api/tutors
     * List semua tutor, optional filter by language
     */
    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> getAllTutors(
            @RequestParam(required = false) String language) {
        List<Tutor> tutors = tutorService.findAll();
        if (language != null && !language.isEmpty()) {
            tutors = tutors.stream()
                    .filter(t -> t.getLanguage().equalsIgnoreCase(language))
                    .toList();
        }
        List<Map<String, Object>> result = tutors.stream().map(this::tutorToMap).toList();
        return ResponseEntity.ok(result);
    }

    /**
     * GET /api/tutors/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getTutorById(@PathVariable Long id) {
        Optional<Tutor> tutorOpt = tutorService.findById(id);
        if (tutorOpt.isEmpty()) return ResponseEntity.notFound().build();
        return ResponseEntity.ok(tutorToMap(tutorOpt.get()));
    }

    /**
     * PUT /api/tutors/{id}
     * Update profil tutor
     * Body: { "name": "...", "email": "...", "language": "...", "yearsExperience": 3,
     *         "certification": "...", "password": "..." (opsional) }
     */
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateTutor(
            @PathVariable Long id, @RequestBody Map<String, Object> body) {
        Map<String, Object> response = new HashMap<>();
        Optional<Tutor> tutorOpt = tutorService.findById(id);
        if (tutorOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "Tutor not found.");
            return ResponseEntity.status(404).body(response);
        }

        Tutor tutor = tutorOpt.get();

        // Update email — cek duplikat
        String newEmail = (String) body.get("email");
        if (newEmail != null && !newEmail.equalsIgnoreCase(tutor.getEmail())) {
            if (userService.existsByEmail(newEmail) || tutorService.existsByEmail(newEmail)) {
                response.put("success", false);
                response.put("message", "Email already taken.");
                return ResponseEntity.status(409).body(response);
            }
            tutor.setEmail(newEmail);
        }

        if (body.get("name") != null) tutor.setName((String) body.get("name"));
        if (body.get("language") != null) tutor.setLanguage((String) body.get("language"));
        if (body.get("certification") != null) tutor.setCertification((String) body.get("certification"));
        if (body.get("yearsExperience") != null)
            tutor.setYearsExperience(Integer.parseInt(body.get("yearsExperience").toString()));

        String newPassword = (String) body.get("password");
        if (newPassword != null && !newPassword.isBlank()) {
            tutor.setPassword(new BCryptPasswordEncoder().encode(newPassword));
        }

        tutorService.saveTutor(tutor);

        response.put("success", true);
        response.put("tutor", tutorToMap(tutor));
        return ResponseEntity.ok(response);
    }

    // Helper
    private Map<String, Object> tutorToMap(Tutor t) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", t.getId());
        map.put("name", t.getName());
        map.put("email", t.getEmail());
        map.put("language", t.getLanguage());
        map.put("certification", t.getCertification());
        map.put("yearsExperience", t.getYearsExperience());
        return map;
    }
}
