package com.example.counsellingapp.repository;

import com.example.counsellingapp.model.Slot;
import com.example.counsellingapp.model.Psychiatrist;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface SlotRepository extends JpaRepository<Slot, Long> {
    List<Slot> findByPsychiatristAndDate(Psychiatrist psychiatrist, LocalDate date);
    List<Slot> findByDate(LocalDate date);
    List<Slot> findByStatus(Slot.SlotStatus status);
    List<Slot> findByPsychiatrist(Psychiatrist psychiatrist);
    List<Slot> findByDateAndStatus(LocalDate date, Slot.SlotStatus status);
}