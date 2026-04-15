package com.example.counsellingapp.repository;

import com.example.counsellingapp.model.Psychiatrist;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PsychiatristRepository extends JpaRepository<Psychiatrist, Long> {
    Optional<Psychiatrist> findByEmail(String email);
}