package com.example.counsellingapp.service;

import com.example.counsellingapp.model.Tutor;
import java.util.List;
import java.util.Optional;

public interface TutorService {
    Tutor saveTutor(Tutor tutor);
    Optional<Tutor> findById(Long id);
    Optional<Tutor> findByEmail(String email);
    Optional<Tutor> findByUsername(String username); 
    List<Tutor> findAll();
    void deleteById(Long id);

    boolean existsByEmail(String email); 

    Tutor registerTutor(String name, String email, String password,
    String certification, String language, Integer yearsExperience);
}