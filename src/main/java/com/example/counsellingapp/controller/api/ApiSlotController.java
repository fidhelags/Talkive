package com.example.counsellingapp.controller.api;

import com.example.counsellingapp.model.Slot;
import com.example.counsellingapp.model.Tutor;
import com.example.counsellingapp.service.SlotService;
import com.example.counsellingapp.service.TutorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/slots")
public class ApiSlotController {

    @Autowired
    private SlotService slotService;

    @Autowired
    private TutorService tutorService;

    /**
     * GET /api/slots
     * Query params: language, level, lessonType, date (yyyy-MM-dd)
     * Returns list of AVAILABLE slots
     */
    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> getAvailableSlots(
            @RequestParam(required = false) String language,
            @RequestParam(required = false) String level,
            @RequestParam(required = false) String lessonType,
            @RequestParam(required = false) String date) {

        List<Slot> slots;
        if (date != null && !date.isEmpty()) {
            slots = slotService.findByStatusAndDate(Slot.SlotStatus.AVAILABLE, LocalDate.parse(date));
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
                    .filter(s -> level.equalsIgnoreCase(s.getLevel()))
                    .toList();
        }
        if (lessonType != null && !lessonType.isEmpty()) {
            slots = slots.stream()
                    .filter(s -> lessonType.equalsIgnoreCase(s.getLessonType()))
                    .toList();
        }

        List<Map<String, Object>> result = slots.stream().map(this::slotToMap).toList();
        return ResponseEntity.ok(result);
    }

    /**
     * GET /api/slots/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getSlotById(@PathVariable Long id) {
        Optional<Slot> slotOpt = slotService.findById(id);
        if (slotOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(slotToMap(slotOpt.get()));
    }

    /**
     * GET /api/slots/tutor/{tutorId}
     * Slots milik tutor tertentu
     */
    @GetMapping("/tutor/{tutorId}")
    public ResponseEntity<List<Map<String, Object>>> getSlotsByTutor(@PathVariable Long tutorId) {
        Optional<Tutor> tutorOpt = tutorService.findById(tutorId);
        if (tutorOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        List<Slot> slots = slotService.findByTutor(tutorOpt.get());
        List<Map<String, Object>> result = slots.stream().map(this::slotToMap).toList();
        return ResponseEntity.ok(result);
    }

    /**
     * POST /api/slots  (Tutor create slot)
     * Body: { "tutorId": 1, "date": "2025-08-01", "startTime": "09:00", "endTime": "10:00",
     *         "price": 100000, "level": "Beginner", "lessonType": "Conversation",
     *         "duration": 60, "description": "..." }
     */
    @PostMapping
    public ResponseEntity<Map<String, Object>> createSlot(@RequestBody Map<String, Object> body) {
        Map<String, Object> response = new HashMap<>();
        Long tutorId = Long.parseLong(body.get("tutorId").toString());
        Optional<Tutor> tutorOpt = tutorService.findById(tutorId);
        if (tutorOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "Tutor not found.");
            return ResponseEntity.status(404).body(response);
        }

        Slot slot = new Slot();
        slot.setTutor(tutorOpt.get());
        slot.setDate(LocalDate.parse((String) body.get("date")));
        slot.setStartTime(LocalTime.parse((String) body.get("startTime")));
        slot.setEndTime(LocalTime.parse((String) body.get("endTime")));
        slot.setPrice(Integer.parseInt(body.get("price").toString()));
        slot.setLevel((String) body.get("level"));
        slot.setLessonType((String) body.get("lessonType"));
        if (body.get("duration") != null)
            slot.setDuration(Integer.parseInt(body.get("duration").toString()));
        if (body.get("description") != null)
            slot.setDescription((String) body.get("description"));
        slot.setStatus(Slot.SlotStatus.AVAILABLE);

        Slot saved = slotService.saveSlot(slot);
        response.put("success", true);
        response.put("slot", slotToMap(saved));
        return ResponseEntity.ok(response);
    }

    /**
     * PUT /api/slots/{id}  (Tutor edit slot)
     */
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateSlot(
            @PathVariable Long id, @RequestBody Map<String, Object> body) {
        Map<String, Object> response = new HashMap<>();
        Optional<Slot> slotOpt = slotService.findById(id);
        if (slotOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "Slot not found.");
            return ResponseEntity.status(404).body(response);
        }

        Slot slot = slotOpt.get();
        if (body.get("date") != null) slot.setDate(LocalDate.parse((String) body.get("date")));
        if (body.get("startTime") != null) slot.setStartTime(LocalTime.parse((String) body.get("startTime")));
        if (body.get("endTime") != null) slot.setEndTime(LocalTime.parse((String) body.get("endTime")));
        if (body.get("price") != null) slot.setPrice(Integer.parseInt(body.get("price").toString()));
        if (body.get("level") != null) slot.setLevel((String) body.get("level"));
        if (body.get("lessonType") != null) slot.setLessonType((String) body.get("lessonType"));
        if (body.get("duration") != null) slot.setDuration(Integer.parseInt(body.get("duration").toString()));
        if (body.get("description") != null) slot.setDescription((String) body.get("description"));

        Slot saved = slotService.saveSlot(slot);
        response.put("success", true);
        response.put("slot", slotToMap(saved));
        return ResponseEntity.ok(response);
    }

    /**
     * DELETE /api/slots/{id}
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteSlot(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        Optional<Slot> slotOpt = slotService.findById(id);
        if (slotOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "Slot not found.");
            return ResponseEntity.status(404).body(response);
        }
        slotService.deleteById(id);
        response.put("success", true);
        response.put("message", "Slot deleted.");
        return ResponseEntity.ok(response);
    }

    // Helper: convert Slot entity to Map (JSON-safe)
    private Map<String, Object> slotToMap(Slot s) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", s.getId());
        map.put("date", s.getDate().toString());
        map.put("startTime", s.getStartTime().toString());
        map.put("endTime", s.getEndTime().toString());
        map.put("price", s.getPrice());
        map.put("level", s.getLevel());
        map.put("lessonType", s.getLessonType());
        map.put("duration", s.getDuration());
        map.put("description", s.getDescription());
        map.put("status", s.getStatus().name());

        // Tutor info
        Tutor t = s.getTutor();
        Map<String, Object> tutorMap = new HashMap<>();
        tutorMap.put("id", t.getId());
        tutorMap.put("name", t.getName());
        tutorMap.put("language", t.getLanguage());
        tutorMap.put("yearsExperience", t.getYearsExperience());
        tutorMap.put("certification", t.getCertification());
        map.put("tutor", tutorMap);

        return map;
    }
}
