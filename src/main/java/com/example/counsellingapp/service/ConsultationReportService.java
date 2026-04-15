package com.example.counsellingapp.service;

import com.example.counsellingapp.model.ConsultationReport;
import com.example.counsellingapp.model.Booking;

import java.util.List;
import java.util.Optional;

public interface ConsultationReportService {
    ConsultationReport saveReport(ConsultationReport report);
    Optional<ConsultationReport> findById(Long id);
    Optional<ConsultationReport> findByBooking(Booking booking);
    List<ConsultationReport> findAll();
    void deleteById(Long id);
}