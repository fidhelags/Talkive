package com.example.counsellingapp.service;

import com.example.counsellingapp.model.Slot;
import com.example.counsellingapp.model.Tutor;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface SlotService {
    Slot saveSlot(Slot slot);
    Optional<Slot> findById(Long id);

    List<Slot> findAll();                     
    List<Slot> findAllAvailableSlots();      

    List<Slot> findByTutor(Tutor tutor);
    List<Slot> findByTutorAndDate(Tutor tutor, LocalDate date);

    List<Slot> findByDate(LocalDate date);    
    void deleteById(Long id);

    List<Slot> findAvailableToday();

    public List<Slot> findByStatusAndDate(Slot.SlotStatus slotStatus, LocalDate date);

    public List<Slot> findByStatus(Slot.SlotStatus slotStatus);

}
