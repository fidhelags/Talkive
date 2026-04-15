package com.example.counsellingapp.controller;

import com.example.counsellingapp.model.Slot;
import com.example.counsellingapp.service.SlotService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/slots")
public class SlotController {

    @Autowired
    private SlotService slotService;

    @GetMapping
    public String listSlots(Model model) {
        List<Slot> slots = slotService.findAll();
        model.addAttribute("slots", slots);
        return "booking_list";
    }

    @GetMapping("/create")
    public String createForm(Model model) {
        model.addAttribute("slot", new Slot());
        return "slot_form";
    }

    @PostMapping("/create")
    public String saveSlot(@ModelAttribute Slot slot) {
        slotService.saveSlot(slot);
        return "redirect:/slots";
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Long id, Model model) {
        Optional<Slot> slotOpt = slotService.findById(id);
        if (slotOpt.isPresent()) {
            model.addAttribute("slot", slotOpt.get());
            return "slot_form";
        } else {
            return "redirect:/slots";
        }
    }

    @PostMapping("/edit/{id}")
    public String updateSlot(@PathVariable Long id, @ModelAttribute Slot slot) {
        slot.setId(id);
        slotService.saveSlot(slot);
        return "redirect:/slots";
    }

    @GetMapping("/delete/{id}")
    public String deleteSlot(@PathVariable Long id) {
        slotService.deleteById(id);
        return "redirect:/slots";
    }
}