package com.example.counsellingapp.service.impl;

import com.example.counsellingapp.model.Psychiatrist;
import com.example.counsellingapp.model.Slot;
import com.example.counsellingapp.model.Slot.SlotStatus;
import com.example.counsellingapp.repository.SlotRepository;
import com.example.counsellingapp.service.SlotService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.ZoneId; 
import java.util.Comparator; 
import java.util.List;
import java.util.Optional;

@Service
public class SlotServiceImpl implements SlotService {

    private final SlotRepository slotRepository;
    
    private final ZoneId APP_ZONE_ID = ZoneId.of("Asia/Jakarta"); 

    @Autowired
    public SlotServiceImpl(SlotRepository slotRepository) {
        this.slotRepository = slotRepository;
    }

    @Override
    public Slot saveSlot(Slot slot) {
        return slotRepository.save(slot);
    }

    @Override
    public Optional<Slot> findById(Long id) {
        return slotRepository.findById(id);
    }

    @Override
    public List<Slot> findAll() {
        LocalDate today = LocalDate.now(APP_ZONE_ID);

        List<Slot> slots = slotRepository.findAll();

        slots.forEach(slot -> {
            if (slot.getDate().isBefore(today) && slot.getStatus() == SlotStatus.AVAILABLE) {
                slot.setStatus(SlotStatus.PASSED);
                slotRepository.save(slot);
            }
        });

        return slots;
    }

    @Override
    public List<Slot> findAllAvailableSlots() {
        LocalDate today = LocalDate.now(APP_ZONE_ID);

        return slotRepository.findByStatus(SlotStatus.AVAILABLE)
                .stream()
                .filter(slot -> !slot.getDate().isBefore(today)) // hanya today & future
                .sorted(Comparator.comparing(Slot::getDate).thenComparing(Slot::getStartTime))
                .toList();
    }

    public List<Slot> findPassedSlots() {
        LocalDate today = LocalDate.now(APP_ZONE_ID);

        return slotRepository.findAll()
                .stream()
                .filter(slot -> slot.getDate().isBefore(today))
                .sorted(Comparator.comparing(Slot::getDate).thenComparing(Slot::getStartTime))
                .toList();
    }

    @Override
    public List<Slot> findByPsychiatrist(Psychiatrist psychiatrist) {
        return slotRepository.findByPsychiatrist(psychiatrist);
    }

    @Override
    public List<Slot> findByPsychiatristAndDate(Psychiatrist psychiatrist, LocalDate date) {
        return slotRepository.findByPsychiatristAndDate(psychiatrist, date);
    }

    @Override
    public List<Slot> findByDate(LocalDate date) {
        LocalDate today = LocalDate.now(APP_ZONE_ID);

        List<Slot> slots = slotRepository.findByDate(date);

        slots.forEach(slot -> {
            if (slot.getDate().isBefore(today) && slot.getStatus() == SlotStatus.AVAILABLE) {
                slot.setStatus(SlotStatus.PASSED);
                slotRepository.save(slot);
            }
        });

        return slots;
    }

    @Override
    public void deleteById(Long id) {
        slotRepository.deleteById(id);
    }

    
    @Override
    public List<Slot> findAvailableToday() {
        LocalDate today = LocalDate.now(APP_ZONE_ID);

        return slotRepository.findByStatus(SlotStatus.AVAILABLE)
            .stream()
            .filter(slot -> slot.getDate().isEqual(today))
            .sorted(Comparator.comparing(Slot::getStartTime))
            .toList();
    }
    
    @Override
    public List<Slot> findByStatus(SlotStatus status) {
        LocalDate today = LocalDate.now(APP_ZONE_ID);

        List<Slot> slots = slotRepository.findByStatus(status);

        // update slot yang sudah lewat menjadi PASSED
        slots.forEach(slot -> {
            if (slot.getDate().isBefore(today) && slot.getStatus() == SlotStatus.AVAILABLE) {
                slot.setStatus(SlotStatus.PASSED);
                slotRepository.save(slot);
            }
        });

        // hanya tampilkan slot hari ini & masa depan
        return slots.stream()
                .filter(slot -> !slot.getDate().isBefore(today))
                .sorted(Comparator.comparing(Slot::getDate)
                        .thenComparing(Slot::getStartTime))
                .toList();
    }
    
    @Override
    public List<Slot> findByStatusAndDate(SlotStatus status, LocalDate date) {
        return slotRepository.findByStatusAndDate(status, date)
                .stream()
                .sorted(Comparator.comparing(Slot::getStartTime))
                .toList();
    }

}