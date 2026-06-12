package com.example.counsellingapp.model;

import jakarta.persistence.*; 
import java.time.LocalDateTime;

import org.checkerframework.checker.units.qual.C;

@Entity
@Table(name = "chat_histories")
public class ChatHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id")
    private Long userId;

    private String sender; 

    @Column(name = "tutor_id")
    private Long tutorId;

    @Column(columnDefinition = "TEXT")
    private String message;

    private String mode;

    private String language;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;


    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getSender() { return sender; }
    public void setSender(String sender) { this.sender = sender; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getMode() { return mode; }
    public void setMode(String mode) { this.mode = mode; }

    public String getLanguage() { return language; }
    public void setLanguage(String language) { this.language = language; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public Long getTutorId() { return tutorId; }
    public void setTutorId(Long tutorId) { this.tutorId = tutorId; }
}