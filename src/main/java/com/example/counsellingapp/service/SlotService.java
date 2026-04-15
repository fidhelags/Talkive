package com.example.counsellingapp.service;

import com.example.counsellingapp.model.Slot;
import com.example.counsellingapp.model.Psychiatrist;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface SlotService {
    Slot saveSlot(Slot slot);
    Optional<Slot> findById(Long id);

    List<Slot> findAll();                     
    List<Slot> findAllAvailableSlots();      

    List<Slot> findByPsychiatrist(Psychiatrist psychiatrist);
    List<Slot> findByPsychiatristAndDate(Psychiatrist psychiatrist, LocalDate date);

    List<Slot> findByDate(LocalDate date);    
    void deleteById(Long id);

    List<Slot> findAvailableToday();

}
