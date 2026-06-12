package com.example.counsellingapp.repository;

import com.example.counsellingapp.model.ChatHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface ChatHistoryRepository extends JpaRepository<ChatHistory, Long> {
    
    List<ChatHistory> findByUserIdOrderByCreatedAtAsc(Long userId);
    List<ChatHistory> findByTutorIdOrderByCreatedAtAsc(Long tutorId);

    // Tambahkan 2 baris ini untuk fitur hapus (wajib pakai @Transactional)
    @Transactional
    void deleteByUserId(Long userId);

    @Transactional
    void deleteByTutorId(Long tutorId);
}