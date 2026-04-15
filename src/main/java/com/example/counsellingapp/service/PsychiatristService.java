package com.example.counsellingapp.service;

import com.example.counsellingapp.model.Psychiatrist;
import java.util.List;
import java.util.Optional;

public interface PsychiatristService {
    Psychiatrist savePsychiatrist(Psychiatrist psychiatrist);
    Optional<Psychiatrist> findById(Long id);
    Optional<Psychiatrist> findByEmail(String email);
    Optional<Psychiatrist> findByUsername(String username); 
    List<Psychiatrist> findAll();
    void deleteById(Long id);

    Psychiatrist registerPsychiatrist(String name, String email, String password,
    String strNumber, String specialization, Integer yearsExperience);
}