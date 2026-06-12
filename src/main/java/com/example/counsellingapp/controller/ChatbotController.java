package com.example.counsellingapp.controller; 

import com.example.counsellingapp.model.ChatHistory;
import com.example.counsellingapp.repository.ChatHistoryRepository;
import com.google.genai.Client;
import com.google.genai.types.GenerateContentResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Value;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class ChatbotController {

    @Autowired
    private ChatHistoryRepository chatHistoryRepository;

    @Value("${gemini.api.key}")
    private String geminiApiKey;
    // Pagar pelindung agar bot menolak topik di luar edukasi bahasa
    private String buildTopicConstraint(String lang) {
        return "STRICT RULE: You are Talkive's language learning assistant. Stay strictly within language education topics only: speaking practice, grammar, vocabulary, pronunciation, reading, writing, tutoring, lesson planning, and roleplay for language learning. "
                + "If the user asks about anything outside language education (e.g., math, coding, politics), politely refuse, decline to answer, and redirect them back to language learning topics. "
                + "Write naturally in " + lang + ".\n\n";
    }

    @PostMapping("/chat")
    public Map<String, String> handleChat(@RequestBody Map<String, Object> request) {
        String userMessage = (String) request.get("message");
        String mode = (String) request.get("mode");
        String lang = (String) request.get("language");
        
        Long userId = request.containsKey("userId") && request.get("userId") != null ? Long.valueOf(request.get("userId").toString()) : null;
        Long tutorId = request.containsKey("tutorId") && request.get("tutorId") != null ? Long.valueOf(request.get("tutorId").toString()) : null;

        if (mode == null) mode = "general";
        if (lang == null) lang = "English";

        // 1. Simpan pesan user
        saveChatToDb(userId, tutorId, "USER", userMessage, mode, lang);

        String guardrail = buildTopicConstraint(lang);
        String systemPrompt = "";

        // 2. Terapkan Prompt utuh (tanpa placeholder)
        switch (mode) {
            case "roleplay":
                systemPrompt = guardrail + "You are an interactive Native " + lang + " conversation partner for a student. The student wants to do a roleplay simulation. Follow the scenario they provide. Respond naturally and conversationally, strictly keeping your responses to 1-3 sentences to encourage the student to speak more. Do not break character. Only speak in " + lang + ".\n\nStudent says: ";
                break;
            case "grammar":
                systemPrompt = guardrail + "You are a friendly and encouraging " + lang + " Grammar and Tone Checker. The student will provide a text. Your job is to: 1) Identify grammatical errors, 2) Explain why it's wrong in simple terms, 3) Provide a corrected version, and 4) Suggest a more natural or polite way to say it in " + lang + ". Use an encouraging tone.\n\nStudent text: ";
                break;
            case "vocabulary":
                systemPrompt = guardrail + "You are an engaging " + lang + " Vocabulary Quizzer. Based on the topic the student provides, generate a quick, 3-question multiple-choice quiz to test their " + lang + " vocabulary. Wait for the student to answer before providing the correct answers and brief explanations. Keep it fun and educational.\n\nTopic: ";
                break;
            case "lesson_plan":
                systemPrompt = guardrail + "You are an expert Language Curriculum Designer assisting a " + lang + " Tutor. The tutor will provide a topic and student proficiency level. Generate a structured, practical lesson plan. Include: 1) Objective, 2) Warm-up activity, 3) Core discussion points, and 4) A wrap-up activity. Output the plan clearly.\n\nTutor request: ";
                break;
            case "task_generator":
                systemPrompt = guardrail + "You are an efficient Teaching Assistant for a " + lang + " Tutor. Based on the topic provided, generate 3 creative and practical homework assignments or tasks. Include a simple grading rubric for the tutor.\n\nTutor request: ";
                break;
            default:
                systemPrompt = guardrail + "You are a helpful native " + lang + " Assistant for Talkive. Answer concisely in " + lang + ".\n\nUser says: ";
                break;
        }

        String finalMessage = systemPrompt + userMessage;
        String aiReply = "";

        try {
            Client client = Client.builder().apiKey(geminiApiKey).build();
            GenerateContentResponse response = client.models.generateContent("gemini-3.5-flash", finalMessage, null);
            
            // Ambil teks original dari Gemini agar bisa di-render oleh Marked.js di frontend
            aiReply = response.text();
            
            saveChatToDb(userId, tutorId, "BOT", aiReply, mode, lang);

        } catch (Exception e) {
            e.printStackTrace();
            String errorMessage = e.getMessage();
            if (errorMessage != null && errorMessage.contains("503")) {
                aiReply = "Sorry, my brain is a bit overwhelmed right now! Give me a few seconds and try again. ⏳";
            } else {
                aiReply = "System Error: " + errorMessage;
            }
        }

        Map<String, String> responseData = new HashMap<>();
        responseData.put("reply", aiReply);
        return responseData;
    }

    @GetMapping("/chat/history")
    public List<ChatHistory> getChatHistory(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long tutorId) {
        
        if (userId != null) {
            return chatHistoryRepository.findByUserIdOrderByCreatedAtAsc(userId);
        } else if (tutorId != null) {
            return chatHistoryRepository.findByTutorIdOrderByCreatedAtAsc(tutorId);
        }
        return List.of(); 
    }

    @DeleteMapping("/chat/history")
    public Map<String, String> clearChatHistory(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long tutorId) {
        
        if (userId != null) {
            chatHistoryRepository.deleteByUserId(userId);
        } else if (tutorId != null) {
            chatHistoryRepository.deleteByTutorId(tutorId);
        }
        
        Map<String, String> response = new HashMap<>();
        response.put("status", "success");
        return response;
    }

    private void saveChatToDb(Long userId, Long tutorId, String sender, String message, String mode, String lang) {
        ChatHistory history = new ChatHistory();
        history.setUserId(userId);
        history.setTutorId(tutorId);
        history.setSender(sender);
        history.setMessage(message);
        history.setMode(mode);
        history.setLanguage(lang);
        chatHistoryRepository.save(history);
    }
}