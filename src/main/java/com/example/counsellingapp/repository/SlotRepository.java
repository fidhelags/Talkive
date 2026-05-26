package com.example.counsellingapp.repository;

import com.example.counsellingapp.model.Slot;
import com.example.counsellingapp.model.Tutor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface SlotRepository extends JpaRepository<Slot, Long> {
    List<Slot> findByTutorAndDate(Tutor tutor, LocalDate date);
    List<Slot> findByDate(LocalDate date);
    List<Slot> findByStatus(Slot.SlotStatus status);
    List<Slot> findByTutor(Tutor tutor);
    List<Slot> findByDateAndStatus(LocalDate date, Slot.SlotStatus status);
    List<Slot> findByStatusAndDate(Slot.SlotStatus status, LocalDate date);
}